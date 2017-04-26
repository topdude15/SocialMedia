//
//  BlockedUserPost.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/25/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase
class BlockedUserPost {
    
    private var _postKey: String!
    private var _postedBy: String!
    private var _posterImage: String!
    private var _posterUid: String!
    private var _postRef: FIRDatabaseReference!

    var postKey: String {
        return _postKey
    }
    var postedBy: String {
        return _postedBy
    }
    var posterImage: String {
        return _posterImage
    }
    var posterUid: String {
        return _posterUid
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._postedBy = postedBy
        self._posterUid = posterUid
        
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let postedBy = postData["postedBy"] as? String {
            self._postedBy = postedBy
        }
        if let posterImage = postData["posterImage"] as? NSString{
            self._posterImage = (posterImage as NSString!) as String!
        }
        if let posterUid = postData["posterUid"] as? String {
            self._posterUid = posterUid
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
}
