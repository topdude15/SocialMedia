//
//  usernameVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/22/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class usernameVC: UIViewController {
    
    @IBOutlet weak var usernameBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To-do: ADD AUTO LOGIN FUNCTIONALITY BACK IN
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func resignKeyboard(sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    @IBAction func closeUsernameBox(_ sender: Any) {
    }

    @IBAction func addUsernameTapped(_ sender: Any) {
        let username = ["username": usernameBox.text!]

        FIRAuth.auth()?.signIn(withEmail: UserName.sharedInstance.email!, password: UserName.sharedInstance.password!, completion: { (user, error) in
            if error == nil {
                DataService.ds.addFirebaseUsername(uid: (user?.uid)!, username: username)
                if let user = user {
                    let keychainResult = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                    print("TREVOR: Data saved to keychain \(keychainResult)")
                }
            } else {
                print("TREVOR: Could not add username to user \(String(describing: error))")
            }
        })
        performSegue(withIdentifier: "addUserImage", sender: nil)
    }
}
