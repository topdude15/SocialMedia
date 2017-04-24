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
class userProfileUid {
    static var sharedInstance = userProfileUid()
    private init() { }
    
    var profileUid: String!
}
class postId {
    static var sharedInstance = postId()
    private init() { }
    
    var postID: String!
}
let defaults = UserDefaults.standard
