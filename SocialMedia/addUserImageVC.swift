//
//  addUserImageVC.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/7/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class addUserImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet var addUserImage: UITapGestureRecognizer!
    @IBOutlet weak var userImage: CircleView!
    
    var imageSelected = false
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    @IBAction func addUserImage(_ sender: Any) {
//        present(imagePicker, animated: true, completion: nil)
//    }
    @IBAction func addUserImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImage.image = image
            imageSelected = true
        } else {
            print("TREVOR: Invalid image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadUserImage(_ sender: Any) {
        guard let image = userImage.image, imageSelected == true else {
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
            
            DataService.ds.REF_USER_IMAGE.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    print("Unable to upload image to Firebase Storage \(String(describing: error))")
                } else{
                    print("Successfully uploaded image to Firebase Storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let link = downloadUrl {
                       self.postUserImage(imgUrl: link)
                    }
                }
            }
        }

    }
    func postUserImage(imgUrl: String) {
        FIRAuth.auth()?.signIn(withEmail: UserName.sharedInstance.email, password: UserName.sharedInstance.password, completion: { (user, error) in
            if error == nil {
                let uid = FIRAuth.auth()?.currentUser?.uid
                let post: Dictionary<String, AnyObject> = [
                    "userImage": imgUrl as AnyObject
                ]
                let user = DataService.ds.REF_USERS.child(uid!)
                user.updateChildValues(post)
                self.performSegue(withIdentifier: "feedFromImage", sender: nil)
            }
        })
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
