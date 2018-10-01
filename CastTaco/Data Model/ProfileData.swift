//
//  ProfileData.swift
//  AGDragDropTableViewCell
//
//  Created by Aman Gupta on 02/01/18.
//  Copyright © 2018 Developer Fly. All rights reserved.
//

import UIKit

class ProfileData: NSObject {
    
}

class User: NSObject, NSCoding {
    var username:String?
    var image: UIImage?
    var avatarUrl: String?
    var firstName:String?
    var lastName:String?
    var uid : String?
    var auth_token: String?
    var email: String?
    
    init(uid:String, username:String, image: UIImage?, avatarUrl: String?, auth_token:String?, email:String? = "", firstName:String?, lastName: String?) {
        self.image = image
        self.uid = uid
        self.email = email
        self.auth_token = auth_token
        self.avatarUrl = avatarUrl
        self.firstName = firstName
        self.lastName = lastName
         
        if username.trimmingCharacters(in: .whitespacesAndNewlines) == "" || username.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.username = (self.firstName ?? "") + " " + (self.lastName ?? "")
        } else {
            self.username = username
        }
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let image = aDecoder.decodeObject(forKey: "image") as? UIImage
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let uid = aDecoder.decodeObject(forKey: "uid") as! String
        let auth_token = aDecoder.decodeObject(forKey: "auth_token") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        
        self.init(uid: uid , username: name, image: image, avatarUrl: avatarUrl, auth_token: auth_token, email: email, firstName: firstName, lastName: lastName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "image")
        aCoder.encode(username, forKey: "name")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(auth_token, forKey: "auth_token")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(avatarUrl, forKey: "avatarUrl")
       
    }
    
    
}


enum BetType {
    case BestPicture
    case Comedy
    case Sound
    case Costume
}

class UserOnBet {
    var user: User?
    var rank: Int?
    
    init(rank:Int?, user:User?) {
        self.user = user
        self.rank = rank
    }
}

class Bet {
    var category: BetType?
    var bettedUser:UserOnBet?
    
    init(category:BetType?, userinfo: UserOnBet?) {
        self.category = category
        self.bettedUser = userinfo
    }
    
}


// Mark: Categories

class BestMotionPicture : Emoticon {
    init() {
        super.init(name: "Best Motion Picture", image: #imageLiteral(resourceName: "bestmotion"), tag: 1)
    }
    
}

class BestComedy : Emoticon {
    init() {
        super.init(name: "Best Comedy", image: #imageLiteral(resourceName: "comedy"), tag: 4)
    }
    
}

class BestSound : Emoticon {
    init() {
        super.init(name: "Best Sound", image: #imageLiteral(resourceName: "sound"), tag: 3)
    }
}

class BestCostume : Emoticon {
    init() {
        super.init(name: "Best Costume", image: #imageLiteral(resourceName: "costume"), tag: 2)
    }
}
