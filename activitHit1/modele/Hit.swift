//
//  Hit.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import Foundation

struct Hit: Codable {
    var combien:Int
    var quand:Date
    
     func hitForDayByNom(nom:String) -> Bool {
           let  dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let jour = dateFormatter.string(from: self.quand)
           return  jour == nom
       }
       func hitForDayByNum(num:Int) -> Bool {
           // dimanche = 1
           let  calendar = Calendar.current.dateComponents([.weekday], from: self.quand)
           let numJour = calendar.weekday
           return numJour == num
       }
       
}
