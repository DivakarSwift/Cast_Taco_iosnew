//
//  MySocialStatusVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 09/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class SocialStatusVC: UIViewController {

    @IBOutlet weak var screenBottomconst: NSLayoutConstraint!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var segment: BetterSegmentedControl!
    @IBOutlet weak var ratingTopConstant: NSLayoutConstraint!
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment.options = [.cornerRadius(17.0),
                           .backgroundColor(UIColor(red:0.16, green:0.64, blue:0.94, alpha:1.00)),
                           .indicatorViewBackgroundColor(.white)]
        segment.segments = LabelSegment.segments(withTitles: ["Acting status","Casting status"], normalBackgroundColor: UIColor.groupTableViewBackground, normalFont: UIFont(name: AppFont.medium, size: 14), normalTextColor: UIColor.lightGray, selectedBackgroundColor: UIColor.white, selectedFont: UIFont(name: AppFont.medium, size: 14), selectedTextColor: AppColors.GrayText)
       
        var myId = true
        if userId == "OtherUser" {
            ratingTopConstant.constant = 28
            myId = false
        }
        
        //let screenHeight = self.view.frame.size.height
        if UIScreen.main.bounds.size.height == 812 {
            //screenBottomconst.constant = screenBottomconst.constant + CGFloat(736 - screenHeight)/2.5 + (myId ? 67 : 25)
            screenBottomconst.constant = myId ? 98 : 80

        } else if UIScreen.main.bounds.size.height >= 736 {
            //screenBottomconst.constant = screenBottomconst.constant + CGFloat(736 - screenHeight)/2.5 - (myId ? 12 : 58)
            screenBottomconst.constant = myId ? 38 : 10
            
        } else if UIScreen.main.bounds.size.height >= 667 {
            //screenBottomconst.constant = screenBottomconst.constant + CGFloat(736 - screenHeight)/2.5 - (myId ? 47 : 87)
            screenBottomconst.constant = myId ? 15 : 0
            
        } else {
            //screenBottomconst.constant = screenBottomconst.constant + CGFloat(736 - screenHeight)/2.5 - (myId ? 110 : 125)
            screenBottomconst.constant = myId ? -8 : -8
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentValueChanged(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 {
            statusImageView.image = UIImage.init(named: "ActingStatus.jpg")
        } else {
            statusImageView.image = UIImage.init(named: "CastingStatus.jpg")
        }
        
    }
  

}
