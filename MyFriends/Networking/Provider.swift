//
//  Provider.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 16.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import Moya

let API = MoyaProvider<Frineds>(plugins: [NetworkLoggerPlugin(verbose: false)])

enum Frineds: TargetType{
    
    case users(count: Int)
    
    var baseURL: URL {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
            
        case .users:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .users(count):
            return .requestParameters(parameters: ["format": "json", "results": count],
                                      encoding: URLEncoding.default)
       
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var validationType: ValidationType {
        return .none
    }
}
