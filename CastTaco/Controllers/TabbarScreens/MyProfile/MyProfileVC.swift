//
//  MyProfileVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
  
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var pageMenu : CAPSPageMenu?
    var pageMenuMargin: CGFloat {
        if UIScreen.main.bounds.width >= 414 {
            return 35.0
        } else if UIScreen.main.bounds.width >= 375 {
            return 26.0
        } else {
            return 16.0
        }
    }

    @IBOutlet weak var sliderView: UIView!
    private var selectionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(addViewController), name:
            NSNotification.Name.init("addViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViewConroller(value:)), name: NSNotification.Name.init("refreshViewController"), object: nil)
        
        if let imageUrl = DataManager.shared.Me?.avatarUrl {
            profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "sample-user"))
        } else {
            profileImage.image = #imageLiteral(resourceName: "sample-user")
        }
        
        lblName.text = DataManager.shared.Me?.username
        addPageMenu()
        
    }
    
    //MARK:- Notification Observer
    
    @objc func refreshViewConroller(value: NSNotification) {
        
        guard let userInfo = value.value(forKey: "userInfo") as? NSDictionary,
            let navigation = userInfo.value(forKey: "viewController") as? UINavigationController,
            navigation.viewControllers[0].isKind(of: MyProfileVC.self) else {
                return
        }
       
        (self.tabBarController as? TabbarVC)?.popUserProfile(4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = AppColors.TacoPurple
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func addViewController(value : NSNotification) {
        
        let dic = value.object as! Dictionary<String, Any>
        
        if dic["type"] as! String == "Present",
            let vc = dic["ViewController"] as? UIViewController {
            if let viewcontroller = vc as? StatsCompare_FriendVC {
                viewcontroller.delegate = self
                self.present(viewcontroller, animated: true, completion: nil)
            } else {
                self.present(vc, animated: true, completion: nil)
            }
        } else if dic["type"] as! String == "Push" ,
            let vc = dic["ViewController"] as? UIViewController  {
            if let viewcontroller = vc as? StatsCompare_FriendVC {
                viewcontroller.delegate = self
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if pageMenu == nil {
            
        }

//        pageMenu?.view.setNeedsLayout()
//        pageMenu?.view.layoutSubviews()
//        pageMenu?.view.layoutIfNeeded()
//
//        pageMenu?.controllerScrollView.layoutSubviews()
//        pageMenu?.controllerScrollView.setNeedsLayout()
//        pageMenu?.controllerScrollView.layoutIfNeeded()
        
        print(pageMenu?.view.frame)
        pageMenu?.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func addPageMenu() {
        
        var controllerArray : [UIViewController] = []
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosVCId") as! VideosVC
        controller.userId = "Mine"
        controller.title = "Videos"
        controllerArray.append(controller)
        
        let controller1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveStatsVCId") as! LiveStatsVC
        controller1.title = "Live stats"
        controllerArray.append(controller1)
        
        let controller2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SocialStatusVCId") as! SocialStatusVC
        
        controller2.title = "Social status"
        controllerArray.append(controller2)
        
        let controller3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsVCId") as! FriendsVC
        
        controller3.title = "Friends"
        controller3.isMyFriends = true
        controller3.delegate = self
        controllerArray.append(controller3)
        
        
        var bottomMenuMargin = UIScreen.main.bounds.width >= 414 ? 14 : 10
        if UIScreen.main.bounds.height >= 812 {
            bottomMenuMargin = 14
        }
        
        let parameters: [CAPSPageMenuOption] = [CAPSPageMenuOption.centerMenuItems(true),
                                                //                                                    CAPSPageMenuOption.menuItemWidth(self.view.frame.size.width/5),
            CAPSPageMenuOption.menuHeight(UIScreen.main.bounds.height > 668 ? 52 : 46),
            CAPSPageMenuOption.menuItemFont(UIFont(name: AppFont.bold, size: 14)!),
            CAPSPageMenuOption.scrollMenuBackgroundColor(AppColors.LightBlue),
            CAPSPageMenuOption.selectionIndicatorColor(AppColors.TacoPurple),
            CAPSPageMenuOption.selectionIndicatorHeight(2),
            CAPSPageMenuOption.bottomMenuHairlineColor(AppColors.LightBlue),
            CAPSPageMenuOption.selectedMenuItemLabelColor(AppColors.TacoPurple),
            CAPSPageMenuOption.titleTextSizeBasedOnMenuItemWidth(true),
            CAPSPageMenuOption.selectionIndicatorBottomMargin(CGFloat(bottomMenuMargin)),
            CAPSPageMenuOption.menuItemWidthBasedOnTitleTextWidth(true),
            CAPSPageMenuOption.menuMargin(pageMenuMargin),
            CAPSPageMenuOption.unselectedMenuItemLabelColor(UIColor(red: 81/255, green: 53/255, blue: 205/255, alpha: 0.5)),
            
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:0.0, width:self.sliderView.frame.width, height:self.sliderView.frame.height), pageMenuOptions: parameters)
        pageMenu?.configuration.scrollAnimationDurationOnMenuItemTap = Int(0.0)
        pageMenu?.viewDidLayoutSubviews()
        self.sliderView.addSubview(pageMenu!.view)
    }

    
    @IBAction func settingAction(_ sender: UIButton) {
    
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
         
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
            UIApplication.shared.keyWindow?.rootViewController = vc
         
            DataManager.shared.Me = nil
        }
         
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
         
        }
         
        controller.addAction(action1)
        controller.addAction(action2)
        
        Singleton.shared.topViewController()?.present(controller, animated: true, completion: nil)
        
    }
    
    
}

extension MyProfileVC : StatsCompare_FriendVCDelegate, FriendsVCDelegate {
    func showUserProfile(_ user: User?) {
        (self.tabBarController as? TabbarVC)?.pushUserProfile(self, tabbarIndex: 4, selectedUser: User5)
    }
    
    func compare(name: String, uid: String) {
        selectionIndex = 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "compareStats"), object: nil)
    }
    
}
