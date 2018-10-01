//
//  ChallengeModel.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 05/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class ChallengeModel: NSObject {
    
    var challengesList:Array<Challenge> = [Challenge]()
    var thisWeekChallenge:Challenge? {
        if challengesList.count > 0 {
            return challengesList[0]
        }
        return nil
    }    
    
    init(list:Array<NSDictionary>) {
        super.init()
        
        challengesList.removeAll()
        for object in list {
            challengesList.append(setChallenge(dictionary: object))
        }
        
    }
    
    private func setChallenge(dictionary: NSDictionary) -> Challenge {
        let challenge = Challenge(id: dictionary.value(forKey: "id") as? String,
                                           title: dictionary.value(forKey: "title") as? String,
                                           description: dictionary.value(forKey: "description") as? String,
                                           status: dictionary.value(forKey: "status") as? String)
        return challenge
    }
}


class Challenge {
    
    var id : String?
    var title : String?
    var description : String?
    var status : String?
    
    init(id: String?, title: String?, description: String?, status: String?) {
        
        self.id = id
        self.title = title
        self.description = description
        self.status = status
    }
    
    /*
     "allowed_smilies" = 1;
     "created_at" = 1535960800;
     description = "Run with car";
     "eleven_points" = 25;
     "expiry_date" = 1536585360;
     "fifty_points" = 35;
     "first_points" = 10;
     "fourth_points" = 15;
     id = 11;
     image = "http://beta.brstdev.com/videsharingapp/uploads/challenge_pics/5b8ce6a082bd9.jpg";
     "media_type" = 0;
     "second_points" = 20;
     "start_date" = 1535980500;
     status = 1;
     "submits_count" = 0;
     "third_points" = 30;
     title = kiki;
     "updated_at" = 1535960800;
 
    */
    
}





