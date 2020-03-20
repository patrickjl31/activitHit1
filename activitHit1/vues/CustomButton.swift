//
//  CustomButton.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit


// Les couleurs
let color_bleu_sombre = UIColor(red: 10 / 255, green: 10 / 255, blue: 150 / 255, alpha: 1)
let color_bleu_tres_clair = UIColor(red: 245 / 255, green: 245 / 255, blue: 255 / 255, alpha: 1)


class CustomButton: UIButton {

    
        override init(frame: CGRect) {
            super.init(frame: frame)
    //        self.layer.cornerRadius = frame.height / 2
    //        self.layer.backgroundColor = color_bleu_sombre.cgColor
    //        self.setTitleColor(.white, for: .normal)
            setup()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        func setup()  {
            layer.cornerRadius = self.frame.height / 2
            backgroundColor = color_bleu_sombre
            //setTitle(title, for: .normal)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            setTitleColor(.white, for: .normal)
        }


}
