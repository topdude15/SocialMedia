//
//  PostCell.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/15/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: CircleView!
    @IBOutlet weak var usernameLabe: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLabel.text = "\(post.likes)"
    }

}
