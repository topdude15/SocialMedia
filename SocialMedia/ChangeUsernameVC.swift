//
//  ChangeUsernameVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/20/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class ChangeUsernameVC: UIViewController {

    @IBOutlet weak var usernameBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToSettings(_ sender: Any) {
        performSegue(withIdentifier: "settingsFromUsernameChange", sender: nil)
    }

    @IBAction func resignKeyboard(sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    @IBAction func hideKeyboard(_ sender: Any) {
    }

    @IBAction func continueTapped(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let currentUsername = DataService.ds.REF_USERS.child(uid!).child("username")
        let username = self.usernameBox.text
        //        let usernameValue: Dictionary<String, AnyObject> = [username!: true as AnyObject]
        DataService.ds.REF_USERNAME_VALUE.observeSingleEvent(of: .value, with: { (snapshot) in
            print("Here")
            if snapshot.hasChild(username!) {
                print("also here")
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
                print("aqui")
                DataService.ds.REF_USER_CURRENT.updateChildValues(["username": username!])
                
                self.performSegue(withIdentifier: "settingsFromUsernameChange", sender: nil)
            }
        }
        )
    }
    
}
