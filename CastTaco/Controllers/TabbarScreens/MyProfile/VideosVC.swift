//
//  MyVideosVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 09/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

import BetterSegmentedControl

class VideosVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var novideo = true
    var userId : String?
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserInterface()
        tableView.register(UINib(nibName: "MyVideoCell", bundle: nil), forCellReuseIdentifier: "myVideoCell")
        
        let nib = UINib(nibName: "PostsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "postCellId")
        
        let nib2 = UINib(nibName: "SegmentHeaderView", bundle: nil)
        tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "SegmentHeaderView")
    }

    func setUserInterface() {
        if novideo {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        }
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            novideo = true
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            novideo = false
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        }
        
        print("index changed")
        
        tableView.reloadData()
        tableView.setNeedsLayout()
    }
   
    
    override func viewDidLayoutSubviews() {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension VideosVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return novideo ? 1 : 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SegmentHeaderView") as! SegmentHeaderView
        
        if let segment = header.segment {
                        segment.options = [.cornerRadius(17.0),
                                           .backgroundColor(UIColor(red:0.16, green:0.64, blue:0.94, alpha:1.00)),
                                           .indicatorViewBackgroundColor(.white)]
                        segment.segments = LabelSegment.segments(withTitles: ["This week","Top film"], normalBackgroundColor: UIColor.groupTableViewBackground, normalFont: UIFont(name: AppFont.medium, size: 14), normalTextColor: UIColor.lightGray, selectedBackgroundColor: UIColor.white, selectedFont: UIFont(name: AppFont.medium, size: 14), selectedTextColor: AppColors.GrayText)
                        segment.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
            }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.red
        view.backgroundColor = UIColor.green
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard userId == "Mine" else {
            
            guard !novideo else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoVideoOfOtherUserCell", for: indexPath)
                let textLbl = cell.viewWithTag(100) as! UILabel
                
                let firstname = selectedUser?.username?.split(separator: " ")[0]
                textLbl.text = "\(firstname ?? "User") has not uploaded  a video this week"
                
                return cell
            }
            

//            let cell = tableView.dequeueReusableCell(withIdentifier: "postCellId") as! PostsCell
//            self.tableView = tableView
//            cell.setUp()
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "myVideoCell", for: indexPath) as! MyVideosCell
            cell.delegate = self
            
            return cell
        }
        
       
        guard !novideo else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoVideoCell", for: indexPath)
            
            if let bottomView = cell.viewWithTag(100) {
                let bounds = UIScreen.main.bounds
                let height =  bottomView.constraints.filter({$0.identifier == "HeightConstant"})
                
                if bounds.height >= 812 {
                    height[0].constant = 300
                } else if bounds.height >= 736 {
                    height[0].constant = 211/375 * bounds.width + 22
                } else {
                    height[0].constant = 211/375 * bounds.width + 2
                }
                
                //height[0].constant = bounds.height >= 812 ? 300 : 211/375 * bounds.width
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myVideoCell", for: indexPath) as! MyVideosCell
        cell.delegate = self
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
}

extension VideosVC : MyVideosCellDelegate {
    func threeDotAction() {
        if userId != "Mine" {
            Singleton.shared.openActionSheet(SheetType.userPost, Info: nil) { (action) in
                
            }
        } else {
            Singleton.shared.sharePost()
        }
    }
    
}

