//
//  DataService.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/15/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //Database references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_USERNAME_VALUE = DB_BASE.child("usernames")

    func addFirebaseUsername(uid: String, username: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(username)
    }
    
    
    //Storage references
    
    private var _REF_IMAGES = STORAGE_BASE.child("post-pics")
    private var _REF_USER_IMAGE = STORAGE_BASE.child("user-pics")
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_USERNAME_VALUE: FIRDatabaseReference {
        return _REF_USERNAME_VALUE
    }
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    var REF_USERNAME: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_IMAGES
    }
    var REF_USER_IMAGE: FIRStorageReference {
        return _REF_USER_IMAGE
    }
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
 
}
