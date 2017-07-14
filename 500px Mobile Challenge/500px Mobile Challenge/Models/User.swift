//
//  User.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-14.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var username: String
    var fullName: String
    var userPicUrl: String
    
    init?(jsonDictionary: [String: Any]) {
        guard let id = jsonDictionary["id"] as? Int else { return nil }
        guard let username = jsonDictionary["username"] as? String else { return nil }
        guard let fullName = jsonDictionary["fullname"] as? String else { return nil }
        guard let userPicUrl = jsonDictionary["userpic_url"] as? String else { return nil }
        
        self.id = id
        self.username = username
        self.fullName = fullName
        self.userPicUrl = userPicUrl
    }
}
