//
//  BannedUserVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/25/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class BannedUserVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.ds.REF_USER_CURRENT.child("blockedUsers").observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshot)
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        print("Appended")
                        self.posts.reverse()
                        self.tableView.reloadData()
                        }
                    }
        }
    })
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if FeedVC.imageCache.object(forKey: post.imageUrl as NSString) != nil {
                let profileImage = FeedVC.imageCache.object(forKey: post.posterImage as NSString)
                cell.configureCell(post: post, profileImg: profileImage)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
            
        } else {
            return PostCell()
        }
    }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToSettings(_ sender: Any) {
        performSegue(withIdentifier: "settingsFromBanned", sender: nil)
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
