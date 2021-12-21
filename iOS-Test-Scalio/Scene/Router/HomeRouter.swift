//
//  HomeRouter.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import Foundation

protocol HomeRouterProtocol {
    
}

class HomeRouter: HomeRouterProtocol {

    private unowned var navigationController: BaseNavigationController

    init(navBar: BaseNavigationController) {
        self.navigationController = navBar
    }
}
