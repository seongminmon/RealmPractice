//
//  NewToDoTableViewCell.swift
//  RealmPractice
//
//  Created by 김성민 on 7/2/24.
//

import UIKit
import SnapKit

final class NewToDoTableViewCell: UITableViewCell {
    static let id = "NewToDoTableViewCell"
    
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
    
    let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailImageView)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(detailImageView.snp.leading).offset(-8)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(15)
        }
    }

    func configureCell(data: String?) {
        titleLabel.text = data
    }
}
