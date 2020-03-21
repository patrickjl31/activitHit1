//
//  Activitee.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import Foundation

struct Activitee: Codable {
    var nom : String
    var categories : [Categorie]
    
    mutating func ajouteCategorie(categorie:Categorie) {
        self.categories.append(categorie)
    }
    mutating func  ajouteNouvelleCategorie(nom:String)  {
        let categorie = Categorie(nom: nom, hits: [])
        self.categories.append(categorie)
    }
    mutating func enleveCategorie(nom:String){
        var cat : [Categorie] = []
        for laCategorie in self.categories {
            if laCategorie.nom != nom {
                cat.append(laCategorie)
            }
        }
        self.categories = cat
    }
    
    func listeCategories() -> [String] {
        var res:[String] = []
        for categorie in categories{
            res.append(categorie.nom)
        }
        return res
    }
    
    func firstHit() -> Hit? {
        var rep:Hit?
        var firstDate = Date()
        for categorie in categories{
            for hit in categorie.hits{
                if hit.quand < firstDate {
                    firstDate = hit.quand
                    rep = hit
                }
            }
        }
        return rep
    }
    
    //-------------------
    //--- Manipulation des activités
    
    func merge(me:Activitee, toActivitee: Activitee) -> Activitee {
        var res = me
        for categorie in me.categories {
            for toCat in toActivitee.categories {
                var newCategorie = Categorie(nom: toCat.nom, hits: toCat.hits)
                if categorie.nom == toCat.nom {
                    newCategorie = categorie.merge(me: categorie, withCategories: toCat)
                }
                
            }
            
        }
        return me
    }
    func miseABlanc() -> Activitee {
        var res = Activitee(nom: self.nom, categories: [])
        for i in 0..<self.categories.count{
            res.ajouteNouvelleCategorie(nom: self.categories[i].nom)
        }
        return res
        
    }
    
    func selectBetween(date1: Date, date2: Date) -> Activitee {
        var res : Activitee = Activitee(nom: self.nom, categories: [])
        for cat in self.categories {
            let newCat = Categorie(nom: cat.nom, hits: cat.hitsBetween(date1: date1, date2: date2))
            res.ajouteCategorie(categorie: newCat)
        }
        return res
    }
    
    //---------------
    //---Graphiques---
    /*
    func grafGlobal() -> [String:Int] {
        var res : [String:Int] = [:]
        var total = 0
        for categorie in categories {
            var cumul = 0
            for hit in categorie.hits{
                cumul += hit.combien
                total += hit.combien
            }
            res[categorie.nom] = cumul
        }
        res[TOTAL] = total
        return res
    }
   
    func grafGlobalPerCent(globalRes: [String:Int]) -> [String:Double] {
        var res : [String:Double] = [:]
        //let globalRes = self.grafGlobal()
        if let totalInt = globalRes[TOTAL] {
            let total = Double(totalInt)
            for (key, value) in globalRes {
                if key != TOTAL {
                    let perCent:Double = Double(value) / total * 100
                    res[key] = perCent
                }
            }
        }
        return res
    }
     */
    //-----------------
    // --- avec grafObject
    func  grafGlobal() -> [GrafObject] {
        var res : [GrafObject] = []
        //var total = 0
        for categorie in categories {
            var cumul = 0
            for hit in categorie.hits{
                cumul += hit.combien
                //total += hit.combien
            }
            let newGrafObject = GrafObject(ident: categorie.nom, nbHits: cumul, val: Float(cumul), valLongueurBarre: 0.0, couleur: .black)
            res.append(newGrafObject)
        }
        return res
    }
    
    // Modifie une liste de grafObjects la valeur brute en pourcentage
    // par rapport aux éléments de la liste
    func grafGlobalPerCent(globalRes : [GrafObject]) -> [GrafObject] {
        var total:Float = 0
        var valMax:Float = 0
        var res : [GrafObject] = []
        for elem in globalRes {
            total += elem.val
            if elem.val > valMax {
                valMax = elem.val
            }
        }
        let perCentValMax: Float = valMax / total * 100
        let coefPerCent:Float = TERMINAL_WIDTH / perCentValMax
        for elem in globalRes {
            let perCent:Float = elem.val / total * 100
            let lgr = perCent * coefPerCent
            let newGrafObject = GrafObject(ident: elem.ident, nbHits: elem.nbHits, val: perCent, valLongueurBarre: lgr, couleur: .black)
            res.append(newGrafObject)
        }
        return res
    }
    //---------------
    // enregistrer et lire
    
    func save() -> String {
        //On encode
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self){
            if let json = String(data: encoded, encoding: .utf8){
                //print(json)
                return json
            }
        }
        return ""
    }
    
    func saveAs(nom:String)  {
        let val = self.save()
        if  val.count > 0 {
            let manager = FileManager.default
            let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
            if let url = urls.first{
                var fileUrl = url.appendingPathComponent(nom)
                fileUrl = fileUrl.appendingPathExtension("json")
                try? val.write(to: fileUrl, atomically: true, encoding: .utf8)
            }
        }
    }
    
    func loadFromFile(name:String) -> Activitee? {
        //var reussi = false
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first{
            var fileUrl = url.appendingPathComponent(name)
            fileUrl = fileUrl.appendingPathExtension("json")
            let decoder = JSONDecoder()
            if let data = try? Data(contentsOf: fileUrl){
                if let res = try? decoder.decode(Activitee.self, from: data){
                    return res
                    //reussi = true
                }
            }
            }
        return nil
    }
    
    func loadJsonForString(name:String) -> String? {
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        //print("url : \(urls)")
        if let url = urls.first{
            var fileUrl = url.appendingPathComponent(name)
            //print("load : \(fileUrl)")
            fileUrl = fileUrl.appendingPathExtension("json")
            //let decoder = JSONDecoder()
            if let texte = try? String(contentsOf: fileUrl, encoding: .utf8){
                return texte
            }
            }
        return nil
    }
}

//--------------------------
//--elements pour tracer les résultats en graphe ligne

extension Activitee {
    
}




