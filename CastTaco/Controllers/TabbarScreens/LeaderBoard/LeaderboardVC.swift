//
//  LeaderboardVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
//
//@objc public protocol CAPSPageLeaderDelegate : class {
//    // MARK: - Delegate functions
//    @objc optional func willMoveToPage(_ controller: UIViewController, index: Int)
//    @objc optional func didMoveToPage(_ controller: UIViewController, index: Int)
//}

class LeaderboardVC: UIViewController {
    
    @IBOutlet weak var btnBackArrow: UIButton!
    @IBOutlet weak var sliderView: UIView!
    
    private var preSelectedUser: User?
    private var preIsVideoSelected: Bool = false
    
    var pageMenuMargin: CGFloat {
        if UIScreen.main.bounds.width >= 414 {
            return 35.0
        } else if UIScreen.main.bounds.width >= 375 {
            return 26.0
        } else {
            return 16.0
        }
    }

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBackArrow.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViewConroller(value:)), name: NSNotification.Name.init("refreshViewController"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(containerViewDidAppear(notification:)), name:Notification.Name(rawValue: "containerViewDidAppear"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if pageMenu == nil {
            self.addviewcontrollerForSwip()
        }
        
        pageMenu?.viewDidLayoutSubviews()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        
        let dic = ["openVideoPlay": preIsVideoSelected, "selectedUser": preSelectedUser as Any] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rightScrollNotify"), object: dic)
        btnBackArrow.isHidden = true
    }
    
    
    @objc func containerViewDidAppear(notification:NSNotification){
        btnBackArrow.isHidden = false
    }
    
    //MARK:- Notification Observer
    
    @objc func refreshViewConroller(value: NSNotification){
        
        guard let userInfo = value.value(forKey: "userInfo") as? NSDictionary,
            let navigation = userInfo.value(forKey: "viewController") as? UINavigationController,
            navigation.viewControllers[0] == self else {
                return
        }
        
        if pageMenu == nil {
            self.addviewcontrollerForSwip()
            NotificationCenter.default.addObserver(self, selector: #selector(containerViewDidAppear(notification:)), name:Notification.Name(rawValue: "containerViewDidAppear"), object: nil)
        } else {
            
            let dic = ["index" : 0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLeaderBoardSegments"), object: nil, userInfo: dic)
            
            pageMenu?.moveToPage(0)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        pageMenu?.viewDidLayoutSubviews()
    }
    
    func addviewcontrollerForSwip() {
        var controllerArray : [UIViewController] = []
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BestPictureViewController")
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ComedyViewController")
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SoundViewController")
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CostumeViewController")
        
        let controller  = vc as! BestPictureViewController
        controller.title = "Best picture"
        controller.delegate = self
        controllerArray.append(controller)
        
        let controller1 = vc1 as! ComedyViewController
        controller1.title = "Comedy"
        controller1.delegate = self
        controllerArray.append(controller1)
        
        let controller2 = vc2 as! SoundViewController
        controller2.title = "Sound"
        controller2.delegate = self
        controllerArray.append(controller2)
        
        let controller3 = vc3 as! CostumeViewController
        controller3.title = "Costume"
        controller3.delegate = self
        controllerArray.append(controller3)
        
        var bottomMenuMargin = UIScreen.main.bounds.width >= 414 ? 14 : 10
        if UIScreen.main.bounds.height >= 812 {
            bottomMenuMargin = 14
        }
        
        let parameters: [CAPSPageMenuOption] = [CAPSPageMenuOption.centerMenuItems(true),
                                            CAPSPageMenuOption.menuHeight(UIScreen.main.bounds.height > 668 ? 52 : 46),
                                            CAPSPageMenuOption.menuItemFont(UIFont(name: AppFont.bold, size: 14)!),
            CAPSPageMenuOption.scrollMenuBackgroundColor(UIColor.white),
            CAPSPageMenuOption.selectionIndicatorColor(AppColors.TacoPurple),
            
            CAPSPageMenuOption.selectionIndicatorHeight(2),
            CAPSPageMenuOption.bottomMenuHairlineColor(UIColor.groupTableViewBackground),
            CAPSPageMenuOption.selectedMenuItemLabelColor(AppColors.TacoPurple),
            CAPSPageMenuOption.titleTextSizeBasedOnMenuItemWidth(true),
            CAPSPageMenuOption.selectionIndicatorBottomMargin(CGFloat(bottomMenuMargin)),
            CAPSPageMenuOption.menuItemWidthBasedOnTitleTextWidth(true),
            CAPSPageMenuOption.menuMargin(pageMenuMargin),
            CAPSPageMenuOption.unselectedMenuItemLabelColor(UIColor(red: 81/255, green: 53/255, blue: 205/255, alpha: 0.5))
            
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:0.0, width:self.sliderView.frame.width, height:self.sliderView.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self 
        pageMenu?.viewDidLayoutSubviews()
        pageMenu?.configuration.scrollAnimationDurationOnMenuItemTap = Int(0.0)
        self.sliderView.addSubview(pageMenu!.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
       UIApplication.shared.statusBarView?.backgroundColor = .white
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension LeaderboardVC: CAPSPageMenuDelegate {
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
        if let ctrl = controller as? BestPictureViewController {
            ctrl.selectedUser = preSelectedUser
            ctrl.showPlayer = preIsVideoSelected
            
        } else if let ctrl = controller as? ComedyViewController {
            ctrl.selectedUser = preSelectedUser
            ctrl.showPlayer = preIsVideoSelected
            
        } else if let ctrl = controller as? SoundViewController {
            ctrl.selectedUser = preSelectedUser
            ctrl.showPlayer = preIsVideoSelected
            
        } else if let ctrl = controller as? CostumeViewController {
            ctrl.selectedUser = preSelectedUser
            ctrl.showPlayer = preIsVideoSelected
            
        }
        
        
        // let dic = ["openVideoPlay": preIsVideoSelected, "selectedUser": preSelectedUser as Any] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rightScrollNotify"), object:nil, userInfo: nil)
       
        btnBackArrow.isHidden = true
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int){
        print("didMoveToPage")
    }
    
}

extension LeaderboardVC : BestPictureViewControllerDelegate, CostumeViewControllerDelegate, ComedyViewControllerDelegate, SoundViewControllerDelegate {
    
    func changePlayerWindowAppearance(shouldHide: Bool, user: User?) {
        self.preSelectedUser = user
        self.preIsVideoSelected = !shouldHide
    }
    
    func OpenUserProfile(_ user: User?) {
        
        if user === DataManager.shared.Me  {
            self.tabBarController?.selectedIndex = 4
        } else {
            (self.tabBarController as? TabbarVC)?.pushUserProfile(self, tabbarIndex: 3, selectedUser: user)
        }
        
    }
    
}
