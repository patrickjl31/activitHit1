//
//  BilanViewController.swift
//  activitHit1
//
//  Created by patrick lanneau on 21/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class BilanViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, Recurrence {
    
    
    
 

    @IBOutlet weak var titreLbl: UILabel!
    @IBOutlet weak var dateDebutField: UITextField!
    @IBOutlet weak var dateFinField: UITextField!
    @IBOutlet weak var choixLbl: UILabel!
    
    @IBOutlet weak var applePie: Camembert!
    
    @IBOutlet weak var bilanTableView: UITableView!
    
    var datePicker = UIDatePicker()
    
    var dateDeb:Date?
    var dateFin:Date = Date()
    private var dateFormatter = DateFormatter()
    // La liste des données récurrentes, les jeudi ou les 12-13h
    // Clefs : Days, Hours
    var listeRecurrences = [String:[Int]]()
    
    var activitee:Activitee?
    var enCouleur:[GrafObject]?
    var activiteeLimitee : Activitee = Activitee(nom: "local", categories: [])
    
    // Liste des items sélectionnés
    var selectedItems : [Int] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateDebutField.delegate = self
        dateFinField.delegate = self
        //datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if let act = activitee {
            // On limite les bornes
            dateDeb = act.firstHit()?.quand
        }
        
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        // les dates
        dateDebutField.inputView = datePicker
        dateFinField.inputView = datePicker
        // On initialise les dates
        dateFormatter.dateFormat = "dd/MM/YY à hh:mm"
        dateDebutField.text = dateFormatter.string(from: dateDeb!)
        dateFinField.text = dateFormatter.string(from: dateFin)
       
        // la table légende
        bilanTableView.delegate = self
        bilanTableView.dataSource = self
        //bilanTableView.allowsMultipleSelection = true
        //bilanTableView.allowsMultipleSelectionDuringEditing = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let act = activitee {
            // On limite les bornes
            datePicker.maximumDate = Date()
            datePicker.minimumDate = act.firstHit()?.quand
            dateDeb = act.firstHit()?.quand
        }
        dateFin = Date()
        // On initialise les dates
        dateFormatter.dateFormat = "dd/MM/YY à hh:mm"
        dateDebutField.text = dateFormatter.string(from: dateDeb!)
        dateFinField.text = dateFormatter.string(from: dateFin)
        // la copie d'activitee qui peut être réduite
        if let act = activitee {
            activiteeLimitee = act
        }
        // Pas de selection
        selectedItems = []
        miseAJourDonneesGraphiques()
        //le camembert
        //dessineCamembert()
    }
    
    @objc func viewTapped(gestureRecognizer: UIGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd/MM/YY à hh:mm"
        // défini en global
        // On mémorise les anciennes valeurs en cas d'erreur
        //let minDateDeb = activitee?.firstHit()?.quand
        //let maxDateFin = Date()
        if let act = activitee, dateDebutField != nil, dateFinField != nil {
            if dateDebutField.isFirstResponder {
                dateDebutField.text = dateFormatter.string(from: datePicker.date)
                dateDeb = datePicker.date
            } else {
                dateFinField.text = dateFormatter.string(from: datePicker.date)
                dateFin = datePicker.date
            }
            activiteeLimitee = act.selectBetween(date1: dateDeb!, date2: dateFin)
            //print("Limitation : \(activiteeLimitee)")
            miseAJourDonneesGraphiques()
        }
        
        //view.endEditing(true)
    }
    
    // MARK: - Protocole
   func recurrencesChoisies(choix: [String : [Int]]) {
    listeRecurrences = choix
       print(choix)
    var comment = ""
    if let jours = choix["Days"], jours.count > 0 {
        comment += "Jours : "
        for jour in jours {
            comment += "\(days[jour - 1]) "
        }
    }
    if let heures = choix["Hours"], heures.count > 0 {
        comment += " ; Heures : "
        for heure in heures {
            comment += "\(hours[heure]) "
        }
    }
    choixLbl.text = comment
   }
    
    
    //--------------------------
    // Traitement des données et préparation de l'affichage graphique
    //let valeursGlobales = activitee.grafGlobal()
    //let valeurs = activitee.grafGlobalPerCent(globalRes: valeursGlobales)
    // associer couleur et noms
    /*
    func colorForCategorie(categories:[String:Double], couleur:[UIColor])-> [String:UIColor]{
        let nombreCouleurs = couleur.count
        var res:[String:UIColor] = [:]
        var compteur = 0
        for (key,_) in categories {
            res[key] = couleur[compteur]
            compteur += 1
            if compteur == nombreCouleurs {
                compteur = 0
            }
        }
        return res
    }
    */
    func addColorsForCategories(categories: [GrafObject])->[GrafObject] {
    var res : [GrafObject] = []
        let couleursDispos = COULEURS.count
        for i in 0..<categories.count {
            let laCouleur = COULEURS[i % couleursDispos]
            let newGrafObject = GrafObject(ident: categories[i].ident, nbHits: categories[i].nbHits, val: categories[i].val, valLongueurBarre: categories[i].valLongueurBarre, couleur: laCouleur)
            res.append(newGrafObject)
        }
        return res
    }
    
    // On dessine les éléments sélectonnés dans activiteeLimitee
    /// On dessine les éléments sélectonnés dans activiteeLimitee
    func miseAJourDonneesGraphiques()  {
        // On recupere  les objets graphiques d'activiteeLimitee
        print(selectedItems)
        if let act = activitee, selectedItems.count > 1 {
            let listeReduite: Activitee = Activitee(nom: act.nom, categories: [])
            
        }
        // On recupere  les objets graphiques d'activiteeLimitee
        let valeursG = activiteeLimitee.grafGlobal()
        let valeurPerCent = activiteeLimitee.grafGlobalPerCent(globalRes: valeursG)
        enCouleur = addColorsForCategories(categories: valeurPerCent)
        applePie.valeurs = enCouleur
        applePie.selectedObjects = selectedItems
        //print("encouleur = \(enCouleur)")
        // On recalcule la table
        bilanTableView.reloadData()
        // On redessine le camembert
        dessineCamembert()
//        if let couleurs:[GrafObject] = addColorsForCategories(categories: valeursPerCent){
//            enCouleur = couleurs
//        }
    }
    
    /// met à jour les paramètres globaux du modèle et ordonne le redessin du camembert
    
    func dessineCamembert()  {
        if let enCouleurs = enCouleur{
            applePie.valeurs = enCouleurs
            applePie.selectedObjects = selectedItems
            //applePie.draw(applePie.frame)
            applePie.setNeedsDisplay()
        }
    }
    
    // MARK: Tableview --------------------------
    //--- Tableview---
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let combien = enCouleur?.count {
            return combien
        } else {
            return 0
        }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BILAN_CELL, for: indexPath) as! BilanCell
        if let source = enCouleur?[indexPath.row]{
            let lgr = CGFloat(source.valLongueurBarre)
            //cell.couleurLegende.backgroundColor = source.couleur
            cell.vue.backgroundColor = source.couleur
            cell.vue.frame = CGRect(x: 0, y: 1, width: lgr, height: 18)
            if cell.isSelected {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
              cell.accessoryType = UITableViewCell.AccessoryType.none
            }
            
            let pourcent = Int(source.val)
            cell.texteLegende.text = "\(source.ident)  = \(source.nbHits) Hits : \(Int(pourcent))%"
        }
        return cell
        
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        if !selectedItems.contains(indexPath.row){
            
            selectedItems.append(indexPath.row)
            print("ligne selectionnée : (indexPath.row)")
            miseAJourDonneesGraphiques()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cible = indexPath.row
        var posCible = -1
        for index in 0..<selectedItems.count {
        if selectedItems[index] == cible {
                posCible = index
            }
        }
        if posCible > -1 {
            selectedItems.remove(at: posCible)
        }
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        miseAJourDonneesGraphiques()
    }
    
    

    /*
    // MARK: - Navigation

     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == VERS_RECURRENCE {
            let vc = segue.destination as! RecurrenceViewController
            vc.delegate = self
        }
    }
  
    
    //-----------------
    //--textfield delegate
    

}
