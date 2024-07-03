//
//  DateViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit

final class DateViewController: BaseViewController {
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    var sendDate: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sendDate?(datePicker.date)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "마감일 고르기"
    }
    
    override func addSubviews() {
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
