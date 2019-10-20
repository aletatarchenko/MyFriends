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
import Moya

class UsersViewModel {
    
    var disposeBag = DisposeBag()
    var service = UserService()
    
    private var usersRelay = BehaviorRelay<[UserData]>(value: [])
    
    var users: Observable<[UserData]> {
        return usersRelay.asObservable()
    }
    
    var countUsers: Int  {
        return usersRelay.value.count
    }
    
    private var isDownloadRelay = BehaviorRelay<Bool>(value: false)
    
    var isDownload: Bool {
        return isDownloadRelay.value
    }
    
    private var networkConnectionErrorRelay = PublishRelay<Error>()
    
    var networkConnectionError: Observable<Error> {
        return networkConnectionErrorRelay.asObservable()
    }
    init() {
        getUsers()
    }
    
    func getUsers(count: Int = 50) {
        
        isDownloadRelay.accept(true)
        disposeBag = DisposeBag()
        
        Service.getUsers(count: count)
            .asObservable()
            .do(onError: {
                self.isDownloadRelay.accept(false)
                if case let MoyaError.underlying(mError, _) = $0,
                    (mError as NSError).code == NSURLErrorNotConnectedToInternet {
                    self.networkConnectionErrorRelay.accept($0)
                }
            })
            .catchErrorJustReturn([])
            .subscribe(onNext: {
                self.usersRelay.accept(self.usersRelay.value + $0)
            },  onCompleted: {
                self.isDownloadRelay.accept(false)
            }, onDisposed: {
                self.isDownloadRelay.accept(false)
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
