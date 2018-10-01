//
//  SignUpVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 12/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

enum MenualLoginType {
    case email
    case phoneNumber
}

class SignUpVC: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblEmailError: UILabel!
    
    let viewModel = LoginViewModel()
    var selectedLoginType: MenualLoginType?
    
    private var email:String = ""
    private var password: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftView = UILabel(frame: CGRect(x: 20, y: 0, width: 15, height: 26))
        leftView.backgroundColor = UIColor.clear
        
        let leftViewPass = UILabel(frame: CGRect(x: 20, y: 0, width: 15, height: 26))
        leftViewPass.backgroundColor = UIColor.clear
        
        self.emailTxtField.leftView = leftView
        self.emailTxtField.leftViewMode = .always
        self.emailTxtField.contentVerticalAlignment = .center
        
        self.passwordTextField.leftView = leftViewPass
        self.passwordTextField.leftViewMode = .always
        self.passwordTextField.contentVerticalAlignment = .center
        
//      self.btnJoin.isUserInteractionEnabled = false
//      self.btnJoin.alpha = 0.6
        
        if selectedLoginType == .email {
            self.emailTxtField.placeholder = "Email"
        } else if selectedLoginType == .phoneNumber {
            self.emailTxtField.placeholder = "Phone number"
            self.emailTxtField.keyboardType = .numberPad
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinAction(_ sender: Any) {
        
        let str = selectedLoginType == .email ? "email" : "phone number"
        
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let email = emailTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            (password.count > 0 || email.count > 0) else {
            Singleton.shared.showAlert(title: "Invalid \(str) or password", message: "Please enter valid \(str) and password.")
            return
        }
        
        guard email.count > 0 else {
            Singleton.shared.showAlert(title: "Invalid \(str)", message: "\(str.capitalized) can not be empty. Please enter a valid \(str).")
            return
        }
        
        guard password.count > 0 else {
            Singleton.shared.showAlert(title: "Invalid password", message: "Password can not be empty. Please enter a valid password.")
            return
        }
        
        if selectedLoginType == .email {
            
            guard viewModel.isValidEmail(testStr: email) else {
                Singleton.shared.showAlert(title: "Invalid email", message: "Please enter a valid email address.")
                return
            }
            
            viewModel.checkEmailAvailability(email: email) { (alreadyExists) in
                if alreadyExists {
                    Singleton.shared.showAlert(title: "Error", message: "This email is already used by other user. Please try with other account.")
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NameScreenVCId") as! NameScreenVC
                    vc.email = email
                    vc.password =  password
                    vc.selectedLoginType = .email
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        } else if selectedLoginType == .phoneNumber {
            
            guard email.count > 0 else {
                Singleton.shared.showAlert(title: "Invalid password", message: "Please enter a valid password.")
                return
            }
            
            viewModel.checkPhoneNumberAvailability(phone: email) { (alreadyExists) in
                if alreadyExists {
                    Singleton.shared.showAlert(title: "Alert", message: "This phone number is already used by other user. Please try with other number.")
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NameScreenVCId") as! NameScreenVC
                    vc.email = email
                    vc.selectedLoginType = .phoneNumber
                    vc.password = password
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        emailTxtField.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
        passwordTextField.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
        btnJoin.cornerRadius = btnJoin.frame.height/2
    }
    
    @IBAction func signInAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.selectedLoginType = self.selectedLoginType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        return
        
        guard selectedLoginType == .email else {
            
            if (self.emailTxtField.text?.count)! > 0 && (self.passwordTextField.text?.count)! > 0 {
                self.btnJoin.isUserInteractionEnabled = true
                self.btnJoin.alpha = 1
            } else {
                self.btnJoin.isUserInteractionEnabled = false
                self.btnJoin.alpha = 0.6
            }
            
            return
        }
        
        if (self.emailTxtField.text?.count)! > 0 && (self.passwordTextField.text?.count)! > 0 && viewModel.isValidEmail(testStr: self.emailTxtField.text!) {
            self.btnJoin.isUserInteractionEnabled = true
            self.btnJoin.alpha = 1
        } else {
            self.btnJoin.isUserInteractionEnabled = false
            self.btnJoin.alpha = 0.6
        }
        
    }
    
    
}


extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
}
