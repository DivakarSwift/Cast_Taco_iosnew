//
//  ViewController.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
<<<<<<< HEAD
//Director Taco's challenge
=======

>>>>>>> origin/master
    @IBOutlet weak var enterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        self.enterBtn.roundBtn()
=======
     self.enterBtn.roundBtn()
>>>>>>> origin/master
    }

    @IBAction func enterAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLoginVC") as! ChooseLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
<<<<<<< HEAD
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
=======
>>>>>>> origin/master
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension UIButton
{
    func roundBtn()
    {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
}

<<<<<<< HEAD
extension UIView {
    func dropShadow(offsetX: CGFloat, offsetY: CGFloat, color: UIColor, opacity: Float, radius: CGFloat, scale: Bool = true, deviceType : String) {
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        // layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        if deviceType ==  "iPhone5" {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
        else if deviceType ==  "iPhone6" {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            //  layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        }//iPhone6
        else if deviceType ==  "iPhone6Plus" {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width + 38, height: self.frame.height)
        }
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
=======
>>>>>>> origin/master
