//
//  RoundedImage.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = UIColor.systemTeal.cgColor
        self.layer.borderWidth = 4
        contentMode = .scaleAspectFit
    }
    
    func updateRadius(radius: CGFloat) {
        layer.cornerRadius = radius
    }


}
