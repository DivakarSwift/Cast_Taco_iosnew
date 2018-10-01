//
//  CameraVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
        self.navigationController?.pushViewController(vc, animated: false)
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
