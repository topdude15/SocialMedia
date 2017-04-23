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
        let usernameBoxValue = self.usernameBox.text
        let usernameValue: Dictionary<String, AnyObject> = [usernameBoxValue!: true as AnyObject]
        let usernameRef = DataService.ds.REF_USERNAME_VALUE.queryOrdered(byChild: usernameBoxValue!)
        DataService.ds.REF_USERNAME_VALUE.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(usernameBoxValue!) {
                let message = "Please enter an unique username to register"
                let alertController = UIAlertController(
                    title: "Username already taken", // This gets overridden below.
                    message: message,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            } else {
                print("Username not taken")
                print ("TREVOR: \(usernameRef)")
                FIRAuth.auth()?.signIn(withEmail: UserName.sharedInstance.email!, password: UserName.sharedInstance.password!, completion: { (user, error) in
                    if error == nil {
                        DataService.ds.addFirebaseUsername(uid: (user?.uid)!, username: username)
                        if let user = user {
                            let keychainResult = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
                            print("TREVOR: Data saved to keychain \(keychainResult)")
                            FIRDatabase.database().reference().child("usernames").updateChildValues(usernameValue)
                        }
                    } else {
                        print("TREVOR: Could not add username to user \(String(describing: error))")
                    }
                })
                self.performSegue(withIdentifier: "addUserImage", sender: nil)
            }
        })

    }
}
