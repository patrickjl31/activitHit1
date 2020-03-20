//
//  Alerte.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class Alerte {
    
    static let shared = Alerte()
    
    func erreur(message: String, controller: UIViewController) {
        let str = NSLocalizedString("Error", comment: "erreur")
        messageSimple(titre: str, message: message, controller: controller)
    }
    
    func priseMedicament(message: String, controller: UIViewController) {
        let str = NSLocalizedString("Take your medicine :", comment: "prenez...")
        messageSimple(titre: str, message: message, controller: controller)
    }
    
    func messageSimple(titre: String, message: String, controller: UIViewController) {
        let alerte = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerte.addAction(ok)
        controller.present(alerte, animated: true, completion: nil)
    }
    func messageOuiOuNon(titre: String, message: String, controller: UIViewController)->Bool {
        let alerte = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {action in return true})
        let annuler = NSLocalizedString("Cancel", comment: "cancel")
        let cancel = UIAlertAction(title: annuler, style: .cancel, handler: {action in return true})
        alerte.addAction(ok)
        alerte.addAction(cancel)
        controller.present(alerte, animated: true, completion: nil)
        return false
    }
    
}

