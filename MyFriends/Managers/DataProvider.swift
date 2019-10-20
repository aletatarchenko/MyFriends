//
//  DataProvider.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 17.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import CoreData

class DataProvider {
    
    static let shared = DataProvider()
    
    private init() {}
    
    var localPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MyFriends")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
