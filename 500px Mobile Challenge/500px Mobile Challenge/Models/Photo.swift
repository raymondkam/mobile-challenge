//
//  Photo.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-12.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import Foundation

class Photo {
    var id: Int
    var name: String
    var width: Int
    var height: Int
    var images: [[String: Any]]
    var votesCount: Int
    var isNsfw: Bool
    var user: User
    
    init?(jsonDictionary: [String: Any]) {
        guard let id = jsonDictionary["id"] as? Int else { return nil }
        guard let name = jsonDictionary["name"] as? String else { return nil }
        guard let width = jsonDictionary["width"] as? Int else { return nil }
        guard let height = jsonDictionary["height"] as? Int else { return nil }
        guard let images = jsonDictionary["images"] as? [[String: Any]] else { return nil }
        guard let votesCount = jsonDictionary["votes_count"] as? Int else { return nil }
        guard let isNsfw = jsonDictionary["nsfw"] as? Bool else { return nil }
        guard let userDictionary = jsonDictionary["user"] as? [String: Any] else { return nil }
        guard let user = User(jsonDictionary: userDictionary) else { return nil }
        
        self.id = id
        self.name = name
        self.width = width
        self.height = height
        self.images = images
        self.votesCount = votesCount
        self.isNsfw = isNsfw
        self.user = user
    }
}
