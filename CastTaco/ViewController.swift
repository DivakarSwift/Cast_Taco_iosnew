//
//  ViewController.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     self.enterBtn.roundBtn()
    }

    @IBAction func enterAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLoginVC") as! ChooseLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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

