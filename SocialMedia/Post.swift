//
//  Post.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/16/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postedBy: String!
    private var _posterImage: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    var imageUrl: String {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var postKey: String {
        return _postKey
    }
    var postedBy: String {
        return _postedBy
    }
    var posterImage: String {
        return _posterImage
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._postedBy = postedBy
        self._posterImage = posterImage
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? NSString{
            self._imageUrl = (imageUrl as NSString!) as String!
        }
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
        if let postedBy = postData["postedBy"] as? String {
            self._postedBy = postedBy
        }
        if let posterImage = postData["posterImage"] as? NSString{
            self._posterImage = (posterImage as NSString!) as String!
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
