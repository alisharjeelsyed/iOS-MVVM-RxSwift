//
//  AppCoordinator.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import UIKit

final class AppRouter {
    
    class func start(window: UIWindow?,
                     navBar: BaseNavigationController = BaseNavigationController()) {
        guard let window = window else { return }
        navBar.setAppearance()
        navBar.viewControllers = [getInitialRootVC(navBar: navBar)]
        window.rootViewController = navBar
        window.makeKeyAndVisible()
    }
    
    class func getInitialRootVC(navBar: BaseNavigationController = BaseNavigationController()) -> UIViewController {
        // Here we can add conditions,
        // if we have multiple options
        return HomeBuilder().build(navBar: navBar)
    }
}
