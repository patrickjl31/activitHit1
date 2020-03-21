//
//  BilanCell.swift
//  activitHit1
//
//  Created by patrick lanneau on 26/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class BilanCell: UITableViewCell {

    //@IBOutlet weak var couleurLegende: UIView!
    @IBOutlet weak var texteLegende: UILabel!
    
    @IBOutlet weak var vue: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        accessoryType = selected ? .checkmark : .none
    }

}
