//
//  SearchRequest.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import Foundation

struct SearchRequest: Codable {
    var searchQuery: String = ""
    var page: Int = 1
    let pageLimit: Int = Constants.paginationPageLimit
    
    enum CodingKeys: String, CodingKey {
        case searchQuery = "q"
        case pageLimit = "per_page"
        case page
    }
}
