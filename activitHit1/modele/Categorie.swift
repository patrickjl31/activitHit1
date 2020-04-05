//
//  Categorie.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import Foundation

struct Categorie:Codable {
     var nom : String
       var hits : [Hit]
       
       func  hitsBetween(date1: Date, date2: Date) -> [Hit] {
           var d1, d2: Date
           if date1 > date2 {
               d1 = date2
               d2 = date1
           } else {
               d2 = date2
               d1 = date1
           }
           var result = [Hit]()
           for hit in hits {
               if (hit.quand >= d1) && (hit.quand <= d2){
                   result.append(hit)
               }
           }
           return result
       }
    
    func totalHits() -> Int {
        var total = 0
        for hit in hits {
            total += hit.combien
        }
        return total
    }
    
    mutating func addHit(hit:Hit) {
        hits.append(hit)
    }
    
    func merge(me: Categorie, withCategories:Categorie) -> Categorie {
        var res: Categorie = me
        if me.nom == withCategories.nom {
            res.hits.append(contentsOf: withCategories.hits)
        }
        return res
    }
    
    func filter(with filtre:[String:[Int]]) -> [Hit] {
        var res:[Hit] = []
        for hit in self.hits {
            if hit.filter(daysAndHours: filtre){
                res.append(hit)
            }
        }
        return res
    }
    
    
    
}
