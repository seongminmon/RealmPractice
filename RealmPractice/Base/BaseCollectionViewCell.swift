//
//  BaseCollectionViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/3/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        
    }
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 10
        let cellSpacing: CGFloat = 10
        let cellCount: CGFloat = 2
        
        // 셀 사이즈
        let totalWidth = UIScreen.main.bounds.width - 2 * sectionSpacing - (cellCount-1) * cellSpacing
        let width = totalWidth / cellCount
        let rate = 0.5
        let height = width * rate
        layout.itemSize = CGSize(width: width, height: height)
        // 스크롤 방향
        layout.scrollDirection = .vertical
        // 셀 사이 거리 (가로)
        layout.minimumInteritemSpacing = cellSpacing
        // 셀 사이 거리 (세로)
        layout.minimumLineSpacing = cellSpacing
        // 섹션 인셋
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        
        return layout
    }
}
