//
//  LoginViewModel.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 04/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

struct SocialMediaPlatform {
    static var Facebook:String = "1"
    static var Instagram:String = "2"
}

struct FBData {
    var social_id:String?
    var name:String?
    var email_id:String?
    var firstname:String?
    var lastname:String?
    var pictureUrl:String?
    var picture : UIImage?
    
    init(social_id:String?,name:String?, email_id:String?, firstname:String?, lastname:String?, pictureUrl:String?,picture : UIImage? = nil) {
        self.social_id = social_id
        self.name = name
        self.email_id = email_id
        self.firstname = firstname
        self.lastname = lastname
        self.pictureUrl = pictureUrl
        self.picture = picture
    }
    
}

struct InstagramData {
    
    var social_id: String?
    var full_name:String?
    var username:String?
    var followed_by:Int?
    var follows:Int?
    var mediaCount:Int?
    var pictureUrl:String?
    
    init(social_id:String?,username:String?, full_name:String? , pictureUrl:String?, followed_by:Int?, follows:Int?, mediaCount:Int?) {
        self.social_id = social_id
        self.username = username
        self.full_name = full_name
        self.pictureUrl = pictureUrl
        self.followed_by = followed_by
        self.follows = follows
        self.mediaCount = mediaCount
    }
    
    
    /*
     data =     {
     bio = "";
     counts =         {
     "followed_by" = 1;
     follows = 4;
     media = 7;
     };
     "full_name" = "brst dev testing";
     id = 4863810704;
     "is_business" = 0;
     "profile_picture" = "https://scontent.cdninstagram.com/vp/74d4a001973ffb1c519909dc584b0316/5C328D7A/t51.2885-19/11906329_960233084022564_1448528159_a.jpg";
     username = brstdev5;
     website = "";
     };
     meta =     {
     code = 200;
     };
 
    */
    
}


class LoginViewModel: NSObject {
    
    /*
     MARK: Phone Number Login
     */
    
