//
//  ProfileViewModel.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 19.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreData

class ProfileViewModel {
    
    var service = UserService()
    
    private(set) var friendData: UserData
    
    init(friend: UserData) {
        self.friendData = friend
    }
    
    func updateFriend() {
        do { try service.updateUser(userData: friendData) }
        catch { print(error) }
    }
    
    func updateAvatar(data: Data) {
        friendData.image = data
    }
    
    func updateData(with type: FriendTextItemType, value: String) {
        
        switch type {
            
        case .firstname:
             friendData.firstName = value
        case .lastname:
             friendData.lastName = value
        case .mobile:
             friendData.phoneNumber = value
        case .email:
             friendData.email = value
        }
    }
    
    func getData(for type: FriendTextItemType) -> String {
        
        switch type {
            
        case .firstname:
            return friendData.firstName
        case .lastname:
            return friendData.lastName
        case .mobile:
            return friendData.phoneNumber
        case .email:
            return friendData.email
        }
    }
}


enum FriendTextItemType: Int {
    
    case firstname
    case lastname
    case email
    case mobile
 
}
