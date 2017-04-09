//
//  FeedVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/14/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import FirebaseDatabase


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var likeImage: UIImageView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    @IBAction func getUid(_ sender: Any) {
        let user = DataService.ds.REF_USER_CURRENT
        print(user)
    }

    
    override func viewDidLoad() {
        
        captionField.delegate = self as? UITextFieldDelegate
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)

                    }
                    
                }
            }
            self.posts.reverse()
            self.tableView.reloadData()
        })
    }
    
    @IBAction func resignKeyboard(sender: AnyObject) {
        _ = sender.resignFirstResponder()
    }
    @IBAction func closeBox(_ sender: Any) {
    }
    @IBAction func close(_ sender: Any) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }

        } else {
            return PostCell()
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("TREVOR: Invalid image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
            present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("TREVOR: ID removed from keychain - \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    //Post button tapped to create post
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            print("TREVOR: Caption must be entered")
            let message = "Please enter a caption to continue"
            let alertController = UIAlertController(
                title: "Posting requires an caption", // This gets overridden below.
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        guard let image = imageAdd.image, imageSelected == true else {
            print("TREVOR: An image must be selected")
            let message = "Please select an image to continue"
            let alertController = UIAlertController(
                title: "Posting requires an image", // This gets overridden below.
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    print("Unable to upload image to Firebase Storage \(String(describing: error))")
                } else{
                    print("Successfully uploaded image to Firebase Storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let link = downloadUrl {
                        self.postToFirebase(imgUrl: link)
                    }
                }
            }
        }
    }
    
    //MARK: Actual post data
    func postToFirebase(imgUrl: String) {
        
        FIRAuth.auth()?.signIn(withEmail: UserName.sharedInstance.email, password: UserName.sharedInstance.password, completion: { (user, error) in
            if error == nil {
            let uid = FIRAuth.auth()?.currentUser?.uid

            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    print(dictionary)
                    
                    let username = dictionary["username"]
                    let posterImage = dictionary["userImage"]
                    
                    let post: Dictionary<String, AnyObject> = [
                        "caption": self.captionField.text as AnyObject,
                        "imageUrl": imgUrl as AnyObject,
                        "likes": 0 as AnyObject,
                        "postedBy": username as AnyObject,
                        "posterImage": posterImage as AnyObject
                    ]
                    
                    let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
                    firebasePost.setValue(post)
                    
                    self.captionField.text = ""
                    self.imageSelected = false
                    self.imageAdd.image = UIImage(named: "add-image")
                    
                    self.tableView.reloadData()
                    }
                })
            }
        })
        
    }
}
