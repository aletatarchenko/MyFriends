//
//  Service.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 16.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Moya

class Service {
    
    class func getUsers(count: Int = 50) -> Observable<[UserData]> {
        return API.rx.request(.users(count: count))
            .map { try $0.map(JsonData<UserData>.self).value }
            .asObservable()
    }
    
}
