//
//  NextWeekChallengesViewModel.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
<<<<<<< HEAD
import Alamofire
import SDWebImage

protocol NextWeekChallengesViewModelDelegate {
    func OpenUserProfile()
}

class NextWeekChallengesViewModel: NSObject {
  
    var delegate : NextWeekChallengesViewModelDelegate?
    var challengeModel:ChallengeModel?
    var suggetionModel:SuggestionsModel = SuggestionsModel()
    
    var refreshView:((ChallengeModel)->())?
    var reloadSuggetions:((SuggestionsModel)->())?
    
    private var suggestionsTableView:UITableView?
    private var userSuggestionsPageDic = NSDictionary()
    private var mySuggestionsPageDic = NSDictionary()
    private var showVideoPayer = false
    private var videoSuggestion: ChallengeSuggestion?
    
    //var filterApplied: FilterType?
    
    
    /**
     ------------------------------------------------------------------------------------------
     //MARK: Instance functions
     
    */
    
    func numberOfItems() -> Int {
        guard showVideoPayer else {
            return suggetionModel.challengeSuggestions.count
        }
        return 1
    }
    
    func deAllocate() {
        defer {
            /**
             If video is playing then remove video player from cell before popup the ViewController
            */
            
            if self.showVideoPayer {
                self.videoSuggestion?.videoUrl = nil
                self.suggestionsTableView?.reloadData()
            }
        }
    }
    
    /**
     ------------------------------------------------------------------------------------------
    //MARK: Table View Delegate
    
    */
    
