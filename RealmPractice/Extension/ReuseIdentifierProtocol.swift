//
//  ReuseIdentifierProtocol.swift
//  RealmPractice
//
//  Created by 김성민 on 7/3/24.
//

import UIKit

protocol ReuseIdentifierProtocol: AnyObject {
    static var identifier: String { get }
}

extension UITableViewCell: ReuseIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
