//
//  PriorityViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/3/24.
//

import UIKit
import SnapKit

enum ToDoPriority: String, CaseIterable {
    case high = "높음"
    case medium = "보통"
    case low = "낮음"
}

final class PriorityViewController: BaseViewController {
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ToDoPriority.allCases.map { $0.rawValue }
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let data = ToDoPriority.allCases[segmentedControl.selectedSegmentIndex]
        NotificationCenter.default.post(
            name: Notification.Name("priority"),
            object: nil,
            userInfo: [0: data]
        )
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "우선 순위 설정하기"
    }
    
    override func addSubviews() {
        view.addSubview(segmentedControl)
    }
    
    override func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
