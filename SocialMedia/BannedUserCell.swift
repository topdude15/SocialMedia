//
//  BannedUserCell.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/25/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Firebase

class BannedUserCell: UITableViewCell {

    @IBOutlet weak var profileImage: CircleView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: BlockedUserPost, profileImage: UIImage? = nil) {
        self.usernameLabel.text = post.postedBy
        
        if profileImage != nil {
            self.profileImage.image = profileImage
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.posterImage as String)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                          self.profileImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.posterUid as NSString)
                        }
                    }
                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
