//
//  WorkFileCell.swift
//  activitHit1
//
//  Created by patrick lanneau on 27/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class WorkFileCell: UITableViewCell {
    var myActivitee : Activitee?

    @IBOutlet weak var titre: UILabel!
    
    //@IBOutlet weak var exportBtn: UIButton!
    
    //@IBOutlet weak var importBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    @IBAction func export(_ sender: Any) {
//        if let nomC = titre.text {
//            let elems = nomC.split(separator: ".")
//            let nom = elems[0]
//            //print(nom)
//            if let file = myActivitee?.loadJsonForString(name: nomC){
//                print(file)
//            } else {
//                print("erreur")
//            }
//            
//        }
//        
//    }
    
//    @IBAction func `import`(_ sender: Any) {
//    }
    
    
}
