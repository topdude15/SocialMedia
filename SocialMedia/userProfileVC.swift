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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func followUser(_ sender: Any) {
//        func likeTapped(sender: UITapGestureRecognizer) {
//            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let _ = snapshot.value as? NSNull {
//                    self.likeImage.image = UIImage(named: "filled-heart")
//                    self.post.adjustLikes(addLike: true)
//                    self.likesRef.setValue(true)
//                } else {
//                    self.likeImage.image = UIImage(named: "empty-heart")
//                    self.post.adjustLikes(addLike: false)
//                    self.likesRef.removeValue()
//                }
//            })
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
