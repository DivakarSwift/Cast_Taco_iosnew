//
//  NameScreenVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 10/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit


class NameScreenVC: UIViewController {
    
    @IBOutlet weak var fNametext: UITextField!
    @IBOutlet weak var lNametext: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var selectedLoginType: MenualLoginType?
    var password: String?
    var email: String?
    
    private var firstName: String = ""
    private var lastName: String = ""
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftView = UILabel(frame: CGRect(x: 20, y: 0, width: 15, height: 26))
        leftView.backgroundColor = UIColor.clear
       
        self.fNametext.leftView = leftView
        self.fNametext.leftViewMode = .always
        self.fNametext.contentVerticalAlignment = .center
        
        let leftView2 = UILabel(frame: CGRect(x: 20, y: 0, width: 15, height: 26))
        leftView2.backgroundColor = UIColor.clear
        
        self.lNametext.leftView = leftView2
        self.lNametext.leftViewMode = .always
        self.lNametext.contentVerticalAlignment = .center
        
//        btnNext.alpha = 0.6
//        btnNext.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        btnNext.cornerRadius = btnNext.frame.height/2
        fNametext.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
        lNametext.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        return
        
        if (self.fNametext.text?.count)! > 0 && (self.lNametext.text?.count)! > 0 {
            self.btnNext.isUserInteractionEnabled = true
            self.btnNext.alpha = 1
        } else {
            self.btnNext.isUserInteractionEnabled = false
            self.btnNext.alpha = 0.6
        }
        
    }
    
    
    @IBAction func backAction(sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(sender:Any) {
        
        guard let firstname = fNametext.text?.trimmingCharacters(in: .whitespacesAndNewlines), firstname.count > 0 else {
            Singleton.shared.showAlert(title: "Invalid firstname", message: "Please enter a valid firstname.")
            return
        }
        
        guard let lastname = lNametext.text?.trimmingCharacters(in: .whitespacesAndNewlines), lastname.count > 0 else {
            Singleton.shared.showAlert(title: "Invalid lastname", message: "Please enter a valid lastname.")
            return
        }
        
        if selectedLoginType == .email {
            viewModel.registerUserWith(email: self.email!, password: self.password!, firstName: firstname, lastName: lastname) { (success) in
                if success {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }
            
        } else if selectedLoginType == .phoneNumber {
            viewModel.registerUserWith(phone: self.email!, password: self.password!, firstName: firstname, lastName: lastname) { (success) in
                if success {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }
        }
    }

}

extension NameScreenVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.letters
        let allowedCharacters2 = CharacterSet.whitespaces
        let characterSet = CharacterSet(charactersIn: string)
        
        // whiteSpace not allowed as first character.
        if textField.text?.count == 0 && string == " " {
            return false
        }
        
        //Only letters and white space allowed then.
        return allowedCharacters.isSuperset(of: characterSet) || allowedCharacters2.isSuperset(of: characterSet)
    }
    
}


