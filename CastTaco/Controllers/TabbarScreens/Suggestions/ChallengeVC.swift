//
//  ChallengeVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class ChallengeVC: UIViewController {

    @IBOutlet weak var bottomArrow: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    let viewModel = NextWeekChallengesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomArrow.transform = CGAffineTransform(rotationAngle: 3 * .pi/2)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViewConroller(value:)), name: NSNotification.Name.init("refreshViewController"), object: nil)
        
        viewModel.getChallengeOfWeek()
        viewModel.refreshView = { [weak self] model in
            if let thisWeekChallenge = model.thisWeekChallenge {
                self?.lblTitle.text = thisWeekChallenge.title
                self?.lblDescription.text = thisWeekChallenge.description
            }
        }
    }

    @IBAction func challengesAction(_ sender: UIButton) {
        let vc = NextWeekChallengesVC.init(nibName: "NextWeekChallengesVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Notification Observer
    
    @objc func refreshViewConroller(value: NSNotification){
        
        guard let userInfo = value.value(forKey: "userInfo") as? NSDictionary,
            let navigation = userInfo.value(forKey: "viewController") as? UINavigationController,
            navigation.viewControllers[0] == self else {
                return
        }
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
