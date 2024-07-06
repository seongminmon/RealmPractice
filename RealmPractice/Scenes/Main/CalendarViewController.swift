//
//  CalendarViewController.swift
//  RealmPractice
//
//  Created by 김성민 on 7/6/24.
//

import UIKit
import FSCalendar
import SnapKit

final class CalendarViewController: BaseViewController {
    
    lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko-KR")
        
        // 선택되지 않은 날의 기본 컬러 설정
        calendarView.appearance.titleDefaultColor = .white
        
        // 오늘 날짜 동그라미 없애기
        calendarView.appearance.todayColor = .clear
        
        // 초기 날짜 지정
        calendarView.setCurrentPage(Date(), animated: true)
        calendarView.select(Date())
        
        // 헤더 폰트 설정
        calendarView.appearance.headerTitleFont = .systemFont(ofSize: 18, weight: .bold)

        // Weekday 폰트 설정
        calendarView.appearance.weekdayFont = .systemFont(ofSize: 15, weight: .bold)

        // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
        calendarView.appearance.titleFont = .systemFont(ofSize: 15, weight: .bold)
        
        // 헤더의 날짜 포맷 설정
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"

        // 헤더의 폰트 색상 설정
        calendarView.appearance.headerTitleColor = UIColor.link

        // 헤더의 폰트 정렬 설정
        // .center & .left & .justified & .natural & .right
        calendarView.appearance.headerTitleAlignment = .center

        // 헤더 높이 설정
        calendarView.headerHeight = 45

        // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        
        return calendarView
    }()
    
    var sendDate: ((Date) -> Void)?
    
    override func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonClicked))
    }
    
    @objc func selectButtonClicked() {
        print(#function)
        // 선택한 날짜 넘겨주기
        if let date = calendarView.selectedDate {
            sendDate?(date)
        }
        dismiss(animated: true)
    }
    
    override func addSubviews() {
        view.addSubview(calendarView)
    }
    
    override func configureLayout() {
        calendarView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function, date)
    }
}
