//
//  RecurrenceViewController.swift
//  activitHit1
//
//  Created by patrick lanneau on 27/03/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

protocol  Recurrence {
    func recurrencesChoisies(choix:[String:[Int]])
}

class RecurrenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var delegate : Recurrence? = nil

    
    @IBOutlet weak var tableDays: UITableView!
    @IBOutlet weak var tableHours: UITableView!
    @IBOutlet weak var pickerDays: UIPickerView!
    @IBOutlet weak var pickerHours: UIPickerView!
    
    @IBOutlet weak var daysBtn: UIButton!
    @IBOutlet weak var hoursBtn: UIButton!
    
    @IBOutlet weak var choix: UILabel!
    
//    let days = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]
//    let hours = ["0 - 1", "1 - 2", "2 - 3", "3 - 4", "4 - 5", "5 - 6", "6 - 7", "7 - 8", "8 - 9", "9 - 10", "10 - 11", "11 - 12", "12 - 13", "13 - 14", "14 - 15", "15 - 16", "16 - 17","17 - 18", "18 - 19", "19 - 20", "20 - 21", "21 - 22", "22 - 23", "23 - 24"]
//    
    var selectedsDays : [String] = []
    var selectedsHours : [String] = []
    
    var selectedDay: String = ""
    var selectedHour: String = ""
    
    var valChoisies: [String:[Int]] = ["Days":[], "Hours":[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableDays.delegate = self
        tableDays.dataSource = self
        tableHours.dataSource = self
        tableHours.delegate = self
        pickerDays.delegate = self
        pickerDays.dataSource = self
        pickerHours.delegate = self
        pickerHours.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        valChoisies = ["Days":[], "Hours":[]]
        selectedsDays = []
        selectedsHours = []
        selectedDay = ""
        selectedHour = ""
    }
    
    
    @IBAction func addDay(_ sender: Any) {
        if selectedDay.count > 0 {
            if !selectedsDays.contains(selectedDay){
                selectedsDays.append(selectedDay)
            }
            tableDays.reloadData()
            miseAJour()
        }
    }
    @IBAction func addHour(_ sender: Any) {
        if selectedHour.count > 0 {
            if !selectedsHours.contains(selectedHour){
                selectedsHours.append(selectedHour)
            }
            tableHours.reloadData()
            miseAJour()
        }
    }
    
    func miseAJour()  {
        choix.text = "Jours : \(selectedsDays) Heures :   \(selectedsHours)"
        // Mise à jour du dictionnaire
        var choixActuel : [Int] = []
        for i in 0..<days.count {
            if selectedsDays.contains(days[i]){
                choixActuel.append(i + 1)
            }
        }
        valChoisies["Days"] = choixActuel
        choixActuel = []
        for i in 0..<hours.count {
            if selectedsHours.contains(hours[i]){
                choixActuel.append(i)
            }
        }
        valChoisies["Hours"] = choixActuel
        // On signale au délégué
        delegate?.recurrencesChoisies(choix: valChoisies)
    }
    
//MARK:: --- delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableDays {
            return selectedsDays.count
        } else {
            return selectedsHours.count
        }
    }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == tableDays {
            let cell = tableView.dequeueReusableCell(withIdentifier: DAYS_CELL , for: indexPath)
        cell.textLabel?.text = selectedsDays[indexPath.row]
            return cell
       } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HOURS_CELL , for: indexPath)
            cell.textLabel?.text = selectedsHours[indexPath.row]
            return cell
       }
   }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == tableDays {
                selectedsDays.remove(at: indexPath.row)
                tableDays.reloadData()
            } else {
                selectedsHours.remove(at: indexPath.row)
                tableHours.reloadData()
            }
            miseAJour()
        }
    }
    
    // Les picker
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerDays {
            return days.count
        } else {
            return hours.count
        }
   }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if pickerView == pickerDays {
                   return days[row]
               } else {
                   return hours[row]
               }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerDays {
            let val = days[row]
            if !selectedsDays.contains(val){
                //selectedsDays.append(val)
                selectedDay = val
            }
        } else {
            let val = hours[row]
            if !selectedsHours.contains(val){
                //selectedsHours.append(val)
                selectedHour = val
            }
        }
        //miseAJour()
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
