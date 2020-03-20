//
//  Filer.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import Foundation

class Filer{
    // Le fichier par défaut
    func  recallCurrentActivity()-> String {
        let name = UserDefaults.standard.object(forKey:
            "ActiviteeCourante") as! String
        return name
    }
    func saveCurrentActivity(named:String){
        UserDefaults.standard.set(named, forKey: "ActiviteeCourante")
    }
    // renvoie la liste des fichiers de documents
    func catUrls(filtre:String? = nil)->[String]{
        var res:[String] = []
        //let leFiltre = filtre
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try manager.contentsOfDirectory(at: urls, includingPropertiesForKeys: nil, options: [])
            // On filtre en fonction de l'extension
            for file in fileURLs {
                let sFile = file.absoluteString.split(separator: "/")
                if let final = sFile.last{
                    //print("-> \(final)")
                    if let leFiltre = filtre {
                        let bon = final.contains(leFiltre)
                        if bon {
                            res.append(String(final))
                        }
                    } else {
                        res.append(String(final))
                    }
                }
            }
            //print(res)
            return res
        } catch {
            print("Erreur")
        }
        return []
    }
    
    func fileExist(name:String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let pathComponent = url.appendingPathComponent(name)
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath){
            //print("\(name) existe")
            return true
        } else {
            return false
        }
    }
    
    
    
}
