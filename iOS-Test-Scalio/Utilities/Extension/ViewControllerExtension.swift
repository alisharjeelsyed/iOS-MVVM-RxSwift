//
//  ViewControllerExtension.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let name = String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: .main)
        return instantiate(self, from: storyboard)
    }

    private static func instantiate<T: UIViewController>(_ type: T.Type, from storyboard: UIStoryboard) -> T {
        let controller = storyboard.instantiateInitialViewController() as! T
        return controller
    }
}
