//
//  ChooseLoginVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import SafariServices
import SwiftInstagram
import Alamofire

class ChooseLoginVC: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var termsLable: UILabel!
        
    let viewModel = LoginViewModel()

    var loginWebView: UIView! = nil
    
   //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termsLable.attributedText = Singleton.shared.termsConditionString()
        self.preloadInstaView()
    }
    
    override func viewDidLayoutSubviews() {
        facebookButton.cornerRadius = facebookButton.frame.height/2
        instagramButton.cornerRadius = instagramButton.frame.height/2
        emailButton.cornerRadius = emailButton.frame.height/2
        phoneButton.cornerRadius = phoneButton.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK:- Buttons Methods
    @IBAction func emailAction(_ sender: UIButton) {
        self.moveToSignup(type: .email)
    }
    
    //MARK:- Memory Warning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func moveToSignup (type: MenualLoginType) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVCId") as! SignUpVC
        vc.selectedLoginType = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func facebookAction(_ sender: UIButton) {
    
        viewModel.facebookLogin(self, success: {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
            
        }, loginUsingEmail: { email in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.selectedLoginType = .email
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { (error, loginCode) in
            if error == AppError.userAlreadyRegistered {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    let loginType = loginCode == 0 ? "Email" : (loginCode == 1 ? "Facebook" : "Instagram")
                    Singleton.shared.showAlert(title: "Unable to login", message: "Email associated with this account is already registered through \(loginType) login. Please try with different account.")
                })
            } else if error == AppError.operationCancelled {
               // Singleton.shared.showAlert(title: "Unable to login", message: "Operation login with facebook is cancelled. Please try again.")
            } else {
                Singleton.shared.showAlert(title: "Login failed", message: error.localizedDescription)
            }
        }
    }
    
    
    
    @IBAction func instagramAction(_ sender: UIButton) {
        refreshWebCache()
        self.view.addSubview(self.loginWebView)

        /*
        if UIApplication.shared.canOpenURL( URL.init(string: "instagram://")!) {
            UIApplication.shared.openURL( URL.init(string: authURL)!)
        } else {
            let svc = SFSafariViewController(url: URL.init(string: authURL)!)
            svc.delegate = self
            present(svc, animated: true, completion: nil)
        }
         */
    }
    
    
    private func refreshWebCache(){
        let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! as [HTTPCookie]{
            NSLog("cookie.domain = %@", cookie.domain)
            
            if cookie.domain == "www.instagram.com" || cookie.domain == "api.instagram.com" ||  cookie.domain == ".instagram.com" {
                cookieJar.deleteCookie(cookie)
            }
        }
    }
    
    private func preloadInstaView() {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_API.AUTHURL,INSTAGRAM_API.CLIENT_ID,INSTAGRAM_API.REDIRECT_URI, INSTAGRAM_API.SCOPE])
        
        // REFRESH WebView
        
        refreshWebCache()
        
        if loginWebView != nil {
            loginWebView.removeFromSuperview()
        }
        
        loginWebView = nil
        loginWebView = UIView(frame: CGRect(x: 0, y: 25, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 25))
        
        let back = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        back.image = #imageLiteral(resourceName: "backarrow")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.backFromInstagram))
        tap.numberOfTapsRequired = 1
        
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(tap)
        
        let webView = UIWebView(frame: CGRect(x: 0, y: 25, width: loginWebView.frame.width, height:  loginWebView.frame.height - 20))
        webView.delegate = self
        
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        webView.loadRequest(urlRequest)
        
        loginWebView.addSubview(back)
        loginWebView.addSubview(webView)
    }
    
    
    @objc private func backFromInstagram() {
        self.loginWebView.removeFromSuperview()
        self.preloadInstaView()
    }
    
    @IBAction func phoneNumberAction(_ sender: UIButton) {
        self.moveToSignup(type: .phoneNumber)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        print("UUUrl -> \(requestURLString)")
        
        if requestURLString.hasPrefix(INSTAGRAM_API.REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String) {
        //print("Instagram authentication token ==", authToken)
        self.loginWebView.removeFromSuperview()
        DispatchQueue.main.async {
            Singleton.shared.showLoader()
        }
        viewModel.getInstagramDetail(authToken: authToken, success: { instaData in
            self.viewModel.uploadInstaDataOnServer(data: instaData, firstResponse: {
                DispatchQueue.main.async {
                    Singleton.shared.hideLoader()
                }
            }, success: {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }, error: { (error, loginCode) in
                if error == AppError.userAlreadyRegistered {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let loginType = loginCode == 0 ? "Email" : (loginCode == 1 ? "Facebook" : "Instagram")
                        Singleton.shared.showAlert(title: "Unable to login", message: "Email associated with this account is already registered through \(loginType) login. Please try with different account.")
                    })
                } else {
                    Singleton.shared.showAlert(title: "Login failed", message: error.localizedDescription)
                }
            })
            
        }, failed: {
            DispatchQueue.main.async {
                Singleton.shared.hideLoader()
            }
        })
    }
    
}


extension ChooseLoginVC: SFSafariViewControllerDelegate, UIWebViewDelegate {
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
//        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
//        checkRequestForCallbackURL(request: request)
    }

    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL.absoluteString)
        let urlRequest = URLRequest.init(url: URL)
        checkRequestForCallbackURL(request: urlRequest)
    }

 
    func webView(_ webView: UIWebView, shouldStartLoadWith request:URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
}
