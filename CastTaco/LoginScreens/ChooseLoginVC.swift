//
//  ChooseLoginVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class ChooseLoginVC: UIViewController {
    
   //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK:- Buttons Methods
    @IBAction func emailAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- Memory Warning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
