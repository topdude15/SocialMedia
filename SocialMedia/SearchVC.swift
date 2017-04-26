//
//  SearchVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/25/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SearchVC: UIViewController {

    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [SearchPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    //let key = snap.key
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        //let key = snap.key
                        let post = SearchPost(postData: postDict)
                        self.posts.append(post)
                        self.posts.reverse()
                        self.tableView.reloadData()
                    }
                }
                
            }
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchChanged(_ sender: Any) {


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
