//
//  NewToDoTableViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

final class NewToDoTableViewCell: BaseTableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    override func addSubviews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        containerView.addSubview(detailImageView)
        contentView.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(8)
            make.width.equalTo(100)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalTo(detailImageView.snp.leading).offset(-8)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(15)
        }
    }

    func configureTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func configureDate(_ date: Date?) {
        detailLabel.text = date?.dateToString()
    }
    
    func configureTag(_ tag: String?) {
        guard let tag else { return }
        detailLabel.text = "#" + tag
    }
    
    func configurePriority(_ priority: Int?) {
        guard let priority else { return }
        detailLabel.text = ToDoPriority.allCases[priority].rawValue
    }
}
