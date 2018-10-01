//
//  AppConstants.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 07/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class AppConstants {

}

var SortTypes = ["Random", "Release date", "Friends", "Previously casted"]
var RankBy = ["Top suggestions", "Friend's suggestions", "My suggestions"]
var FBPermissions = ["email","user_posts","public_profile","user_about_me","user_birthday","user_location"]

var AppCategories = [BestCostume(), BestSound(), BestComedy()]
var RankingCategories = [BestMotionPicture(), BestSound(), BestComedy(), BestCostume()]
var selectedCategories = Array<Emoticon>()
var usersOnBet = [Bet]()

private let appBaseUrl:String = "http://beta.brstdev.com/videsharingapp/api/web/index.php/v1"

struct BackendFolder {
   static let users = "users"
   static let challenge = "challenges"
}

struct BackendAction {
    static let socialLogin = "sociallogin"
    static let emailLogin = "emaillogin"
    static let emailVerification = "emailverification"
    static let registerUserWithEmail = "registration"
    static let registerUserWithPhone = "phone-registration"
    static let phoneLogin = "phonelogin"
    static let phoneVerification = "phoneverification"
    static let activeChallenge = "listactivechallenges"
    static let challengeSuggestions = "listchallengesuggestion"
    static let mySuggestions = "getown-suggestion"
    static let likeUnlikeSuggestion = "likeunlikechallengesuggesion"
    static let reportSuggestion = "report-suggestion"
    static let addSuggestion = "addchallengesuggestion"
    static let deleteMySuggestion = "deletesuggestion"
    static let followUnfollowUser = "followunfollowuser"
    
}

func backendUrl(folder:String, action:String) -> String {
    return appBaseUrl + "/\(folder)/\(action)"
}

struct INSTAGRAM_API {
    static let APIURl  = "https://api.instagram.com/v1/users/"
    static let AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let CLIENT_ID = "3be7b20b67244c58be4d2441e6181afa"
    static let CLIENTSERCRET = "3c10bf8027574319ab9617d5b0e1fe5f"
    static let REDIRECT_URI = "http://casttacocallback.com/"
    static let ACCESS_TOKEN = "access_token"
    static let SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/   follower_list+ */
}


struct AppColors {
    static var JuanPurple:UIColor = UIColor.init(hexString:"#7094FC")
   // static var TacoPurple:UIColor = UIColor.init(hexString:"#4545CE")
    static var TacoPurple:UIColor = UIColor(red: 69/255, green: 69/255, blue: 206/255, alpha: 1)
    static var MrTacoBlue:UIColor = UIColor.init(hexString:"#5DC6F6")
    static var LightBlue:UIColor = UIColor.init(hexString:"#F3F6FC")
    static var GrayText:UIColor = UIColor.init(hexString:"#555353")
    
    static var JuanPurpleTint:UIColor = UIColor.init(hexString:"#88A7FF")
    static var Green:UIColor = UIColor.init(hexString:"#1CC8CE")
    static var SunnyYellow:UIColor = UIColor.init(hexString:"#FCCE3A")
    static var Red:UIColor = UIColor.init(hexString:"#FA3253")
    static var Violet:UIColor = UIColor.init(hexString:"#BE7DE8")
    
    static var GrayTint1:UIColor = UIColor.init(hexString:"#676A72")
    static var GrayTint2:UIColor = UIColor.init(hexString:"#A8ABB3")
    static var GrayTint3:UIColor = UIColor.init(hexString:"#E1E2E3")
    
}

let User1 = User(uid: "1", username: "Cathal Cully", image: #imageLiteral(resourceName: "img_6.png"), avatarUrl: "", auth_token: "", email: "", firstName: "Cathal", lastName: "Cully")
let User2 = User(uid: "2", username: "Neil Brogan", image: #imageLiteral(resourceName: "img_1.png"), avatarUrl: "", auth_token: "", email: "", firstName: "Neil", lastName: "Brogan")
let User3 = User(uid: "3", username: "Mr Parker", image: #imageLiteral(resourceName: "img_4.png"), avatarUrl: "", auth_token: "", email: "", firstName: "Mr", lastName: "Parker")
let User4 = User(uid: "4", username: "John Andrew", image: #imageLiteral(resourceName: "downloadUser.jpeg"), avatarUrl: "", auth_token: "", email: "", firstName: "John", lastName: "Andrew")
let User5 = User(uid: "5", username: "Mark Benjamin", image: #imageLiteral(resourceName: "img_5.png"), avatarUrl: "", auth_token: "", email: "", firstName: "Mark", lastName: "Benjamin")

//let User1 : User = User(uid: "1", name: "Cathal Cully", image: #imageLiteral(resourceName: "img_6.png"))
//let User2 : User = User(uid: "2", name: "Neil Brogan", image: #imageLiteral(resourceName: "img_1.png"))
//let User3 : User = User(uid: "3", name: "Mr Parker", image: #imageLiteral(resourceName: "img_4.png"))
//let User4 : User = User(uid: "4", name: "John Andrew", image: #imageLiteral(resourceName: "download.jpeg"))
//let User5 : User = User(uid: "5", name: "Mark Benjamin", image: #imageLiteral(resourceName: "img_5.png"))
//var Me : User = User(uid: "6", name: "Tom Cruise", image: #imageLiteral(resourceName: "userPic.png"), auth_token:"123")

struct AppFont {
    static let regular: String = "TTNorms-Regular"
    static let medium: String = "TTNorms-Medium"
    static let blackItalic: String = "TTNorms-BlackItalic"
    static let bold: String = "TTNorms-Bold"
    static let extraBold: String = "TTNorms-ExtraBold"
    static let black: String = "TTNorms-Black"
    static let extraLight: String = "TTNorms-ExtraLight"
    static let italic: String = "TTNorms-Italic"
    static let mediumItalic: String = "TTNorms-MediumItalic"
    static let lightItalic: String = "TTNorms-LightItalic"
    static let extraLightItalic: String = "TTNorms-ExtraLightItalic"
    static let thinItalic: String = "TTNorms-ThinItalic"
    static let extraBoldItalic: String = "TTNorms-ExtraBoldItalic"
    static let thin: String = "TTNorms-Thin"
    static let heavyItalic: String = "TTNorms-HeavyItalic"
    static let heavy: String = "TTNorms-Heavy"
    static let boldItalic: String = "TTNorms-BoldItalic"
    static let light: String = "TTNorms-Light"
}
