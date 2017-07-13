//
//  APIManager.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-12.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    private init() {}
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    func fetchPhotos(feature: String, numberOfImages: Int, imageSize: String, completion: @escaping (_ photoStream: PhotoStream?, _ error: Error?) -> Void) {
        let parameters = ["feature": feature,
                          "exclude": APIConstants.CategoryNude,
                          "rpp": String(numberOfImages),
                          "image_size": APIConstants.ImageSize300pxHigh,
                          "consumer_key": APIConstants.ConsumerKey]
        
        Alamofire.request(APIConstants.BaseURL + APIConstants.ResourcePhotos, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.error == nil else {
                print("error fetching photos")
                return
            }
            guard let jsonDictionary = response.result.value as? [String: Any] else {
                print("json invalid")
                return
            }
            if let photoStream = PhotoStream(jsonDictionary: jsonDictionary) {
                completion(photoStream, nil)
            }
            
        }
    }
    
}

