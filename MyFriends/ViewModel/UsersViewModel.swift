//
//  UsersViewModel.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 17.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Moya
import Reachability
import RxReachability

class UsersViewModel {
    
    var disposeBag = DisposeBag()
    var service = UserService()
    var reachability = Reachability()
    private var usersRelay = BehaviorRelay<[UserSection]>(value: [])
    
    var driveUsers: Driver<[UserSection]> {
        return usersRelay.asDriver()
    }
    
    var users: Int  {
        return usersRelay.value.count
    }
    
    private var isLoading = BehaviorRelay<Bool>(value: true)
    
    var driveIsLoading: Driver<Bool> {
        return isLoading.asDriver()
    }
    
    init() {
        getUsers()
    }
    
    func getUsers(count: Int = 50) {
        
        disposeBag = DisposeBag()
        
        Service.getUsers(count: count)
            .asObservable()
            .subscribe(
                onNext: {
                    let items = Array((self.usersRelay.value.first?.items ?? [])
                        .dropLast())
                        + $0.map { .userData($0) }
                        + [.activity]
                    
                    self.usersRelay.accept([UserSection(items: items)])
                    self.isLoading.accept(false)
            },
                onError: { _ in
                    self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func saveUser(user: UserData) {
        do {
            try service.saveUser(userData: user)
        } catch {
            print(error)
        }
    }
}


struct UserSection: SectionModelType {
    
    typealias Item = UsersItem
    var title: String?
    var items: [Item]
    
    init(original: UserSection, items: [UsersItem]) {
        self = original
        self.items = items
    }
    init(items: [UsersItem]) {
        self.items = items
    }
}

enum UsersItem {
    
    case userData(UserData)
    case activity
}
