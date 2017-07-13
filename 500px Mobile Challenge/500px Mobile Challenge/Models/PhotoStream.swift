//
//  PhotoStream.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-12.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import Foundation

class PhotoStream {
    var feature: String
    var currentPage: Int
    var totalPages: Int
    var totalItems: Int
    var photos: [Photo]
    
    init?(jsonDictionary: [String: Any]) {
        guard let feature = jsonDictionary["feature"] as? String else { return nil }
        guard let currentPage = jsonDictionary["current_page"] as? Int else { return nil }
        guard let totalPages = jsonDictionary["total_pages"] as? Int else { return nil }
        guard let totalItems = jsonDictionary["total_items"] as? Int else { return nil }
        guard let photoDictionaries = jsonDictionary["photos"] as? [[String: Any]] else { return nil }
        
        self.feature = feature
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.totalItems = totalItems
        
        var photos = [Photo]()
        
        for photoDictionary in photoDictionaries {
            if let photo = Photo(jsonDictionary: photoDictionary) {
                photos.append(photo)
            }
        }
        
        self.photos = photos
    }
}
