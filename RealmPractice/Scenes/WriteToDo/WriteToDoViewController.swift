//
//  WriteToDoViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import PhotosUI
import RealmSwift
import SnapKit
import Toast

enum NewToDoCellTitle: String, CaseIterable {
    case closingDate = "마감일"
    case tag = "태그"
    case priority = "우선 순위"
    case addImage = "이미지 추가"
}

// MARK: - 1. 새로운 할 일 / 2. 수정, 삭제 => 두 화면 재활용
final class WriteToDoViewController: BaseViewController {
    
    let writeView = WriteToDoView(frame: .zero)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WriteToDoTableViewCell.self, forCellReuseIdentifier: WriteToDoTableViewCell.identifier)
        tableView.rowHeight = 60
        return tableView
    }()
    
    let repository = ToDoRepository()
    var todo: ToDo?     // 추가일땐 todo가 nil, 수정 or 삭제 일땐 todo값 존재
    
    var closingDate: Date?
    var tag: String?
    var priority: Int?
    
    var realmNotify: (() -> Void)?
    var realmDeleteNotify: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo {
            closingDate = todo.closingDate
            tag = todo.tag
            priority = todo.priority
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(priorityNotification),
            name: Notification.Name("priority"),
            object: nil
        )
    }
    
    override func configureNavigationBar() {
        if todo == nil {
            navigationItem.title = "새로운 할 일"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "취소",
                style: .plain,
                target: self,
                action: #selector(cancelButtonClicked)
            )
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "추가",
                style: .plain,
                target: self,
                action: #selector(addButtonClicked)
            )
        } else {
            navigationItem.title = "할 일 수정하기"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "취소",
                style: .plain,
                target: self,
                action: #selector(cancelButtonClicked)
            )
            
            let updateButton = UIBarButtonItem(
                title: "수정",
                style: .plain,
                target: self,
                action: #selector(updateButtonClicked)
            )
            
            let deleteButton = UIBarButtonItem(
                title: "삭제",
                style: .done,
                target: self,
                action: #selector(deleteButtonClicked)
            )
            deleteButton.tintColor = .systemRed
            navigationItem.rightBarButtonItems = [updateButton, deleteButton]
        }
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        guard let title = writeView.titleTextField.text,
              !title.isEmpty else {
            self.view.makeToast("제목을 입력해주세요")
            return
        }
        
        // 플레이스 홀더 내용 안 들어가도록 처리
        var contents = writeView.contentsTextView.text
        if writeView.contentsTextView.textColor == .lightGray {
            contents = nil
        }
        
        // Realm Create
        let todo = ToDo(
            title: title,
            contents: contents,
            closingDate: closingDate,
            tag: tag,
            priority: priority,
            date: Date()
        )
        
        repository.addItem(todo)
        
        // 메인뷰에 변경되었다고 알려주기
        realmNotify?()
        
        dismiss(animated: true)
    }
    
    @objc func updateButtonClicked() {
        guard let title = writeView.titleTextField.text,
              !title.isEmpty else {
            self.view.makeToast("제목을 입력해주세요")
            return
        }
        
        // 플레이스 홀더 내용 안 들어가도록 처리
        var contents = writeView.contentsTextView.text
        if writeView.contentsTextView.textColor == .lightGray {
            contents = nil
        }
        
        repository.updateItem(
            todo!,
            title: title,
            contents: contents,
            closingDate: closingDate,
            tag: tag,
            priority: priority
        )
        
        realmNotify?()   // list 뷰에 변경되었다고 알려주기
        dismiss(animated: true)
    }
    
    @objc func deleteButtonClicked() {
        presentAlert(title: "삭제", message: "정말 삭제하시겠습니까?", actionTitle: "삭제") { _ in
            self.repository.deleteItem(self.todo!)
            self.realmDeleteNotify?()  // list 뷰에 변경되었다고 알려주기
            self.dismiss(animated: true)
        }
    }
    
    override func addSubviews() {
        view.addSubview(writeView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        writeView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(writeView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        if let todo {
            writeView.titleTextField.text = todo.title
            writeView.contentsTextView.text = todo.contents
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func priorityNotification(notification: NSNotification) {
        priority = notification.userInfo?["priority"] as? Int
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
}

extension WriteToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewToDoCellTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WriteToDoTableViewCell.identifier,
            for: indexPath
        ) as? WriteToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let option = NewToDoCellTitle.allCases[indexPath.row]
        let title = option.rawValue
        cell.configureTitle(title)
        switch option {
        case .closingDate:
            cell.configureDate(closingDate)
        case .tag:
            cell.configureTag(tag)
        case .priority:
            cell.configurePriority(priority)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = NewToDoCellTitle.allCases[indexPath.row]
        switch title {
        case .closingDate:
            // 1. closure
            let vc = DateViewController()
            vc.sendDate = { data in
                self.closingDate = data
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            navigationController?.pushViewController(vc, animated: true)
            
        case .tag:
            // 2. delegate
            let vc = TagViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        case .priority:
            // 3. notification
            let vc = PriorityViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case .addImage:
            // TODO: - PHPicker 갤러리에서 사진 선택하기
            let config = PHPickerConfiguration(photoLibrary: .shared())
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
            break
        }
    }
}

extension WriteToDoViewController: TagDelegate {
    func sendTag(data: String) {
        tag = data
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}

extension WriteToDoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
    }
    
    
}
