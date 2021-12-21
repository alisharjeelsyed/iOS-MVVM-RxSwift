//
//  UserTableCellViewModel.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 15/12/2021.
//

import Foundation

protocol UserCellViewModelProtocol: AnyObject {

    var userImageUrlStr: String { get }
    var userName: String { get }
    var userType: String { get }
}

final class UserCellViewModel: UserCellViewModelProtocol {
    
    var userImageUrlStr: String {
        get {
            return item.avatarUrl ?? ""
        }
    }
    
    var userName: String {
        get {
            return item.login ?? ""
        }
    }
    
    var userType: String {
        get {
            return "User Type: \(item.type ?? "")"
        }
    }
    
    private var item: Item

    init(data: Item) {
        self.item = data
    }
    
}
