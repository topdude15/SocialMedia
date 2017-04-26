//
//  SearchCell.swift
//  SocialMedia
//
//  Created by Trevor Rose on 4/25/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SwiftKeychainWrapper

class SearchCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: SearchPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(post: SearchPost, userImage: UIImage? = nil) {
        self.post = post
        self.usernameLabel.text = post.username
        
        if userImage != nil {
            self.profileImg.image = userImage
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.userImage as String)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Could not download image from Firebase")
                } else {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImg.image = img
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
