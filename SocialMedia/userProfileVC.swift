//
//  userProfileVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/10/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class userProfileVC: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: CircleView!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var followRef: FIRDatabaseReference!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userProfileId = userProfileUid.sharedInstance.profileUid

        DataService.ds.REF_USER_CURRENT.child("blockedUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userProfileUid.sharedInstance.profileUid) {
                self.blockButton.setTitle("User Blocked", for: .normal)
            }
        })
        DataService.ds.REF_USER_CURRENT.child("following").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userProfileUid.sharedInstance.profileUid) {
                self.followButton.setTitle("Following user", for: .normal)
            }
        })
        DataService.ds.REF_USERS.child(userProfileId!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let username = dictionary["username"]
                let photoUrl = dictionary["userImage"]
                let ref = FIRStorage.storage().reference(forURL: photoUrl as! String)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("Image could not be downloaded from Firebase")
                    } else {
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.userImage.image = img
                            }
                        }
                    }
                })
                self.usernameLabel.text = username as? String
            }
        })
    }


    @IBAction func returnToFeed(_ sender: Any) {
        performSegue(withIdentifier: "feedFromProfile", sender: nil)
    }
    
    @IBAction func followUser(_ sender: Any) {
        let user: Dictionary<String, AnyObject> = [userProfileUid.sharedInstance.profileUid!: true as AnyObject]
        DataService.ds.REF_USER_CURRENT.child("following").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userProfileUid.sharedInstance.profileUid) {
                DataService.ds.REF_USER_CURRENT.child("following").child(userProfileUid.sharedInstance.profileUid).removeValue()
            } else {
                DataService.ds.REF_USER_CURRENT.child("following").updateChildValues(user)
                self.followButton.setTitle("Following user", for: .normal)
            }
        })
    }

    @IBAction func blockUser(_ sender: Any) {
        let user: Dictionary<String, AnyObject> = [userProfileUid.sharedInstance.profileUid!: true as AnyObject]
        DataService.ds.REF_USER_CURRENT.child("blockedUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(userProfileUid.sharedInstance.profileUid) {
                self.blockButton.setTitle("User blocked", for: .normal)
                DataService.ds.REF_USER_CURRENT.child("blockedUsers").child(userProfileUid.sharedInstance.profileUid).removeValue()
                self.blockButton.setTitle("Block user", for: .normal)
            } else {
                DataService.ds.REF_USER_CURRENT.child("blockedUsers").updateChildValues(user)
                self.blockButton.setTitle("User blocked", for: .normal)
                self.performSegue(withIdentifier: "feedFromProfile", sender: nil)
            }
        })
    }
}
