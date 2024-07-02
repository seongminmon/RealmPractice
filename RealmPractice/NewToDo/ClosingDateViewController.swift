//
//  ClosingDateViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit

final class ClosingDateViewController: UIViewController {

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addSubviews()
        configureLayout()
        configureView()
    }
    
    func configureNavigationBar() {
        
    }
    
    func addSubviews() {
        view.addSubview(datePicker)
    }
    
    func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
}
