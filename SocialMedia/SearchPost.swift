//
//  SearchPost.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/25/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase

class SearchPost {
    
    private var _userImage: String!
    private var _username: String!
    private var _userId: String!
    private var _postRef: FIRDatabaseReference!
    
    var username: String {
        return _username
    }
    var userImage: String {
        return _userImage
    }
    init(profileImg: String, username: String, userId: String) {
        self._username = username
        self._userImage = profileImg
    }
    
    init(postData: Dictionary<String, AnyObject>) {
        if let username = postData["username"] as? String {
            self._username = username
        }
        if let userImage = postData["userImage"] as? String {
            self._userImage = userImage
        }
    }
}
