//
//  MyProfileVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
  var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var sliderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []

        let controller  = OtherProfileVC.init(nibName: "OtherProfileVC", bundle: nil)
        controller.title = "Videos"
        controllerArray.append(controller)
        
        let controller1  = SearchVC.init(nibName: "SearchVC", bundle: nil)
        controller1.title = "Live Stats"
        controllerArray.append(controller1)
        
        let controller2  = SearchVC.init(nibName: "SearchVC", bundle: nil)
        controller2.title = "Social status"
        controllerArray.append(controller2)
        
        let controller3  = SearchVC.init(nibName: "SearchVC", bundle: nil)
        controller3.title = "Friends"
        controllerArray.append(controller3)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [CAPSPageMenuOption.centerMenuItems(true),CAPSPageMenuOption.menuItemWidth(self.view.frame.size.width/6 + 10),CAPSPageMenuOption.menuHeight(50),CAPSPageMenuOption.menuItemFont(UIFont.boldSystemFont(ofSize: 11))]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0, y:0.0, width:self.view.frame.width, height:self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.sliderView.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