    func checkPhoneNumberAvailability(phone:String?, status: @escaping(Bool)->()) {
        
        guard phone != "", let phone = phone else {
            Singleton.shared.showAlert(title: "Alert", message: "Email can not be empty")
            return
        }
        
        guard isValidPhoneNumber(testStr: phone) else {
            Singleton.shared.showAlert(title: "Invalid phone number", message: "Please enter a valid phone number.")
            return
        }
      
        let parameters: Parameters = ["phone": phone]
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.phoneVerification)
        Singleton.shared.showLoader()
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            Singleton.shared.hideLoader()
        }, success: { (response) in
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "400" {
                    status(true)
                } else {
                    status(false)
                }
            }
        }) { (errorr) in
            status(false)
            print(errorr.localizedDescription)
        }
        
    }
    
    func isValidPhoneNumber(testStr:String) -> Bool {
        //return true
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: testStr)
        return result
    }
    
    
    func phoneNumberLogin(phone:String?, password:String?, success:@escaping()->()) {
        
        guard phone != "", password != "", let phone = phone, let password = password else {
            Singleton.shared.showAlert(title: "Alert", message: "phone or password can not be empty")
            return
        }
       
        /* guard isValidPhoneNumber(testStr: phone) else {
            Singleton.shared.showAlert(title: "Invalid email", message: "Please enter a valid email address.")
            return
        } */
        
       /* guard phone.isPhoneNumber else {
            Singleton.shared.showAlert(title: "Invalid email", message: "Please enter a valid email address.")
            return
        } */
        
        let parameters: Parameters = ["phone": phone,"password_hash":password,"device_token":"123"]
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.phoneLogin)
        
        Singleton.shared.showLoader()
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            Singleton.shared.hideLoader()
        }, success: { (response) in
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    DataManager.shared.setProfileData(dictionary: response)
                    success()
                } else {
                    Singleton.shared.showAlert(title: "Invalid phone number or password", message: "Please enter a valid phone number and password.")
                }
            }
            
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
    }
    
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Email Login
     */
    
    func emailLogin(email:String?, password:String?, success:@escaping()->()) {
        
        guard email != "", password != "", let email = email, let password = password else {
            Singleton.shared.showAlert(title: "Alert", message: "email or password can not be empty")
            return
        }
        
        guard isValidEmail(testStr: email) else {
            Singleton.shared.showAlert(title: "Invalid email", message: "Please enter a valid email address.")
            return
        }
        
        let parameters: Parameters = ["email": email,"password_hash":password,"device_token":"123"]
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.emailLogin)
        
        Singleton.shared.showLoader()
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            Singleton.shared.hideLoader()
            
        }, success: { (response) in
            
            if (response.value(forKey: "status") as! String == "200") {
                DataManager.shared.setProfileData(dictionary: response)
                success()
            } else if (response.value(forKey: "status") as! String == "400") {
                DispatchQueue.main.async {
                     Singleton.shared.showAlert(title: "Error", message: response.value(forKey: "message") as! String)
                }
            } else {
                DispatchQueue.main.async {
                    Singleton.shared.showAlert(title: "Invalid password", message: "The password is incorrect. Please try again.")
                }
            }
            
        }) { (errorType) in
            
        }
        
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func checkEmailAvailability(email:String?, status: @escaping(Bool)->()) {
        
        guard email != "", let email = email else {
            status(false)
            Singleton.shared.showAlert(title: "Alert", message: "Email can not be empty")
            return
        }
        
        guard isValidEmail(testStr: email) else {
            status(false)
            Singleton.shared.showAlert(title: "Invalid email", message: "Please enter a valid email address.")
            return
        }
        
        let parameters: Parameters = ["email": email]
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.emailVerification)
        
        Singleton.shared.showLoader()
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            Singleton.shared.hideLoader()
        }, success: { (response) in
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "400" {
                    status(true)
                } else {
                    status(false)
                }
            }
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
        
    }
    
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Manual Registration
     */
    
    func registerUserWith(phone:String, password:String, firstName:String, lastName:String ,success: @escaping(Bool)->()) {
        
        let parameters: Parameters = ["phone": phone, "first_name": firstName, "last_name": lastName, "password_hash": password, "device_token": "123"]
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.registerUserWithPhone)
        Singleton.shared.showLoader()
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            Singleton.shared.hideLoader()
        }, success: { (response) in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                if response.value(forKey: "status") as! String == "200" {
                    DataManager.shared.setProfileData(dictionary: response)
                    success(true)
                } else {
                    success(false)
                }
            })
            
        }) { (errorr) in
            success(false)
            print(errorr.localizedDescription)
        }
    }
    
    
    func registerUserWith(email:String, password:String, firstName:String, lastName:String ,success: @escaping(Bool)->()) {
        
        let parameters: Parameters = ["email": email, "first_name": firstName, "last_name": lastName, "password_hash": password, "device_token": "123"]
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.registerUserWithEmail)
        
        Singleton.shared.showLoader()
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            Singleton.shared.hideLoader()
        
        }, success: { (response) in
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    DataManager.shared.setProfileData(dictionary: response)
                    success(true)
                } else {
                    success(false)
                }
            }
        }) { (errorr) in
            success(false)
            print(errorr.localizedDescription)
        }
    }
    
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Instagram Registration
    */
    
    func uploadInstaDataOnServer(data:InstagramData, firstResponse: @escaping() -> (), success: @escaping() -> (), error:@escaping(AppError, _ status:Int)->()){
        
        let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.socialLogin)
        let parameters: Parameters = ["social_id": data.social_id ?? "", "name": data.full_name ?? "", "social_media": SocialMediaPlatform.Instagram, "device_token": "123", "email": ""]
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            firstResponse()
        }, success: { (response) in
            DispatchQueue.main.async {
                
                guard let status = response.value(forKey: "status") as? String else {
                    error(AppError.invalidResponse, -1)
                    return
                }
                
                guard status == "200" else {
                    if status == "404", let login_code = response.value(forKeyPath: "key.login_type") as? Int {
                        error(AppError.userAlreadyRegistered,login_code)
                    } else {
                        error(AppError.invalidResponse, -1)
                    }
                    return
                }
                
                DataManager.shared.setProfileData(dictionary: response)
                success()
            }
            
        }) { (errorr) in
            error(AppError.invalidResponse, -1)
        }
    }
    
    func getInstagramDetail(authToken: String, success: @escaping (InstagramData) -> (), failed: @escaping ()->()) {
        
        let apiname = "https://api.instagram.com/v1/users/self/?access_token=\(authToken)"
        
        Alamofire.request(apiname)
        .responseJSON { response in
            print(response)
            if let json2 = response.result.value as? NSDictionary, let data = json2.value(forKey: "data") as? NSDictionary {
                print(json2)
                
                let follows = data.value(forKeyPath: "data.counts.follows") as? Int
                let followed_by = data.value(forKeyPath: "data.counts.followed_by") as? Int
                let mediaCount = data.value(forKeyPath: "data.counts.media") as? Int
                let fullname = data.value(forKey: "full_name") as? String
                let id = data.value(forKey: "id") as? String
                let username = data.value(forKey: "username") as? String
                let profilePic = data.value(forKey: "profile_picture") as? String
                
                let data = InstagramData(social_id: id, username: username, full_name: fullname, pictureUrl: profilePic, followed_by: followed_by, follows: follows, mediaCount: mediaCount)
                
                success(data)
            } else {
                failed()
                // Singleton.shared.showAlert(title: "Error", message: "Unable to connect to instagram server. Please try again.")
            }
                
        }
        
    }
    
    
    // ------------------------------------------------------------------------------------------
    
    /*
     MARK: Facebook Registration
     */
    
    func facebookLogin(_ from: UIViewController, success:@escaping()->(), loginUsingEmail:@escaping(_ email: String)->(), error:@escaping(AppError, _ status:Int)->()) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager.init()
        loginManager.logOut()

        FBSDKAccessToken.refreshCurrentAccessToken(nil)
        
        loginManager.logIn(withReadPermissions: FBPermissions, from: from, handler:
            { (result, err) -> Void in
            
            guard err == nil else { error(AppError.notFound, -1); return }
            guard !(result?.isCancelled)! else { error(AppError.operationCancelled, -1); return }
            
            DispatchQueue.main.async {
                Singleton.shared.showLoader(from)
            }
                
            self.getFaceBookDetails(success: { (response) in
                
                let apiname = backendUrl(folder: BackendFolder.users, action: BackendAction.socialLogin)
                let parameters: Parameters = ["social_id" :  response.social_id ?? "", "name" : response.name ?? "", "social_media" : SocialMediaPlatform.Facebook, "device_token" : "123", "email" : response.email_id ?? ""]
                
                func registerNow() {
                    WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
                        DispatchQueue.main.async {
                            Singleton.shared.hideLoader()
                        }
                    }, success: { (response) in
                        DispatchQueue.main.async {
                            guard let status = response.value(forKey: "status") as? String else {
                                error(AppError.invalidResponse, -1)
                                return
                            }
                            
                            guard status == "200" else {
                                if status == "404", let login_code = response.value(forKeyPath: "key.login_type") as? Int {
                                    error(AppError.userAlreadyRegistered,login_code)
                                } else {
                                    error(AppError.invalidResponse, -1)
                                }
                                return
                            }
                            
                            DataManager.shared.setProfileData(dictionary: response)
                            success()
                        }
                        
                    }) { (errorr) in error(AppError.unknownError, -1) }
                }
                
                registerNow()
          
            }, failure: { print("Error <--"); error(AppError.unknownError, -1) })
            
        })
        
    }
    
    func getFaceBookDetails( success: @escaping (FBData) -> (), failure: @escaping () -> ()) {
        
        if ((FBSDKAccessToken.current()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,birthday,gender,hometown"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if error == nil, let result = result as? NSDictionary {
                    
                    let data = FBData(social_id: result.value(forKey: "id") as? String,
                                      name: result.value(forKey: "name") as? String,
                                      email_id: result.value(forKey: "email") as? String,
                                      firstname: result.value(forKey: "first_name") as? String,
                                      lastname: result.value(forKey: "last_name") as? String,
                                      pictureUrl: result.value(forKeyPath: "picture.data.url") as? String)
                    
                    success(data)
                } else {
                    failure()
                }
                
            })
        } else {
            failure()
        }
        
    }
    
}



/*
 
 Alamofire.upload(multipartFormData: { multipartFormData in
 
 if let imageToUpload = response.picture, let imgData = UIImageJPEGRepresentation(imageToUpload, 0.2) {
 multipartFormData.append(imgData, withName: "profile_pic",fileName: "file.jpg", mimeType: "image/jpg")
 }
 
 for (key, value) in parameters {
 multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
 }
 
 }, to:apiname, method: .post, encodingCompletion:{ (result) in
 
 switch result {
 case .success(let upload, _, _):
 
 upload.responseJSON { response in
 print(response)
 if let json2 = response.result.value as? NSDictionary {
 if (json2.value(forKey: "status") as! String == "200" ) {
 DataManager.shared.setProfileData(dictionary: json2)
 success()
 }
 }
 }
 
 case .failure(let encodingError):
 if let err = encodingError as? URLError, err.code == .notConnectedToInternet {
 Singleton.shared.showAlert(title: "No internet available", message: "The Internet connection appears to be offline. Please try again.")
 } else {
 Singleton.shared.showAlert(title: "Alert", message: (encodingError.localizedDescription))
 
 }
 
 }
 
 })
 
 }, failure: { print("Error <--")}
*/
