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
    @IBOutlet weak var followButton: UIButton!
    
    var followRef: FIRDatabaseReference!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userProfileId = userProfileUid.sharedInstance.profileUid

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
//        let usernameRef = DataService.ds.REF_USERNAME_VALUE.queryOrdered(byChild: usernameBoxValue!)
//        DataService.ds.REF_USERNAME_VALUE.observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.hasChild(usernameBoxValue!) {
//                let message = "Please enter an unique username to register"
//                
//        let uid = FIRAuth.auth()?.currentUser
//        FIRDatabase.database().reference().child("users").child(uid!).child("following").observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.hasChild(userProfileUid.sharedInstance.profileUid) {
//                print("Following user")
//            } else {
//                print("Not following user")
//            }
//        }
//    }
}
}
