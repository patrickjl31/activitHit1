//
//  AccueilController.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class AccueilController: UIViewController, AddHitsProtocol, CreerHitsProtocol {

    

    
    @IBOutlet weak var imageIV: RoundedImage!
    
    @IBOutlet weak var helpBtn: CustomButton!
    @IBOutlet weak var createBtn: CustomButton!
    @IBOutlet weak var addBtn: CustomButton!
    @IBOutlet weak var bilanBtn: CustomButton!
    
    @IBOutlet weak var activityLbl: UILabel!
    
    
    var filer = Filer()
    var activitee = Activitee(nom: "", categories: [])
    var nomActiviteeCourante = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // On ouvre l'activité courante
        if  let name = UserDefaults.standard.object(forKey:
                   "ActiviteeCourante") as? String {
            nomActiviteeCourante = name
            if let nouvelleActivite = activitee.loadFromFile(name: nomActiviteeCourante){
                activitee = nouvelleActivite
            } else {
                CreateFirstActivity()
            }
        } else {
            CreateFirstActivity()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // On ouvre l'activité courante
        if  let name = UserDefaults.standard.object(forKey:
                   "ActiviteeCourante") as? String {
            nomActiviteeCourante = name
            if let nouvelleActivite = activitee.loadFromFile(name: nomActiviteeCourante){
                activitee = nouvelleActivite
            } else {
                CreateFirstActivity()
            }
        } else {
            CreateFirstActivity()
        }
        if activitee.nom.count > 0 {
            nomActiviteeCourante = activitee.nom
            activityLbl.text = "L'activité actuelle est : \n \(nomActiviteeCourante)"
        }
    }
    
    func CreateFirstActivity(){
        //Alerte().messageSimple(titre: "Pas de fichier de travail", message: "Créez une nouvelle activité fichier de travail", controller: self)
        let alerte = UIAlertController(title: "Pas de fichier de travail", message: "Créez une nouvelle activité fichier de travail", preferredStyle: .alert)
        alerte.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //let vc = CreerFileController(nibName: "CreerFileController", bundle: nil)
            self.performSegue(withIdentifier: "toCreerFileController", sender: nil)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "CreerFileController") as! CreerFileController
//            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreerFileController") as! CreerFileController
//
//            vc.activitee = self.activitee
//            vc.nomFichier = self.nomActiviteeCourante
//            //self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }))
       
        self.present(alerte, animated: true, completion: nil)
       
    }
    
    @IBAction func creerNewActivity(_ sender: Any) {
        self.performSegue(withIdentifier: "toCreerFileController", sender: nil)
    }
    
    
    @IBAction func addHits(_ sender: UIButton) {
        performSegue(withIdentifier: VERS_ADD_HITS, sender: nil)
    }
    
    @IBAction func goBilans(_ sender: UIButton) {
        if let unHit = activitee.firstHit() {
            performSegue(withIdentifier: VERS_BILAN, sender: nil)
            //let valeurs = activitee.grafGlobalPerCent()
            //let valeursGlobales = activitee.grafGlobal()
            //let valeurs = activitee.grafGlobalPerCent(globalRes: valeursGlobales)
            
        } else {
            let alert = Alerte()
            alert.messageSimple(titre: "Impossible !", message: "Aucun hit n'a été enregistré !", controller: self)
        }
        
        //print("en % : \(valeurs)")
    }
   
    //--------------------------
    //---- Protocole hadHits---
    func newsHitsFor(uneActivitee: Activitee) {
        //activitee = uneActivitee
        //print("\n\n hits : \(activitee)")
    }
    //----protocole creer
    func saveHitsFor(uneActivitee: Activitee) {
        //activitee = uneActivitee
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == VERS_CREATION {
            let vc = segue.destination as! CreerFileController
            vc.activitee = activitee
            vc.nomFichier = nomActiviteeCourante
            vc.delegate = self
            
        }
        if segue.identifier == VERS_ADD_HITS {
            let vc = segue.destination as! AddHitsController
            vc.activitee = activitee
            vc.delegate = self
        }
        
        if segue.identifier == VERS_BILAN {
            let vc = segue.destination as! BilanViewController
            vc.activitee = activitee
            vc.dateDeb = activitee.firstHit()?.quand
            vc.dateFin = Date()
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
