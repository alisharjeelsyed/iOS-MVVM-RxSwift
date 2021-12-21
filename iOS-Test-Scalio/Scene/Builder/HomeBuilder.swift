//
//  HomeBuilder.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import UIKit

final class HomeBuilder {
    
    func build(navBar: BaseNavigationController = BaseNavigationController()) -> UIViewController {

        let router = HomeRouter(navBar: navBar)
        let homeVM = HomeViewModel(network: HomeService(), router: router)
        let homeVC = HomeViewController.instantiate(viewModel: homeVM)
        return homeVC
    }
}
