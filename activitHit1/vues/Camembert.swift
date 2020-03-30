//
//  Camembert.swift
//  activitHit1
//
//  Created by patrick lanneau on 22/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

struct VirtualPortion {
    var depart : CGFloat
    var arrivee : CGFloat
    var couleur :UIColor
}

class Camembert: UIView {

    var valeurs : [GrafObject]?
    var selectedObjects :[Int] = []
    var largeurTrait:CGFloat = 1
    
    var vpSimple: [VirtualPortion] = []
    var vpLarge: [VirtualPortion] = []
 
    /*
    init(frame: CGRect, valeursPortions:[String:Double], avecCouleurs : [String:UIColor]) {
        super.init(frame: frame)
        valeurs = valeursPortions
        couleursAssociees = avecCouleurs
        
    }
    
    required init?(coder: NSCoder,valeursPortions:[String:Double], avecCouleurs : [String:UIColor]) {
        super.init(coder: coder)
        self.valeurs = valeursPortions
        self.couleursAssociees = avecCouleurs
        
        //fatalError("init(coder:) has not been implemented")
    }
*/
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        vpLarge = []
        vpSimple = []
        //var compteur = 0
        //print("avant entrée boucle, valeurs : \(String(describing: valeurs))")
        if let vals = self.valeurs {
            //0..<vals.count
            var depart:CGFloat = 0.0
            //for portion in vals
            for item in 0..<vals.count {
                let portion = vals[item]
                let valAngle = CGFloat(portion.val)
                let couleur = portion.couleur
                //let couleur = UIColor.blue
                let arriveen = valAngle + depart
                let newVP = VirtualPortion(depart: depart, arrivee: arriveen, couleur: couleur)
                if selectedObjects.contains(item){
                    vpLarge.append(newVP)
                } else {
                    vpSimple.append(newVP)
                }
                // On prépare l'épaisseur
//                if selectedObjects.contains(item){
//                    largeurTrait = LINE_FAT
//                } else {
//                    largeurTrait = LINE_THIN
//                }
//                tracerPortionTarte(depart: depart, arrivee: arriveen, couleur: couleur)
                depart = arriveen
            }
            largeurTrait = LINE_THIN
            for portion in vpSimple {
                tracerPortionTarte(depart: portion.depart, arrivee: portion.arrivee, couleur: portion.couleur)
            }
            largeurTrait = LINE_FAT
            for portion in vpLarge {
                tracerPortionTarte(depart: portion.depart, arrivee: portion.arrivee, couleur: portion.couleur)
            }
            
        }
    }
    
    func tracerPortionTarte(depart:CGFloat, arrivee : CGFloat, couleur : UIColor) {
        let path = UIBezierPath()
        
        //let centieme:CGFloat = 2 * .pi / 100
        //-- On trace l'intérieur de la portion
        let radius = (min(bounds.width, bounds.height) / 2) - (largeurTrait / 2)
        let centre = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        //let path = UIBezierPath(arcCenter: centre, radius: radius, startAngle: depart * centieme, endAngle: arrivee * centieme, clockwise: true)
        let departRadian = enRadian(centieme: Double(depart))
        let arriveeRadian = enRadian(centieme: Double(arrivee))
        
        let pointDepart = pointSurCercle(position: Float(departRadian), rayon: Float(radius), centre: centre)
        //let pointArrivee =  pointSurCercle(position: Float(arriveeRadian), rayon: Float(radius), centre: centre)
        
        path.move(to: centre)
        //path.addLine(to: pointSurCercle(position: Float(departRadian), rayon: Float(radius), centre: centre))
        path.addLine(to: pointDepart)
        path.addArc(withCenter: centre, radius: radius, startAngle: departRadian, endAngle: arriveeRadian, clockwise: true)
        path.addLine(to: pointSurCercle(position: Float(arriveeRadian), rayon: Float(radius), centre: centre))
        
        
        path.close()
        UIColor.black.setStroke()
        couleur.setFill()
        //UIColor.white.setFill()
        path.lineWidth = largeurTrait
        //path.stroke()
        path.fill()
        
        // Un bord en couronne
        let radiusInterieur = LINE_FAT * 2
        let path2 = UIBezierPath()
        let  departInterieur = pointSurCercle(position: Float(departRadian), rayon: Float(radiusInterieur), centre: centre)
        let arriveeInterieure = pointSurCercle(position: Float(arriveeRadian), rayon: Float(radiusInterieur), centre: centre)
        path2.move(to: departInterieur)
        path2.addLine(to: pointDepart)
        path2.addArc(withCenter: centre, radius: radius, startAngle: departRadian, endAngle: arriveeRadian, clockwise: true)
        path2.addLine(to: arriveeInterieure)
        path2.addArc(withCenter: centre, radius: radiusInterieur, startAngle: arriveeRadian, endAngle: departRadian, clockwise: false)
        path2.lineWidth = largeurTrait
        path2.stroke()
        //print("trace  :de depart \(depart * centieme) à angle = \(arrivee * centieme), rayon : \(radius), couleur : \(couleur)")
    }
    
    //------------
    //-- utilitaires
    func enRadian(centieme: Double)->CGFloat {
        let deuxPi: CGFloat = 2 * .pi
        return deuxPi / 100.0 * CGFloat(centieme)
    }
    func pointSurCercle(position : Float, rayon: Float, centre : CGPoint)-> CGPoint{
        let x = rayon * cos(position)
        let y = rayon * sin(position)
        return CGPoint(x: CGFloat(x) + centre.x, y: CGFloat(y) + centre.y)
    }
    

}
