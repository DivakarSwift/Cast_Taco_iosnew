//
//  ActionSheetViewController.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 30/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import Alamofire

enum SheetType {
    case myPost
    case userPost
    case mySuggestion
    case userSuggestion
}

enum actionSheetAction {
    case report
    case follow
    case unfollow
    case share
    case download
    case delete
}

struct ActionSheetCompletionHandler {
    
    var type: SheetType?
    var selectedIndex: Int?
    var selectedAction: actionSheetAction
    var info : [String : Any]?
    
    init(type: SheetType?, selectedIndex: Int?, selectedAction: actionSheetAction, info: [String : Any]?) {
        self.type = type
        self.selectedIndex = selectedIndex
        self.selectedAction = selectedAction
        self.info = info
    }
    
}

class ActionSheetViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAction1: UIButton!
    @IBOutlet weak var btnAction2: UIButton!
    @IBOutlet weak var btnSingleAction: UIButton!
    @IBOutlet weak var twoButtonsView: UIView!
    @IBOutlet weak var singleButtonView: UIView!
    
    var sheetFor : SheetType?
    var info:[String : Any]?
    var alertActionCompletion:((ActionSheetCompletionHandler)->())?
    
    private var preStatusBarColor : UIColor?
   
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Override Methodes
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = false
    
        let tap  = UITapGestureRecognizer(target: self, action: #selector(hide))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        if sheetFor == SheetType.myPost {
            btnAction2.setTitle("Share", for: .normal)
            btnAction2.setTitleColor(AppColors.JuanPurple, for: .normal)
            btnAction1.setTitle("Download", for: .normal)
            btnAction1.setTitleColor(AppColors.JuanPurple, for: .normal)
            btnCancel.setTitle("Cancel", for: .normal)
            
        } else if sheetFor == SheetType.userPost || sheetFor == SheetType.userSuggestion {
            if let info = info, info["followedByMe"] as? Bool == true {
                btnAction2.setTitle("Unfollow username", for: .normal)
            } else {
                btnAction2.setTitle("Follow username", for: .normal)
            }
            
            btnAction2.setTitleColor(AppColors.JuanPurple, for: .normal)
            btnAction1.setTitle("Inappropriate. \"Watch out Mr. Taco!\" ", for: .normal)
            btnAction1.setTitleColor(AppColors.Red, for: .normal)
            
            btnAction1.titleLabel?.adjustsFontSizeToFitWidth = true
            btnAction1.titleLabel?.minimumScaleFactor = 0.2
            btnCancel.setTitle("Never mind", for: .normal)
        
        } else if sheetFor == SheetType.mySuggestion {
             twoButtonsView.isHidden = true
             singleButtonView.isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Actions
     */
    
    @IBAction func action1(_ sender: Any) {
        if sheetFor == SheetType.userPost {
            
        } else if sheetFor == SheetType.userSuggestion, let suggestion_id = info?["suggestion_id"] as? String {
            reportSuggstion(suggestionId: suggestion_id)
        }
        self.hide()
    }
    
    @IBAction func action2(_ sender: Any) {
        if sheetFor == SheetType.userPost {
            
        } else if sheetFor == SheetType.userSuggestion, let otherUserId = info?["followed_user_id"] as? String {
            followUnfollowUser(otherUserId: otherUserId)
        }
        
        self.hide()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.hide()
    }
    
    
    @IBAction func btnSingleAction(_ sender: Any) {
        if sheetFor == SheetType.mySuggestion, let suggestion_id = info?["suggestion_id"] as? String {
            
            let contrl = UIAlertController(title: "Are you sure?", message: "Do you want to delete your suggestion?", preferredStyle: .alert)
            
            let alertaction1 = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.deleteMySuggestion(suggestion_id: suggestion_id)
            }
            
            let alertaction2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            contrl.addAction(alertaction1)
            contrl.addAction(alertaction2)
            
            Singleton.shared.topViewController()?.present(contrl, animated: true, completion: nil)
            
        }
    }
    
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Methods
     */
    
    
    func changeBackGround(_ color:UIColor, opacity:CGFloat) {
        
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        self.view.backgroundColor = color.withAlphaComponent(opacity)
    }
    
    
    func reportSuggstion(suggestionId:String) {
        
        let apiname = backendUrl(folder: BackendFolder.challenge, action: BackendAction.reportSuggestion)
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "", "suggestion_id" : suggestionId] // 1=like , 2=unlike or sad
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            
        }, success: { (response) in
            print(response)
            
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    self.alertActionCompletion!(ActionSheetCompletionHandler(type: SheetType.userPost, selectedIndex: 2, selectedAction: actionSheetAction.report, info: self.info))
                } else {
                    self.alertActionCompletion = nil
                }
            }
            
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
        
    }
    
    
    func followUnfollowUser(otherUserId:String) {
        
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.followUnfollowUser)
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "", "followed_user_id" : otherUserId] // 1=like , 2=unlike or sad
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            
        }, success: { (response) in
            print(response)
            
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    var selectedAction = actionSheetAction.follow
                    if let followStatus = response.value(forKeyPath: "data.status") as? Int, followStatus == 0 {
                        selectedAction = actionSheetAction.unfollow
                    }
                    
                    self.alertActionCompletion!(ActionSheetCompletionHandler(type: SheetType.userPost, selectedIndex: 1, selectedAction: selectedAction, info: self.info))
                } else {
                    self.alertActionCompletion = nil
                }
            }
            
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
        
    }
    
    
    func deleteMySuggestion(suggestion_id:String) {
        
        let apiname = backendUrl(folder: BackendFolder.challenge, action: BackendAction.deleteMySuggestion)
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "", "suggestion_id": suggestion_id]
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
           
        }, success: { (response) in
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    self.alertActionCompletion!(ActionSheetCompletionHandler(type: SheetType.mySuggestion, selectedIndex: 1, selectedAction: actionSheetAction.delete, info: self.info))
                } else {
                    self.alertActionCompletion = nil
                }
            }
             self.hide()
        }) { (errorr) in
            print(errorr.localizedDescription)
             self.hide()
        }
        
    }

    
    @objc func hide() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true, completion: nil)
        }
        
        UIView.transition(with: self.view, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
        self.view.backgroundColor = UIColor.clear
    }
    
    

}
