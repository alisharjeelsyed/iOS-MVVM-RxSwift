//
//  SearchResultResponse.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import Foundation

struct SearchResultResponse: Codable {

    var totalCount: Int
    var items: [Item]

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}

struct Item: Codable {

    let id :Int
    let login: String?
    let avatarUrl: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id, login, type
        case avatarUrl = "avatar_url"
    }
}
