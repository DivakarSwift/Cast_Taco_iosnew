//
//  OtherProfileVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    var pageMenu : CAPSPageMenu?
    var pageMenuMargin: CGFloat {
        if UIScreen.main.bounds.width >= 414 {
            return 58.0
        } else if UIScreen.main.bounds.width >= 375 {
            return 48.0
        } else {
            return 32.0
        }
    }

    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var previousIndex:Int?
    var selectedUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userProfilePic.image = selectedUser?.image
        lblUserName.text = selectedUser?.username
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViewConroller(value:)), name: NSNotification.Name.init("refreshViewController"), object: nil)
        
        addPageMenu()
    }
    
    @objc func refreshViewConroller(value: NSNotification) {
        
        guard let userInfo = value.value(forKey: "userInfo") as? NSDictionary,
            let navigation = userInfo.value(forKey: "viewController") as? UINavigationController,
            navigation.viewControllers[0].isKind(of: UserProfileVC.self) else {
                return
        }
        
        (self.tabBarController as? TabbarVC)?.popUserProfile(4)
    }

    @IBAction func backPress(_ sender: UIButton) {
        (self.tabBarController as? TabbarVC)?.popUserProfile(previousIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        pageMenu?.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBAction func followAction(_ sender: Any) {
        btnFollow.isSelected = !btnFollow.isSelected
        if btnFollow.isSelected {
            btnFollow.backgroundColor = UIColor.white
        } else {
            btnFollow.backgroundColor = AppColors.JuanPurpleTint
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func addPageMenu() {
        
        var controllerArray : [UIViewController] = []
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosVCId") as! VideosVC
        vc.userId = "OtherUser"
        vc.selectedUser = selectedUser
        let controller  = vc
        controller.title = "Videos"
        controllerArray.append(controller)
        
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SocialStatusVCId") as! SocialStatusVC
        vc2.userId = "OtherUser"
        let controller2 = vc2
        controller2.title = "Social status"
        controllerArray.append(controller2)
        
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsVCId") as! FriendsVC
        
        let controller3 = vc3
        controller3.isMyFriends = false
        controller3.title = "Friends"
        controllerArray.append(controller3)
        
        var bottomMenuMargin = UIScreen.main.bounds.width >= 414 ? 14 : 10
        if UIScreen.main.bounds.height >= 812 {
            bottomMenuMargin = 14
        }
        
        let parameters: [CAPSPageMenuOption] = [CAPSPageMenuOption.centerMenuItems(true),
                                                CAPSPageMenuOption.menuHeight(UIScreen.main.bounds.height > 668 ? 52 : 46),
                                                CAPSPageMenuOption.menuItemFont(UIFont(name: AppFont.bold, size: 14)!),
                                                CAPSPageMenuOption.scrollMenuBackgroundColor(AppColors.LightBlue),
                                                CAPSPageMenuOption.selectionIndicatorColor(AppColors.TacoPurple),
                                                CAPSPageMenuOption.selectionIndicatorHeight(2),
                                                // CAPSPageMenuOption.menuItemWidth(UIScreen.main.bounds.width/3),
            CAPSPageMenuOption.bottomMenuHairlineColor(AppColors.LightBlue),
            CAPSPageMenuOption.selectedMenuItemLabelColor(AppColors.TacoPurple),
            CAPSPageMenuOption.titleTextSizeBasedOnMenuItemWidth(true),
            CAPSPageMenuOption.menuItemWidthBasedOnTitleTextWidth(true),
            CAPSPageMenuOption.menuMargin(self.pageMenuMargin),
            
            CAPSPageMenuOption.selectionIndicatorBottomMargin(CGFloat(bottomMenuMargin)),
            CAPSPageMenuOption.unselectedMenuItemLabelColor(UIColor(red: 81/255, green: 53/255, blue: 205/255, alpha: 0.5))
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:0.0, width:sliderView.frame.width, height:sliderView.frame.height), pageMenuOptions: parameters)
        pageMenu?.configuration.scrollAnimationDurationOnMenuItemTap = Int(0.0)
        self.sliderView.addSubview(pageMenu!.view)
        
    }
    
}
