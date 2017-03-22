//
//  usernameVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/21/17.
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

//    @IBAction func continueTapped(_ sender: Any) {
//        let usernameValue = usernameBox.text //Gets value from username box
//        let username = ["username": usernameValue]   //Sets dictonary for username to be set into Firebase database
//        //FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in     //Logs the user into Firebase based on username and password set in the sign in VC
//            //DataService.ds.addFirebaseUsername(uid: (user?.uid)!, username: username as! Dictionary<String, String>)   //Adds the username to the database
//            self.performSegue(withIdentifier: "feedFromUsername", sender: nil)
//        }
  
    @IBAction func addUsername(_ sender: Any) {
        let usernameValue = usernameBox.text //Gets value from username box
        let username = ["username": usernameValue]   //Sets dictonary for username to be set into Firebase database
        //FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in     //Logs the user into Firebase based on username and password set in the sign in VC
        //DataService.ds.addFirebaseUsername(uid: (user?.uid)!, username: username as! Dictionary<String, String>)   //Adds the username to the database
        self.performSegue(withIdentifier: "feedFromUsername", sender: nil)
    }
    
//    )
}
//}
