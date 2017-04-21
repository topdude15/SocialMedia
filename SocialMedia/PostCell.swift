//
//  PostCell.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/15/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var usernameLabe: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    
    var likesRef: FIRDatabaseReference!
    
    var userProfile = "USER"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Sets up Tap Gesture Recognizer on the username label to take user to post page
        usernameLabe.isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action:#selector(getPost))
        tapped.numberOfTapsRequired = 1
        usernameLabe.addGestureRecognizer(tapped)
        
        //Sets up Tap Gesture Recognizer on the like image to like posts
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }

    func configureCell(post: Post, img: UIImage? = nil, profileImg: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
        self.usernameLabe.text = post.postedBy
        userProfile = post.posterUid
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl as String)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TREVOR: Unable to download image from Firebase storage")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        if profileImg != nil {
            self.profileImg.image = profileImg
        } else {
            let reference = FIRStorage.storage().reference(forURL: post.posterImage as String)
            reference.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TREVOR: Unable to download image from Firebase storage")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.posterImage as NSString)
                        }
                    }
                }
            })
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "not-liked")
            } else {
                self.likeImage.image = UIImage(named: "liked")
            }
        })
        
    }
    func likeTapped(sender: UITapGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "liked")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "not-liked")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    func getPost(sender: UITapGestureRecognizer) {
       userProfileUid.sharedInstance.profileUid = userProfile
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
}
