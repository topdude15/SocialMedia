//
//  usernameVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/22/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

var postedBy = ""

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
    
    
    //    @IBAction func addUsername(_ sender: Any) {
    //        let usernameValue = usernameBox.text //Gets value from username box
    //        let username = ["username": usernameValue]   //Sets dictonary for username to be set into Firebase database
    //        //FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in     //Logs the user into Firebase based on username and password set in the sign in VC
    //        //DataService.ds.addFirebaseUsername(uid: (user?.uid)!, username: username as! Dictionary<String, String>)   //Adds the username to the database
    //        self.performSegue(withIdentifier: "feedFromUsername", sender: nil)

    @IBAction func addUsernameTapped(_ sender: Any) {
        let username = ["username": usernameBox.text!]
        print("TREVOR: \(username)")
        print("TREVOR: \(UserName.sharedInstance.email)")
        print("TREVOR: \(UserName.sharedInstance.password)")

        defaults.set(usernameBox.text!, forKey: "username")
        
        Poster.sharedInstance.postedBy = usernameBox.text
        
        FIRAuth.auth()?.signIn(withEmail: UserName.sharedInstance.email, password: UserName.sharedInstance.password, completion: { (user, error) in
            if error != nil {
                print("TREVOR: Could not add username to user \(String(describing: error))")
            } else {
                DataService.ds.addFirebaseUsername(uid: (user?.uid)!, username: username)
            }
        })
        performSegue(withIdentifier: "feedFromUsername", sender: nil)
    }
}
