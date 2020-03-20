//
//  Camembert.swift
//  activitHit1
//
//  Created by patrick lanneau on 22/02/2020.
//  Copyright © 2020 patrick lanneau. All rights reserved.
//

import UIKit

class Camembert: UIView {

    var valeurs : [GrafObject]?
    
    var largeurTrait:CGFloat = 25
    
 
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
       
        //var compteur = 0
        print("avant entrée boucle, valeurs : \(valeurs)")
        if let vals = self.valeurs {
            //0..<vals.count
            var depart:CGFloat = 0.0
            
            for portion in vals {
                let valAngle = CGFloat(portion.val)
                let couleur = portion.couleur
                //let couleur = UIColor.blue
                let arriveen = valAngle + depart
                tracerPortionTarte(depart: depart, arrivee: arriveen, couleur: couleur)
                depart = arriveen
            }
            /*
            let valAngle = CGFloat(75)
            let couleur = vals[1].couleur
            //let couleur = UIColor.blue
            let arriveen = valAngle + depart
            tracerPortionTarte(depart: depart, arrivee: arriveen, couleur: couleur)
             */
        }
    }
    
    func tracerPortionTarte(depart:CGFloat, arrivee : CGFloat, couleur : UIColor) {
        let path = UIBezierPath()
        
        let centieme:CGFloat = 2 * .pi / 100
        let radius = (min(bounds.width, bounds.height) / 2) - (largeurTrait / 2)
        let centre = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        //let path = UIBezierPath(arcCenter: centre, radius: radius, startAngle: depart * centieme, endAngle: arrivee * centieme, clockwise: true)
        let departRadian = enRadian(centieme: Double(depart))
        let arriveeRadian = enRadian(centieme: Double(arrivee))
        
        path.move(to: centre)
        path.addLine(to: pointSurCercle(position: Float(departRadian), rayon: Float(radius), centre: centre))
        path.addArc(withCenter: centre, radius: radius, startAngle: departRadian, endAngle: arriveeRadian, clockwise: true)
        path.addLine(to: pointSurCercle(position: Float(arriveeRadian), rayon: Float(radius), centre: centre))
        
        
        path.close()
        UIColor.black.setStroke()
        couleur.setFill()
        //UIColor.white.setFill()
        path.lineWidth = largeurTrait
        //path.stroke()
        path.fill()
        
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
