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
    
    func filterDay(withDays:[Int]) -> Bool {
        if withDays.count == 0 {
            return true
        } else {
            for day in withDays {
                if quand.dayOfWeek == day {
                    return true
                }
            }
            return false
        }
    }
    func filterHour(withHours:[Int]) -> Bool {
        if withHours.count == 0 {
            return true
        } else {
            for hour in withHours {
                if quand.hourOfDay == hour {
                    return true
                }
            }
            return false
        }
    }
    
    func filter(daysAndHours : [String:[Int]]) -> Bool {
        var res = true
        if let jours = daysAndHours["Days"] {
            res = self.filterDay(withDays: jours)
        }
        if let heures = daysAndHours["Hours"]{
            res = res && self.filterHour(withHours: heures)
        }
        return res
    }
       
}
