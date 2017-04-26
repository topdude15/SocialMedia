//
//  CircleView.swift
//  SocialMedia
//
//  Created by Trevor Rose on 3/14/17.
//  Copyright © 2017 Trevor Rose. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 3
        clipsToBounds = true
    }
}