    func cellForRow(at indexPath:IndexPath, tableView:UITableView) -> UITableViewCell {
        suggestionsTableView = tableView
        
        guard showVideoPayer else {
            
            let suggestion = suggetionModel.challengeSuggestions[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionsCell") as! SuggestionsCell
            
            cell.delegate = self
            cell.setUp()
            
            cell.lblSuggestion.text = suggestion.suggestion
            cell.lblRank.text = "\(suggestion.likes ?? 0)"
            cell.btnStar.isSelected = (suggestion.likedByMe)!
            
            if let imageUrl = URL(string:suggestion.profilePicUrl ?? "") {
                cell.profilePic.sd_setImage(with: imageUrl, placeholderImage: nil)
            }
            
            if let videoPathString = suggestion.videoUrl, let _ = URL(string: videoPathString) {
                cell.btnPlay.isUserInteractionEnabled = true
                cell.btnPlay.alpha = 1.0
            }
            
            return cell
        }
        
        let suggestion = videoSuggestion
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayVideoCellId", for: indexPath) as! PlayVideoCell
        
        cell.setup(thumbnail: nil)
        cell.delegate = self
        cell.lblUsername.text = suggestion?.suggestion
       
        if let imageUrl = URL(string:suggestion?.profilePicUrl ?? "") {
            cell.profilePic.sd_setImage(with: imageUrl, placeholderImage: nil)
        }
        
        if let videoPathString = suggestion?.videoUrl, let videoPath = URL(string: videoPathString){
            cell.setVideoLayerwith(videoPath)
        }
        
        return cell
    }
    
    func didSelectCell(at indexPath:IndexPath, tableView:UITableView) {
        
    }
    
    func tableScrollViewDidEndDecelerating(_ scrollView: UIScrollView, filter: String) {
        let bottomEdge: Float = Float(scrollView.contentOffset.y + scrollView.frame.size.height)
        if bottomEdge >= Float(scrollView.contentSize.height) && userSuggestionsPageDic.count > 0 {
            let currentPage: Int = (userSuggestionsPageDic.object(forKey: "currentpage") as! Int)
            if(currentPage < (userSuggestionsPageDic.object(forKey: "totalpages")as! Int)) {
                getChallengeSuggetions(filter: filter, page: "\(currentPage + 1)")
            }
            print("we are at end of table")
        }
    }
    
    
    /**
     ------------------------------------------------------------------------------------------
     //MARK: Get Data Methods
     
    */
    
    func getChallengeSuggetions(filter:String, page:String) {
        
        let apiname = backendUrl(folder: BackendFolder.challenge, action: BackendAction.challengeSuggestions)
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "","filter": filter , "page" : page]
        
        if page == "1" {
            Singleton.shared.showLoader()
        }
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            if page == "1" {
                Singleton.shared.hideLoader()
            }
        }, success: { (response) in
            print(response)
            
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                   let list = response.value(forKeyPath: "data.list") as! Array<NSDictionary>
                    self.suggetionModel.setChallengeSuggestions(challengeSuggestions: list, refresh: page == "1" ? true : false)
                    self.reloadSuggetions?(self.suggetionModel)
                    
                    self.userSuggestionsPageDic =  response.value(forKeyPath: "data.meta") as! NSDictionary
                    if self.userSuggestionsPageDic.count > 0 {
                        let currentPage: Int = (self.userSuggestionsPageDic.object(forKey: "currentpage") as! Int)
                        
                        if(currentPage < (self.userSuggestionsPageDic.object(forKey: "totalpages")as! Int)) {
                            // self.getAdvanceCampaigns( page: "\(self.pageArray.object(forKey: "page") as! Int)")
                        }
                    }
                }
            }
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
    }
    
    
    func getChallengeOfWeek() {
        
        let apiname = backendUrl(folder: BackendFolder.challenge, action: BackendAction.activeChallenge)
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "", "page" : "1"]
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            
        }, success: { (response) in
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    self.challengeModel = ChallengeModel(list: response.value(forKeyPath: "data.list") as! Array<NSDictionary>)
                    self.refreshView?(self.challengeModel!)
                }
            }
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
    }
    
    
    
    /**
     ------------------------------------------------------------------------------------------
     //MARK: Button Observers
     
    */
    
    func likeUnlikeSuggetion(sender:UIButton?, shouldLike:Bool, suggestionIndex:Int) {
       
        let apiname = backendUrl(folder: BackendFolder.challenge, action: BackendAction.likeUnlikeSuggestion)
        let suggestion = suggetionModel.challengeSuggestions[suggestionIndex]
        
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "", "status": shouldLike ? "1" : "2" , "suggestion_id" : (suggestion.id)!]
        
        WebServices.shared.response(parameters: parameters, apiname: apiname, firstResponse: {
            sender?.isUserInteractionEnabled = true
        }, success: { (response) in
            print(response)
            
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    
                    suggestion.likedByMe = shouldLike
                    if shouldLike {
                        suggestion.likes = (suggestion.likes)! + 1
                    } else {
                        suggestion.likes = (suggestion.likes)! - 1
                    }
                    
                    self.suggetionModel.challengeSuggestions.remove(at: suggestionIndex)
                    self.suggetionModel.challengeSuggestions.insert(suggestion, at: suggestionIndex)
                    self.reloadSuggetions?(self.suggetionModel)
                }
            }
            
        }) { (errorr) in
            print(errorr.localizedDescription)
        }
        
    }
    
    
    func submitSuggestion(video: URL?, suggestion:String, firstResponse: @escaping()->() ,success: @escaping()->()) {
        
        let apiname = backendUrl(folder: BackendFolder.challenge, action: BackendAction.addSuggestion)
        let parameters: Parameters = ["user_id": DataManager.shared.Me?.uid ?? "", "auth_token": DataManager.shared.Me?.auth_token ?? "", "suggestion" : suggestion]
        var imageData: Data?
        if let videoUrl = video {
            do{
                imageData =  try NSData(contentsOfFile: videoUrl.relativePath, options: NSData.ReadingOptions.alwaysMapped) as Data
            }
            catch{
                print("video crupted")
            }
        }
        
        Singleton.shared.showLoader()
        WebServices.shared.multipartResponse(parameters: parameters, apiname: apiname, multipartData: imageData, key: "video", filename: "suggestion.mp4", mimeType: AppMimeType.video, firstResponse: {
            firstResponse()
        }, success: { (response) in
            Singleton.shared.hideLoader()
            DispatchQueue.main.async {
                if response.value(forKey: "status") as! String == "200" {
                    success()
                }
            }
        }) { (errorr) in
            
        }
    }
    
}


