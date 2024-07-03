//
//  NewToDoViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import RealmSwift
import SnapKit
import Toast

enum NewToDoCellTitle: String, CaseIterable {
    case closingDate = "마감일"
    case tag = "태그"
    case priority = "우선 순위"
    case addImage = "이미지 추가"
}

enum ToDoPriority {
    case high
    case medium
    case low
}

final class NewToDoViewController: BaseViewController {
    
    let writeView = WriteToDoView(frame: .zero)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewToDoTableViewCell.self, forCellReuseIdentifier: NewToDoTableViewCell.identifier)
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // "새로운 할 일" 뷰에서 가져야할게 뭐야?
    // 하나의 제대로된 ToDo를 만들어서 저장 누르면 Realm에 하나의 레코드를 추가하는것
    // 그렇다면 ToDo에 대한 정보를 모두 가져야 한다
    // saveButton을 눌렀을 때 제목 텍스트필드, 내용 텍스트뷰, 마감일 셀, 태그 셀, 우선 순위 셀, 이미지 추가 셀이 가지고 있는 정보들을 모아모아서 ToDo 1개를 만들어야 한다. 직접 가지지는 말고?
    // 그럼 cell에 어떻게 뿌려주지?
    // 직접 ?
    // 마감일 셀: 0번셀
    // 태그
    // 우선순위
    // 이미지 추가
    
    var closingDate: Date?
    var tag: String?
    var priority: ToDoPriority?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
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
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func addButtonClicked() {
        guard let title = writeView.titleTextField.text,
              let contents = writeView.contentsTextField.text,
              !title.isEmpty else {
            self.view.makeToast("제목을 입력해주세요")
            return
        }
        
        // Realm에 추가하기
        let realm = try! Realm()
        let todo = ToDo(title: title, contents: contents, closingDate: closingDate, date: Date())
        try! realm.write {
            realm.add(todo)
        }
        
        dismiss(animated: true)
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
        view.backgroundColor = .systemBackground
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NewToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewToDoCellTitle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewToDoTableViewCell.identifier,
            for: indexPath
        ) as? NewToDoTableViewCell else {
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
        default:
            break
        }
    }
}

extension NewToDoViewController: TagDelegate {
    func sendTag(data: String) {
        tag = data
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
}
