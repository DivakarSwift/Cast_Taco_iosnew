//
//  TabbarVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {

    let notActiveImage = [#imageLiteral(resourceName: "notactiveVideo"), #imageLiteral(resourceName: "notactiveChalenge"),#imageLiteral(resourceName: "record-button"), #imageLiteral(resourceName: "notactiveLeader"), #imageLiteral(resourceName: "notactiveProfile")]
    let activeImage = [#imageLiteral(resourceName: "activeVideo"),#imageLiteral(resourceName: "activeChalange"),#imageLiteral(resourceName: "record-button"), #imageLiteral(resourceName: "activeLeaderboard"), #imageLiteral(resourceName: "activeProfile")]
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    private var preSelectedIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = preSelectedIndex
        
        self.tabBar.items![0].image = notActiveImage[0].withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].image = notActiveImage[1].withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].image = notActiveImage[2].withRenderingMode(.alwaysOriginal)
        self.tabBar.items![3].image = notActiveImage[3].withRenderingMode(.alwaysOriginal)
        self.tabBar.items![4].image = notActiveImage[4].withRenderingMode(.alwaysOriginal)
        
        // to remove top black line from tabbar
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
       
        self.delegate = self
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        preSelectedIndex = self.selectedIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight + 8.0
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
        UserDefaults.standard.setValue(newFrame.origin.y, forKey: "tabBarY")
        
    }
    
    override func viewDidLayoutSubviews() {
        print(tabBar)
    }
    
}

extension TabbarVC : UITabBarControllerDelegate {
 
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        /*
         Remove Other User's profile from 4th tab that was inserted on tap on username/profilepic
        */
        if preSelectedIndex == 4 && tabBarController.selectedIndex != 4 {
            popUserProfile(tabBarController.selectedIndex)
            
        }
        
        switch tabBarController.selectedIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cameraViewShouldAppear"), object: nil, userInfo: nil)
            break
        case 3:
            let dic = ["index" : 0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLeaderBoardSegments"), object: nil, userInfo: dic)
            break
        case 4:
            break
        default:
            print("Out Of Bound")
        }
        
        
        
        /*
         Reload tabs if user tap on same tab again
        */
        
        if preSelectedIndex == tabBarController.selectedIndex {
            
            let dic = ["viewController": viewControllers![preSelectedIndex]]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshViewController"), object: nil, userInfo: dic)
            
            /*
            let tappedController = viewControllers![tabBarController.selectedIndex]
            viewControllers?.remove(at: tabBarController.selectedIndex)
            self.viewControllers?.insert(tappedController, at: tabBarController.selectedIndex)
            self.tabBar.items![tabBarController.selectedIndex].image = notActiveImage[tabBarController.selectedIndex].withRenderingMode(.alwaysOriginal)
            self.tabBar.items![tabBarController.selectedIndex].imageInsets = UIEdgeInsetsMake(0, 0, -8, 0)
            self.selectedIndex = preSelectedIndex
             */
            
        }
        
    }
    
}

extension TabbarVC {
    
    func pushUserProfile(_ from : UIViewController, tabbarIndex Index: Int, selectedUser:User? = User1){
        
        guard let nav = self.viewControllers?[4] as? UINavigationController else {
            return
        }
        
        guard nav.viewControllers[0].isKind(of: MyProfileVC.self) else {
            return
        }
        
        let vc = UIStoryboard(name: "Main", bundle:  nil).instantiateViewController(withIdentifier: "UserProfileVCId") as! UserProfileVC
        vc.previousIndex = Index
        vc.selectedUser = selectedUser
 
        nav.viewControllers[0] = vc
       
        self.tabBar.items![4].image = #imageLiteral(resourceName: "activeProfile").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![4].imageInsets = UIEdgeInsetsMake(0, 0, -8, 0)
        self.selectedIndex = 4
    }
    
    func popUserProfile(_ toIndex : Int?) {
        
        guard let nav = self.viewControllers?[4] as? UINavigationController else {
            return
        }
        
        guard nav.viewControllers[0].isKind(of: UserProfileVC.self) else {
            return
        }
        
        let vc = UIStoryboard(name: "Main", bundle:  nil).instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
   
        nav.viewControllers[0] = vc
        
        self.tabBar.items![4].imageInsets = UIEdgeInsetsMake(0, 0, -8, 0)
        self.tabBar.items![4].image = #imageLiteral(resourceName: "notactiveProfile").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![4].selectedImage = #imageLiteral(resourceName: "activeProfile").withRenderingMode(.alwaysOriginal)
        self.selectedIndex = toIndex ?? 0
        
    }
}
