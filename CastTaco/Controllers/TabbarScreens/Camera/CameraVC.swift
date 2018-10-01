//
//  CameraVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit


class CameraVC: UIViewController {
    
    private var shouldPresentCamera = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldPresentCamera {
            showCamera()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cameraViewShouldAppear(value:)), name:Notification.Name(rawValue: "cameraViewShouldAppear"), object: nil)
    }
    
    @objc func cameraViewShouldAppear(value:Notification) {
        shouldPresentCamera = true
    }
    
    func showCamera() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomCameraVCId") as! CustomCameraVC
        vc.delegate = self
        vc.topTitle = "Family Singing in a car"
        self.navigationController?.present(vc, animated: true, completion: nil)
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

extension CameraVC : CustomCameraVCDelegate {
    func videoDidCaptured(videoUrl: URL?) {
        self.tabBarController?.selectedIndex = 1
        self.shouldPresentCamera = true
    }
    
    @objc func willDismissed(videoUrl: URL?) {
        shouldPresentCamera = false
    }
    
    func didDismissed(videoUrl: URL?) {
        self.tabBarController?.selectedIndex = 1
        self.shouldPresentCamera = true
    }
    
}
