//
//  SettingsVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/19/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SettingsVC: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        DataService.ds.REF_USERS.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let username = dictionary["username"]
                print(username!)
                self.usernameLabel.text = username as? String
                
                FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let photoUrl = dictionary["userImage"]
                        let ref = FIRStorage.storage().reference(forURL: photoUrl as! String)
                        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("Image could not be downloaded from Firebase")
                            } else {
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.profileImg.image = img
                                    }
                                }
                            }
                        })
                    }
                }
            )}
        }
    )}

    @IBAction func goToChangeProfileImage(_ sender: Any) {
        performSegue(withIdentifier: "toChangePhoto", sender: nil)
    }

    @IBAction func changeUsername(_ sender: Any) {
        performSegue(withIdentifier: "toUsernameChange", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToFeed(_ sender: Any) {
        performSegue(withIdentifier: "feedFromSettings", sender: nil)
    }

    @IBAction func logOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("TREVOR: ID removed from keychain - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "loggedOut", sender: nil)
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
