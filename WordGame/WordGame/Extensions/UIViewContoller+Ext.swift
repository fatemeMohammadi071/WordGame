//
//  UIViewContoller+Ext.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import UIKit

extension UIViewController: NibLoadable {}

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
    static var bundle: Bundle { get }
}

public extension NibLoadable where Self: UIViewController {
    static var nibName: String {
        return String(describing: self)
    }

    static var bundle: Bundle {
        return Bundle(for: Self.self)
    }
}
