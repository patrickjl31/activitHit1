//
//  CreerFileController.swift
//  activitHit1
//
//  Created by patrick lanneau on 03/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit


protocol CreerHitsProtocol {
    func saveHitsFor(uneActivitee: Activitee)
}



class CreerFileController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
     var delegate : CreerHitsProtocol? = nil

    @IBOutlet weak var choixLbl: UILabel!
    @IBOutlet weak var identField: UITextField!
    @IBOutlet weak var categoriesLbl: UILabel!
    @IBOutlet weak var categoriesField: UITextField!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet weak var fictableview: UITableView!
    @IBOutlet weak var comentLbl: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    // On : choix de fichier, off : création
    @IBOutlet weak var toogle: UISwitch!
    
    var listeCategories : [String] = []
    var listeFichiers :[String] = []
    //-- le numero du fichier délectionné
    var selectedFile = -1
    
    // Gestion fichiers
    let filer = Filer()
    
    // Lien avec l'appel
    var nomFichier : String?
    //le gestionnaire du modele
    var activitee:Activitee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        categoriesField.delegate = self
        catTableView.dataSource = self
        catTableView.delegate = self
        catTableView.isEditing = true
        
        fictableview.delegate = self
        fictableview.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedFile = -1
        // On teste l'existence de fichiers
        listeFichiers = filer.catUrls()
        if listeFichiers.count < 2 {
            toogle.isOn = false
            importButton.isHidden = true
            choixLbl.text = "Créez votre nouvelle activité"
        } else {
            toogle.isOn = true
            choixLbl.text = "Choisir un fichier de travail"
        }
        importButton.isHidden = true
        exportButton.isHidden = true
        miseAJour()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if toogle.isOn {
            //Ouvrir le nouveau fichier
            //choixLbl.text = "Choisir un fichier de travail"
            if selectedFile  > -1{
                let nameFileLong = listeFichiers[selectedFile]
                let arrayName = nameFileLong.split(separator: ".")
                let nameFile = arrayName[0]
                //print("on va changer \(nameFile)")
                //let monActivitee = activitee
                var tampon:Activitee = Activitee(nom: "Tampon", categories: [])
                if let nouvelleActivitee = tampon.loadFromFile(name: String(nameFile))
                    {
                    //print("changement de fichier ...")
                    //monActivitee = nouvelleActivitee
                        filer.saveCurrentActivity(named: String(nameFile))
                    //delegate inutile
                    if delegate != nil {
                        delegate!.saveHitsFor(uneActivitee: nouvelleActivitee)
                    }
                    //print("changement de fichier acté")
                }
            }
        } else {
            //importButton.isHidden = true
            //choixLbl.text = "Créez votre nouvelle activité"
            // Enregistrer la nouvelle activité
            if  let cat = identField.text, cat.count > 0, listeCategories.count > 0 {
                var tampon:Activitee = Activitee(nom: "Tampon", categories: [])
                tampon.nom = cat
                tampon.categories = []
                for categorie in listeCategories{
                    tampon.ajouteNouvelleCategorie(nom: categorie)
                }
                //delegate inutile
                if delegate != nil {
                    delegate!.saveHitsFor(uneActivitee: tampon)
                }
                tampon.saveAs(nom: cat)
                // On choisit comme activité courante
                filer.saveCurrentActivity(named: cat)
                //print("sauvé")
                
            }
        }
        _ = navigationController?.popToRootViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tooglePressed(_ sender: UISwitch) {
        miseAJour()
    }
    
    func miseAJour() {
        if toogle.isOn {
            if selectedFile > -1 {
                importButton.isHidden = false
                exportButton.isHidden = false
            } else {
                importButton.isHidden = true
                exportButton.isHidden = true
            }
            categoriesField.isHidden = true
            categoriesLbl.isHidden = true
            catTableView.isHidden = true
            fictableview.isHidden = false
            comentLbl.isHidden = true
            identField.isHidden = true
            choixLbl.text = "Choisir un fichier de travail"
            saveButton.setTitle("Valider le changement de fichier de travail", for: .normal)
            fictableview.reloadData()
            
        } else {
            importButton.isHidden = true
            categoriesField.isHidden = false
            categoriesLbl.isHidden = false
            catTableView.isHidden = false
            fictableview.isHidden = true
            comentLbl.isHidden = false
            identField.isHidden = false
            choixLbl.text = "Créer un fichier de travail"
            saveButton.setTitle("Enregistrer la nouvelle activité", for: .normal)
            catTableView.reloadData()
        }
    }
    
    //-------------------------
    //--- Action importation et exportation
    
    @IBAction func importButtonPressed(_ sender : UIButton){
        // Importer
        if selectedFile > -1 {
            let nom = listeFichiers[selectedFile]
        }
        

        //print(nom)
    }
   
    @IBAction func exportButtonPressed(_ sender : UIButton){
           // exporter si une ligne est sélectionnée
        guard selectedFile > -1 else {return}
        let nom = listeFichiers[selectedFile]
        let arrayNom = nom.split(separator: ".")
        let nomCourt = String(arrayNom[0])
        let tampon = Activitee(nom: "tampon", categories:[])
        if let file = tampon.loadJsonForString(name: nomCourt){
            //print(file)
            let controller = UIActivityViewController(activityItems: [file], applicationActivities: nil)
            controller.popoverPresentationController?.sourceView = self.view
            self.present(controller, animated: true, completion: nil)
        }

       }
    
    //---------------------
    //----TableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == catTableView {
        return listeCategories.count
        }
        if tableView == fictableview {
            return listeFichiers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == fictableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ficcell", for: indexPath) as! WorkFileCell
            //cell.textLabel?.text = listeFichiers[indexPath.row]
            cell.titre.text = listeFichiers[indexPath.row]
            cell.myActivitee = activitee
            //cell.importBtn.tag = indexPath.row
            //cell.exportBtn.tag = indexPath.row
            //cell.importBtn.addTarget(self, action: #selector(importButtonPressed(_:)), for: .touchUpInside)
            //cell.exportBtn.addTarget(self, action: #selector(exportButtonPressed(_:)), for: .touchUpInside)
            return cell
        }
        if tableView == catTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "catcell", for: indexPath)
            cell.textLabel?.text = listeCategories[indexPath.row]
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ficcell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == catTableView {
            if editingStyle == .delete {
                listeCategories.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView == catTableView {
            let sourceval = listeCategories[sourceIndexPath.row]
            listeCategories[sourceIndexPath.row] = listeCategories[destinationIndexPath.row]
            listeCategories[destinationIndexPath.row] = sourceval
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == fictableview {
            selectedFile = indexPath.row
            importButton.isHidden = false
            exportButton.isHidden = false
        }
        //selectedFile = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == fictableview {
            selectedFile = -1
            importButton.isHidden = true
            exportButton.isHidden = true
        }
    }
    //--- textfield
      
      override var canBecomeFirstResponder: Bool {
          //addDoneButtonOnNumpad(textField: cellTextField)
          return true
      }
      func textFieldDidBeginEditing(_ textField: UITextField) {
          textField.becomeFirstResponder()
      }
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          if textField == categoriesField {
              let entree = textField.text
              if entree!.count > 0 {
                  if listeCategories.contains(entree!){
                      textField.text = ""
                  } else {
                    listeCategories.append(entree!)
                      textField.text = ""
                    catTableView.reloadData()
                  }
              }
          }
          return true
      }
      

}
