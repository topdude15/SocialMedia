//
//  ViewController.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/11/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import FBSDKCoreKit
//import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

var email = ""
var password = ""

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //Checks if the user has already logged in and will go straight to feed if they have
    override func viewDidAppear(_ animated: Bool) {
        let uid = FIRAuth.auth()?.currentUser
        if uid != nil {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }

    }

    
    //Keyboard hider
    @IBAction func resignKeyboard(sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    @IBAction func hideEmailOnTouch(_ sender: Any) {
    }
    @IBAction func keyboardHider(_ sender: Any) {
    }
    @IBAction func hidePassword(_ sender: Any) {
    }
    
    //Authentication with Firebase
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("TREVOR: Unable to authenticate with Firebase - \(String(describing: error))")
                let message = "Verify your e-mail and password are correct and try again"
                let alertController = UIAlertController(
                    title: "Unable to log in", // This gets overridden below.
                    message: message,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
            else {
                print("TREVOR: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }

    //Action for when user presses "Sign In"
    @IBAction func signInTapped(_ sender: Any) {
        UserName.sharedInstance.email = self.emailField.text
        UserName.sharedInstance.password = self.pwdField.text
        if let email = emailField.text, let password = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("TREVOR: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            //Notification if creating the user was unsuccessful
                            print("TREVOR: Unable to authenticate email user with Firebase")
                            let message = "Verify your e-mail and password are correct and try again"
                            let alertController = UIAlertController(
                                title: "Unable to log in",
                                message: message,
                                preferredStyle: .alert
                            )
                            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                            
                        } else {
                            print("TREVOR: Successfully authenticated email user with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                print("TREVOR: \(userData)")
                                
                                //Create the Firebase user from the DataService sheet
                                
                                DataService.ds.createFirebaseDBUser(uid: user.uid, userData: userData)
                                
                                //Update the values for the email and password in their respective classes
                                print("TREVOR: Still here!")
                                self.performSegue(withIdentifier: "toTerms", sender: nil)
                            }
                        }
                    })
                }
            })
        }
    }
    
    //Finishes logging user in and sends them to the feed
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("TREVOR: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

