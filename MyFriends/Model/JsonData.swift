//
//  JsonData.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 16.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation

class JsonData<T: Decodable>: Decodable {
    
    var value: [T]
    
    enum CodingKeys: String, CodingKey {
        
        case value = "results"
    }
    
}
