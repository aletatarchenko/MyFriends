//
//  User.swift
//  MyFriends
//
//  Created by Alexey Tatarchenko on 16.10.2019.
//  Copyright © 2019 Alexey Tatarchenko. All rights reserved.
//

import Foundation

struct UserData: Decodable {
    
    let uuid: UUID
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var image: Data?
    var urlForImage: URL?
    
    var fullName: String {
        return "\(firstName) \(lastName)" == " " ? "No name" :  "\(firstName) \(lastName)"
    }
    
    init(user: User) {
        uuid            = user.uuid ?? UUID()
        firstName       = user.firstName ?? ""
        lastName        = user.lastName ?? ""
        email           = user.email ?? ""
        phoneNumber     = user.phoneNumber ?? ""
        image           = user.image
        urlForImage     = user.imageForServer
    }
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phoneNumber = "phone"
        case picture
        case login
    }
    
    enum NameCodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName  = "last"
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case urlForImage = "medium"
    }
    
    enum LoginCodingKeys: String, CodingKey {
        case uuid 
    }
    
    init(from decoder: Decoder) throws {
        
        let container           = try decoder.container(keyedBy: CodingKeys.self)
        email                   = try container.decode(String.self, forKey: .email)
        phoneNumber             = try container.decode(String.self, forKey: .phoneNumber)
        
        let nameContainer       = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        firstName               = try nameContainer.decode(String.self, forKey: .firstName)
        lastName                = try nameContainer.decode(String.self, forKey: .lastName)
        
        let pictureContainer    = try container.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        urlForImage             = try pictureContainer.decode(URL.self, forKey: .urlForImage)
        
        let loginContainer      = try container.nestedContainer(keyedBy: LoginCodingKeys.self, forKey: .login)
        uuid                    = UUID(uuidString: try loginContainer.decode(String.self, forKey: .uuid))!
    }
    
}
