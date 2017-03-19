//
//  UsernameVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/19/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class UsernameVC: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func continuePressed(_ sender: Any) {
        guard let username = usernameInput.text, username != "" else {
            let username: Dictionary<String, AnyObject> = [
            "username": usernameInput.text as AnyObject
            ]

            return
        }
    }
}

