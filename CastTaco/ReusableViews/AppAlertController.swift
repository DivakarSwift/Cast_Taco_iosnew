//
//  AppAlertController.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 14/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class AppAlertController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var buttonsSeprator: UILabel!
    
    @IBOutlet weak var widthConstBtn2: NSLayoutConstraint!
    
    //private var popUpView = DiscardPopupView.instanceOfClass()
    
    var titleString: String?
    var descriptionString: String?
    var firstBtnTitle: String?
    var secondBtnTitle: String?
    
    var callBackCancel:(()->())?
    var callBackSecondAction:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popUpView.delegate = self
        view.isOpaque = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.lblTitle.text = titleString
        self.lblDescription.text = descriptionString
        
        btnOk.setTitle(firstBtnTitle, for: .normal)
        btn2.setTitle(secondBtnTitle, for: .normal)

    }
    
    override func viewDidLayoutSubviews() {
//    if let descrip = self.descriptionString , let title = self.titleString {
//       popUpView.setUpfrom(self, title: title, description: descrip)
//       popUpView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//       // self.view.addSubview(popUpView)
//    } else {
//       self.navigationController?.popViewController(animated: false)
//    }
        
        if secondBtnTitle != nil && secondBtnTitle != "" {
            widthConstBtn2.constant = lblDescription.frame.width/2
            buttonsSeprator.isHidden = false
        } else {
            widthConstBtn2.constant = 0
            buttonsSeprator.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOk(_ sender: Any) {
        self.dismiss(animated: false) {
            defer {
                if let callback = self.callBackCancel {
                    callback()
                }
            }
        }
    }
    
    @IBAction func btn2Action(_ sender: Any) {
        self.dismiss(animated: false) {
            defer {
                if let callback = self.callBackSecondAction {
                    callback()
                }
            }
        }
    }
    
    
}

/* extension AppAlertController: DiscardPopupViewDelegate {
    func cancelPressed() {
        if let callback = self.callBackCancel {
            callback()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func donePressed() {
        if let callback = self.callBackSecondAction {
            callback()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
} */

