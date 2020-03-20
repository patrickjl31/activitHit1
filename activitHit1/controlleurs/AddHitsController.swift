//
//  AddHitsController.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

protocol AddHitsProtocol {
    func newsHitsFor(uneActivitee: Activitee)
}

class AddHitsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : AddHitsProtocol? = nil

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var activityTableView: UITableView!
    
    var activitee: Activitee?
    
    var tampon:Activitee = Activitee(nom: "Tampon", categories: [])
    var nouvelleSaisie: Activitee = Activitee(nom: "NouvelleSaisie", categories: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityTableView.delegate = self
        activityTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleLbl.text = activitee?.nom
        guard activitee != nil else {_ = navigationController?.popToRootViewController(animated: true); return}
        
        tampon = activitee!
        // nouvelleSaisie reste vide
        // On ajoute tampon à activitee
        if let act = activitee {
                   //tampon = tampon.merge(me: act, toActivitee: tampon)
            nouvelleSaisie = act.miseABlanc()
            //print("Nouvelle saisie = \(nouvelleSaisie)")
        }
        
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        //delegate inutile
        if delegate != nil {
            delegate!.newsHitsFor(uneActivitee: tampon)
        }
        //print("\n\n\n\navant d'envoyer,  \(tampon) vaut par activitee \(activitee!)")
       
        
        tampon.saveAs(nom: tampon.nom)
        //print("\n\n\n\nJ'envoie \(tampon) par activitee \(activitee!)")
        _ = navigationController?.popToRootViewController(animated: true)
       
    }
    
    
    
    //---------------------
    //------Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let combien = activitee?.categories.count {
            return combien
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ADD_HITS_CELL, for: indexPath) as! AddHitsCell
        cell.categorieLbl.text = activitee!.categories[indexPath.row].nom
        //cell.hitBtn.tag = indexPath.row
        //let montag = toBigtag(tag: indexPath.row) + 1
        let rowPlus1 = indexPath.row + 1
        let montag = rowPlus1.toBigtag() + 1
        cell.hitBtn.tag = montag
        //cell.hitBtn.target(forAction: "hitButtonPressed", withSender: self)
        cell.hitBtn.addTarget(self, action: #selector(hitButtonPressed), for: .touchUpInside)
            
        return cell
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print("on sort de ligne \(indexPath.row)")
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("ligne \(indexPath.row)")
       
    }
//----------------------
    
    @objc func hitButtonPressed( sender: UIButton)  {
        //sender.blink(duration: 1, delay: 0.1, alpha: 0.2)
        //let combien = extractValFromBigtag(tag: sender.tag)
        let combien = sender.tag.extractValFromBigtag()
        // La ligne stockée dans le tag était incrémenté de 1
        // Aussi, on décrémente
        //let line = extractTagFromBigtag(bigtag: sender.tag)
        let line = sender.tag.extractTagFromBigtag() - 1
        print("Add \(combien) at line \(line)")
        let newHit = Hit(combien: combien, quand: Date())
        if line > -1 && line < tampon.categories.count {
            tampon.categories[line].addHit(hit: newHit)
            nouvelleSaisie.categories[line].addHit(hit: newHit)
            let totalLigne = tampon.categories[line].hits.last?.combien
            let totalEenregistre = nouvelleSaisie.categories[line].totalHits()
            
            // fonctionne
            let indaxPath = IndexPath(row: line, section: 0)
            let champ = activityTableView.cellForRow(at: indaxPath) as! AddHitsCell
            champ.hitField.text = String(1)
            champ.totalLbl.text = "Total : " + String(totalLigne!) + "/" + String(totalEenregistre)
            //print("hit = \(newHit), Tampon : \(tampon)")
            activityTableView.reloadData()
        }
        
    }
    
//
//    func extractValFromBigtag(tag:Int) -> Int {
//           let val = tag % 1000000
//           return val
//       }
//   func extractTagFromBigtag(bigtag: Int)->Int{
//       let val = (bigtag - extractValFromBigtag(tag: bigtag)) / 1000000
//       return val
//   }
//
//    func toBigtag(tag:Int) -> Int {
//        return tag * 1000000
//    }
//
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIView {
    func blink(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, alpha: CGFloat = 0.0) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.alpha = alpha
        })
    }
}
