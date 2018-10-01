//
//  CustomCameraVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class CustomCameraVC: UIViewController,PopUpDelegate {
    var coverView = UIView()
     var popUpView = DiscardPopupView.instanceOfClass()
    
    func isKeepOrDiscard(isKeep: Bool) {
        if isKeep {
            self.popUpView.removeFromSuperview()
        }
        else
        {
            self.popUpView.removeFromSuperview()
        }
        popUpView.removeFromSuperview()
        self.coverView.removeFromSuperview()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.delegate = self
        coverView.frame = self.view.bounds
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    
    @IBAction func recordAction(_ sender: UIButton) {
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        self.popUpView.frame = CGRect(x:60,y:150,width:self.view.frame.size.width - 120,height:self.popUpView.frame.size.height)
        self.view.addSubview(self.coverView)
        coverView.addSubview(popUpView)
    }
    
    @IBAction func switchAction(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
