//
//  Classes.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/22/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation

class UserName {
    static var sharedInstance = UserName()
    private init () { }
    
    var email: String!
    var password: String!
    
}
let defaults = UserDefaults.standard
