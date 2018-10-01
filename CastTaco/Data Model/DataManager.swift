//
//  DataManager.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 07/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    static var shared:DataManager = {
        return DataManager()
    }()
    
//    var userID:String? {
//        set(newValue) {
//            UserDefaults.standard.setValue(newValue, forKey: "userId")
//            UserDefaults.standard.synchronize()
//        }
//        get {
//            return UserDefaults.standard.string(forKey: "userId") ?? nil
//        }
//    }
    
    var Me : User? {
        set(newValue) {
            if newValue == nil {
                 UserDefaults.standard.setValue(nil, forKey: "myProfileData")
            } else {
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                UserDefaults.standard.setValue(encodedData, forKey: "myProfileData")
            }
            
            UserDefaults.standard.synchronize()
        }
        get {
            if let decoded  = UserDefaults.standard.object(forKey: "myProfileData") as? Data {
                let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User
                return decodedTeams
            }
            return nil
        }
    }
    
    
    func setProfileData(dictionary:NSDictionary) {
        let id = dictionary.value(forKeyPath: "data.id") as? NSNumber
        let email = dictionary.value(forKeyPath: "data.email") as? String
        let auth_token = dictionary.value(forKeyPath: "data.auth_token") as? String
        let username = dictionary.value(forKeyPath: "data.username") as? String
        let avtarUrlString = dictionary.value(forKeyPath: "data.profile_picture") as? String
        let firstname = dictionary.value(forKeyPath: "data.first_name") as? String
        let lastname = dictionary.value(forKeyPath: "data.last_name") as? String
        
        Me = User(uid: "\(id ?? 0)", username: username ?? "", image: #imageLiteral(resourceName: "userPic.png"), avatarUrl: avtarUrlString, auth_token: auth_token, email: email, firstName: firstname, lastName: lastname)
    }
    
    
}
