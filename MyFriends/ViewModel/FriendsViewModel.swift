//
//  FriendsViewModel.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 18.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData


class FriendsViewModel {
    
    var service = UserService()
    
    private var friendsRelay = BehaviorRelay<[UserData]>(value: [])
    
    var friends: Observable<[UserData]> {
        return friendsRelay.asObservable()
    }
    
    var hasFriends: Observable<Bool> {
        return friendsRelay.map {
            $0.count > 0
        }
    }
    
    var noFriendsText: Observable<String> {
        
        return Observable.just("No friends")
    }
    
    func getFriends() {
        do { friendsRelay.accept(try service.getUsers().map(UserData.init(user:))) }
        catch { print("Error")}
    }
    
    func markFriends(uuid: UUID) {
        do {
           try service.markUser(uuid: uuid)
        } catch {
            print(error)
        }
    }
    
    init() {
        getFriends()
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        getFriends()
    }
}