extension NextWeekChallengesViewModel: SuggestionsCellDelegate, SuggestionsVideoCellDelegate {
    func playAction(sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.suggestionsTableView)
        if let indexPath = self.suggestionsTableView?.indexPathForRow(at: buttonPosition) {
            self.showVideoPayer = true
            self.videoSuggestion = suggetionModel.challengeSuggestions[indexPath.row]
            self.suggestionsTableView?.reloadData()
            self.suggestionsTableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self.suggestionsTableView?.bounces = false
        }
    }
    
    func OpenUserProfile() {
        delegate?.OpenUserProfile()
    }
    
    func likeUnlikeSuggetion(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.suggestionsTableView)
        if let indexPath = self.suggestionsTableView?.indexPathForRow(at: buttonPosition) {
            print(indexPath.row)
    
            self.likeUnlikeSuggetion(sender: sender,shouldLike: sender.isSelected, suggestionIndex: indexPath.row)
        }
    }
    
    func openActionSheet(sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.suggestionsTableView)
        if let indexPath = self.suggestionsTableView?.indexPathForRow(at: buttonPosition) {
           
            let suggestion = suggetionModel.challengeSuggestions[indexPath.row]
            let sheetType = suggestion.userId == DataManager.shared.Me?.uid ? SheetType.mySuggestion : SheetType.userSuggestion
            let dic = ["suggestion_id": suggestion.id ?? "", "followed_user_id": suggestion.userId ?? "", "followedByMe": suggestion.followByMe ?? false] as [String : Any]
            
            Singleton.shared.openActionSheet(sheetType, Info: dic) { (handler) in
                
                guard handler.selectedAction != actionSheetAction.report else {
                    self.suggetionModel.challengeSuggestions.remove(at: indexPath.row)
                    self.suggestionsTableView?.reloadData()
                    return
                }
                
                guard handler.selectedAction != actionSheetAction.delete else {
                    self.suggetionModel.challengeSuggestions = (self.suggetionModel.challengeSuggestions.filter({$0.id != suggestion.id}))
                    self.suggestionsTableView?.reloadData()
                    return
                }
                
                if handler.selectedAction == actionSheetAction.follow {
                    suggestion.followByMe = true
                } else if handler.selectedAction == actionSheetAction.unfollow {
                    suggestion.followByMe = false
                }
                
                self.suggetionModel.challengeSuggestions.remove(at: indexPath.row)
                self.suggetionModel.challengeSuggestions.insert(suggestion, at: indexPath.row)
                self.suggestionsTableView?.reloadData()
            }
            
        }
        
    }
}


extension NextWeekChallengesViewModel: PlayVideoCellDelegate {
    func playerWillRemove() {
        self.showVideoPayer = false
        self.suggestionsTableView?.reloadData()
        self.suggestionsTableView?.bounces = true
    }
    
}



/* func getAdvanceCampaigns( page: String) {
 var parameterP = Parameters()
 var urlString : String
 
 Alamofire.request(Constants.baseUrl + urlString, method: .post, parameters: parameterP, encoding:JSONEncoding.default)
 .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
 print("Progress: \(progress.fractionCompleted)")
 }
 .validate { request, response, data in
 return .success
 }
 .responseString(completionHandler: { (response) in
 print(response)
 })
 
 .responseJSON { response in
 debugPrint(response)
 
 if let json = response.result.value as? NSDictionary {
 if(json.value(forKey: "status") as! String == "200") {
 self.advanceDataArray = NSMutableArray(array: json.value(forKey: "data") as! NSArray)
 }
 }
 }
 } */

=======

class NextWeekChallengesViewModel: NSObject {
    
    func numberOfItems() -> Int {
        return 4
    }
    
    func cellForRow(at indexPath:IndexPath, tableView:UITableView) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell") as! PostsCell
        return cell
    }
    
    func didSelectCell(at indexPath:IndexPath, tableView:UITableView)
    {
        
    }
}
>>>>>>> origin/master
