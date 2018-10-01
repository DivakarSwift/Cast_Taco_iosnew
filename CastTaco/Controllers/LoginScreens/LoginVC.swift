//
//  LoginVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailText: CustomSearchTextField!
    @IBOutlet weak var passwordtext: TextField!
    @IBOutlet weak var joinButton: UIButton!
    
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

        self.emailText.leftView = leftView
        self.emailText.leftViewMode = .always
        self.emailText.contentVerticalAlignment = .center
        
        self.passwordtext.leftView = leftViewPass
        self.passwordtext.leftViewMode = .always
        self.passwordtext.contentVerticalAlignment = .center
        
        self.joinButton.layer.shadowColor = UIColor.lightGray.cgColor
        self.joinButton.layer.shadowOpacity = 0.4
        self.joinButton.layer.shadowOffset = CGSize.zero
        self.joinButton.layer.shadowRadius = 2
        self.joinButton.layer.masksToBounds = false
        
//      self.joinButton.isUserInteractionEnabled = false
//      self.joinButton.alpha = 0.6
        
        if selectedLoginType == .email {
            self.emailText.placeholder = "Email"
        } else if selectedLoginType == .phoneNumber {
            self.emailText.placeholder = "Phone number"
            self.emailText.keyboardType = .numberPad
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLayoutSubviews() {
        emailText.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
        passwordtext.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
        joinButton.cornerRadius = joinButton.frame.height/2
    }
    
    /* ------------------------------------------------------------------------------------- */
    //MARK:- Buttons Methods
    
    @IBAction func joinUsAction(_ sender: UIButton) {
        let str = selectedLoginType == .email ? "email" : "phone number"
        
        guard let password = passwordtext.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let email = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
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
            guard email.count > 0, viewModel.isValidEmail(testStr: email) else {
                Singleton.shared.showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
                return
            }
            
            viewModel.emailLogin(email: email, password: password, success: {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
            })
            
        } else if selectedLoginType == .phoneNumber {
            
            guard email.count > 0 else {
                Singleton.shared.showAlert(title: "Invalid Phone number", message: "Please enter a valid phone number.")
                return
            }
            
            viewModel.phoneNumberLogin(phone: email, password: password) {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        return
        
        guard selectedLoginType == .email else {
            if (self.emailText.text?.count)! > 0 && (self.passwordtext.text?.count)! > 0 {
                self.joinButton.isUserInteractionEnabled = true
                self.joinButton.alpha = 1
            } else {
                self.joinButton.isUserInteractionEnabled = false
                self.joinButton.alpha = 0.6
            }
            
            return
        }
        
        if (self.emailText.text?.count)! > 0 && (self.passwordtext.text?.count)! > 0 && viewModel.isValidEmail(testStr: self.emailText.text!) {
            self.joinButton.isUserInteractionEnabled = true
            self.joinButton.alpha = 1
        } else {
            self.joinButton.isUserInteractionEnabled = false
            self.joinButton.alpha = 0.6
        }

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}
