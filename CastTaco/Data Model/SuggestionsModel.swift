//
//  SuggestionsModel.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 05/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class SuggestionsModel: NSObject {

    var challengeSuggestions:Array<ChallengeSuggestion> = [ChallengeSuggestion]()
    var mySuggestions:Array<ChallengeSuggestion> = [ChallengeSuggestion]()
    
    override init() {
        super.init()
        
    }
    
    func setChallengeSuggestions(challengeSuggestions:Array<NSDictionary>, refresh:Bool) {
        if refresh {
            self.challengeSuggestions.removeAll()
        }
        
        for object in challengeSuggestions {
            let newObject = setSuggestion(object: object)
            self.challengeSuggestions.append(newObject)
        }
    }
    
    func setMySuggestions(suggestions:Array<NSDictionary>, refresh:Bool) {
        if refresh {
            self.mySuggestions.removeAll()
        }
        
        for object in suggestions {
            let newObject = setSuggestion(object: object)
            self.mySuggestions.append(newObject)
        }
    }
    
    
    private func setSuggestion(object: NSDictionary) -> ChallengeSuggestion {
        let challenge = ChallengeSuggestion(id: object.value(forKey: "id") as? String,
                                            userId: object.value(forKey: "user_id") as? String,
                                            suggestion: object.value(forKey: "suggestion") as? String,
                                            firstname: object.value(forKey: "first_name") as? String,
                                            lastname: object.value(forKey: "last_name") as? String,
                                            profilePicUrl: object.value(forKey: "profile_picture") as? String,
                                            videoUrl: object.value(forKey: "video") as? String,
                                            likes: Int(object.value(forKey: "total_likes") as? String ?? "0"),
                                            likedByMe: (object.value(forKey: "loggedin_user_likestatus") as? Int) == 1 ? true : false,
                                            followByMe: (object.value(forKey: "follow") as? Int) == 1 ? true : false   )
        return challenge
    }
    
}

class ChallengeSuggestion {
    
    var id: String?
    var userId: String?
    var suggestion: String?
    var firstname: String?
    var lastname: String?
    var profilePicUrl: String?
    var videoUrl: String?
    var likes: Int?
    var likedByMe: Bool?
    var followByMe: Bool!
    
    init(id: String?, userId: String?, suggestion: String?, firstname: String?, lastname: String?, profilePicUrl: String?, videoUrl: String?, likes: Int?, likedByMe: Bool? = false, followByMe: Bool? = false) {
        
        self.id = id
        self.userId = userId
        self.suggestion = suggestion
        self.firstname = firstname
        self.profilePicUrl = profilePicUrl
        self.videoUrl = videoUrl
        self.likes = likes
        self.likedByMe = likedByMe
        self.followByMe = followByMe
    }
    
    /*
     "id": "4",
     "user_id": "4",
     "suggestion": "We can improve this challenge",
     "created_at": "1532513524",
     "updated_at": "1532513524",
     "first_name": "Ravi",
     "last_name": "Kumar ee",
     "profile_picture": "http://beta.brstdev.com/videsharingapp/uploads/profile_pics/4_pimg_1532533526.jpeg",
     "total_likes": "0",
     "video": "http://beta.brstdev.com/videsharingapp/uploads/challenge-suggestion-videos/5_sugg_video_1534411690.mp4"
    
    */
}
