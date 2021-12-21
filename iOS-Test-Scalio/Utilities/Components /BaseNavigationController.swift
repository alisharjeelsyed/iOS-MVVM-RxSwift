//
//  BaseNavigationController.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import UIKit

open class BaseNavigationController: UINavigationController {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    public init() {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    func setAppearance(){
        self.navigationBar.isHidden = true
    }
}

open class NavigationBar: UINavigationBar {

}
