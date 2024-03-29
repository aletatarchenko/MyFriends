//
//  UserService.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 20.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation
import CoreData

class UserService {
    
    let db = DataProvider.shared
    
    func saveUser(userData: UserData) throws {
        
        let user = User(context: db.localPersistentContainer.viewContext)
        user.email          = userData.email
        user.firstName      = userData.firstName
        user.lastName       = userData.lastName
        user.uuid           = userData.uuid
        user.phoneNumber    = userData.phoneNumber
        user.imageUrl       = userData.imageUrl
        
        try db.localPersistentContainer.viewContext.save()
        
    }
    
    func updateUser(userData: UserData) throws {
        let user = try! getUser(uuid: userData.uuid)
        user?.email         = userData.email
        user?.firstName     = userData.firstName
        user?.lastName      = userData.lastName
        user?.phoneNumber   = userData.phoneNumber
        user?.imageUrl      = userData.imageUrl

        try db.localPersistentContainer.viewContext.save()
        
    }
    
    func getUsers() throws -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateToRemove == nil")
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try db.localPersistentContainer.viewContext.fetch(fetchRequest)
    }
    
    func getUser(uuid: UUID) throws -> User? {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", argumentArray: [uuid])
        
        return try db.localPersistentContainer.viewContext.fetch(fetchRequest).first
    }
    
    func markUser(uuid: UUID) throws {
        try getUser(uuid: uuid)?.dateToRemove = Date()
        try db.localPersistentContainer.viewContext.save()
        
    }
}




