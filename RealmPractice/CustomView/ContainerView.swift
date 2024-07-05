//
//  ContainerView.swift
//  RealmPractice
//
//  Created by 김성민 on 7/5/24.
//

import UIKit

final class ContainerView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        clipsToBounds = true
        layer.cornerRadius = 10
    }
}
