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
    var description: String
    var width: Int
    var height: Int
    
    init?(jsonDictionary: [String: Any]) {
        guard let id = jsonDictionary["id"] as? Int else { return nil }
        guard let name = jsonDictionary["name"] as? String else { return nil }
        guard let description = jsonDictionary["description"] as? String else { return nil }
        guard let width = jsonDictionary["width"] as? Int else { return nil }
        guard let height = jsonDictionary["height"] as? Int else { return nil }
        
        self.id = id
        self.name = name
        self.description = description
        self.width = width
        self.height = height
    }
}
