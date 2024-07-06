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
    
    let containerView: ContainerView = {
        let view = ContainerView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var calendarView: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.scope = .month
        calendarView.locale = Locale(identifier: "ko-KR")
        
        // 선택되지 않은 날의 기본 컬러 설정
        calendarView.appearance.titleDefaultColor = .black
        
        // 선택된 날의 기본 컬러 설정
        calendarView.appearance.selectionColor = .black
        
        // 오늘 날짜 기본 컬러
        calendarView.appearance.titleTodayColor = .black
        
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
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.addTarget(self, action: #selector(selectButtonClicked), for: .touchUpInside)
        return button
    }()
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func selectButtonClicked() {
        print(#function)
        // 선택한 날짜 넘겨주기
        if let date = calendarView.selectedDate {
            sendDate?(date)
        }
        dismiss(animated: true)
    }
    
    var sendDate: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    override func addSubviews() {
        containerView.addSubview(calendarView)
        containerView.addSubview(cancelButton)
        containerView.addSubview(selectButton)
        view.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(300)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top).offset(-8)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
        
        selectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        // TODO: - .up일때는 animation 안되는 문제
        
        if swipe.direction == .up {
            calendarView.scope = .week
            containerView.snp.updateConstraints { make in
                make.height.equalTo(150)
            }
        } else if swipe.direction == .down {
            calendarView.scope = .month
            containerView.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(#function, date)
    }
}
