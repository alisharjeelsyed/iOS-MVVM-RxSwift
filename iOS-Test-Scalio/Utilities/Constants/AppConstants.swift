//
//  AppConstants.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import Foundation

public struct APIConstants {

    static var baseURL: String {
        return "https://api.github.com"
    }
    
    static var searchUsers: String {
        return "/search/users"
    }
}

public struct Constants {

    static let paginationPageLimit: Int = 9

}

