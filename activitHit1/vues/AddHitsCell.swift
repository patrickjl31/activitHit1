//
//  AddHitsCell.swift
//  activitHit1
//
//  Created by patrick lanneau on 12/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class AddHitsCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var hitBtn: UIButton!
    @IBOutlet weak var hitLbl: UILabel!
    @IBOutlet weak var categorieLbl: UILabel!
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var hitField: UITextField!{
        didSet {
            hitField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)), onCancel: (target: self, action: #selector(cancelButtonTappedForMyNumericTextField)))
            // Penser à écrire la fonction doneButtonTappedForMyNumericTextField
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        hitField.delegate = self
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
        var val = Double(textField.text ?? "") ?? 0.0
        if val < 0.0 {
            val = 0.0
        }
        //hitBtn.tag = extractTagFromBigtag(bigtag: hitBtn.tag) + Int(val)
        hitBtn.tag = hitBtn.tag.extractTagFromBigtag().toBigtag() + Int(val)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        var val = Double(textField.text ?? "") ?? 0.0
        if val < 0.0 {
            val = 0.0
        }
        //hitBtn.tag = toBigtag(tag: extractTagFromBigtag(bigtag: hitBtn.tag)) + Int(val)
        hitBtn.tag = hitBtn.tag.extractTagFromBigtag().toBigtag() + Int(val)
        //print(hitBtn.tag)
    }
    
    //------------
    // gestion clavier
    @objc func doneButtonTappedForMyNumericTextField() {
        //print("Done");
        hitField.resignFirstResponder()
        var val = Double(hitField.text ?? "") ?? 0.0
        if val < 0.0 {
            val = 0.0
        }
         //hitBtn.tag = toBigtag(tag: extractTagFromBigtag(bigtag: hitBtn.tag)) + Int(val)
        hitBtn.tag = hitBtn.tag.extractTagFromBigtag().toBigtag() + Int(val)
               //print(hitBtn.tag)
    }
    
    @objc func cancelButtonTappedForMyNumericTextField() {
        //print("Cancel");
        
        hitField.text = "1"
        // hitBtn.tag = toBigtag(tag: extractTagFromBigtag(bigtag: hitBtn.tag)) + 1
        hitBtn.tag = hitBtn.tag.extractTagFromBigtag().toBigtag() + 1
                     // print(hitBtn.tag)
    }
    
    
    //----------
//
//    func extractValFromBigtag(tag:Int) -> Int {
//        let val = tag % 1000000
//        return val
//    }
//    func extractTagFromBigtag(bigtag: Int)->Int{
//        let val = (bigtag - extractValFromBigtag(tag: bigtag)) / 1000000
//        return val
//    }
//    func toBigtag(tag:Int) -> Int {
//        return tag * 1000000
//    }


    
}




extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "OK", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}



// -------------
// Extension Int pour gérere les tags en transportant une valeur et le tag
extension Int {
    
    func extractValFromBigtag() -> Int {
        let val = abs(self) % 1000000
              return val
          }
    func extractTagFromBigtag()->Int{
        let val = (abs(self) - self.extractValFromBigtag()) / 1000000
          return val
      }
       
    func toBigtag() -> Int {
           return abs(self) * 1000000
       }
    func addValToBigTag(val:Int) -> Int? {
        if self > 1000000 {
            return self + val
        }
        return nil
    }
    func  createBigTag(tag:Int, val:Int) -> Int {
           return abs(tag) * 1000000 + abs(val)
       }
          
}

