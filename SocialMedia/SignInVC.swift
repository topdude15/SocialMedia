//
//  ViewController.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/11/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("TREVOR: Unable to authenticate with Facebook -\(String(describing: error))")
            } else if result?.isCancelled == true {
                print("TREVOR: User cancelled Facebook authentication")
            } else {
                print("TREVOR: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("TREVOR: Unable to authenticate with Firebase - \(String(describing: error))")
            }
            else {
                print("TREVOR: Successfully authenticated with Firebase")
            }
        })
    }

    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let password = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("TREVOR: Email user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("TREVOR: Unable to authenticate email user with Firebase")
                        } else {
                            print("TREVOR: Successfully authenticated email user with Firebase")
                        }
                    })
                }
            })
        }
    }

}

