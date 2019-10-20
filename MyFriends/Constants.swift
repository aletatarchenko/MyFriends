//
//  Constants.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 16.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation

class Constants {
    
    static let baseURL: URL = {
        
        if let urlString = Bundle.main.infoDictionary?.value(typeOf: String.self, forKey: "API_BASE_URL") {
            return URL(string: urlString)!
        }
        fatalError("BaseURL is undefined")
    }()
}

extension Dictionary where Key == String, Value == Any {
    
    func value<T>(typeOf: T.Type, forKey key: String) -> T? {
        
        return self[key] as? T
    }
    
}
