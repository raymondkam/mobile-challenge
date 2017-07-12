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
    
}

