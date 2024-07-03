//
//  MainCollectionViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/3/24.
//

import UIKit
import SnapKit

final class MainCollectionViewCell: BaseCollectionViewCell {
    
    let containerView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let imageContainerView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    let mainImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    let descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    let countLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .right
        return label
    }()
    
    override func addSubviews() {
        imageContainerView.addSubview(mainImageView)
        containerView.addSubview(imageContainerView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(countLabel)
        contentView.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).offset(4)
            make.leading.equalTo(imageContainerView).inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(imageContainerView.snp.trailing).offset(-8)
        }
    }
    
    override func configureView() {
        // "calendar"
        // "flag.fill"
        // "checkmark"
        imageContainerView.backgroundColor = .systemBlue
        mainImageView.image = UIImage(systemName: "calendar")
        descriptionLabel.text = "전체"
    }
    
    func configureCell(count: Int) {
        countLabel.text = "\(count)"
    }
}
