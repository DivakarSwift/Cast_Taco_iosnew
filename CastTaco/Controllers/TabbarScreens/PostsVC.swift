//
//  PostsVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class PostsVC: UIViewController {
    
    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var topHeaderHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var textHeaderView: UIView!
    
    var viewModel = PostsViewModel()
    
    //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initController(nvc: self.navigationController!)
        viewModel.delegate = self
        textHeaderView.isHidden = true
        
        let nib = UINib(nibName: "PostsCell", bundle: nil)
        postsTable.register(nib, forCellReuseIdentifier: "postCellId")
        
        postsTable.clipsToBounds = true
        let nib2 = UINib(nibName: "PostsTableHeaderView", bundle: nil)
        postsTable.register(nib2, forHeaderFooterViewReuseIdentifier: "PostsTableHeaderView")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshViewConroller(value:)), name: NSNotification.Name.init("refreshViewController"), object: nil)
        
    }
    
    @objc func tapOnChalengeName() {
        self.tabBarController?.selectedIndex = 1
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveToChallengeVC"), object: nil, userInfo: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = AppColors.TacoPurple
        postsTable.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- Notification Observer
   
    @objc func refreshViewConroller(value: NSNotification){
        
        guard let userInfo = value.value(forKey: "userInfo") as? NSDictionary,
        let navigation = userInfo.value(forKey: "viewController") as? UINavigationController,
        navigation.viewControllers[0] == self else {
         return
        }
        
      //self.postsTable.contentOffset.y = 0
        self.postsTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
    }
    
    //MARK:- Memory Warning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}


extension PostsVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 75, self.textHeaderView.isHidden {
           // changeHeader(increasing: true)
        } else if scrollView.contentOffset.y < 75, !self.textHeaderView.isHidden {
          //  changeHeader(increasing: false)
        }
    }
    
    private func changeHeader(increasing:Bool) {
        if increasing {
            UIView.transition(with: self.textHeaderView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.textHeaderView.isHidden = false
            }, completion: nil)
        } else {
            UIView.transition(with: self.textHeaderView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.textHeaderView.isHidden = true
            }, completion: nil)
        }
    }
}


extension PostsVC : UITableViewDelegate,UITableViewDataSource {
    //MARK:- Table View methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PostsTableHeaderView") as! PostsTableHeaderView
        header.delegate = self
        header.lblChallengeName.isUserInteractionEnabled = true
        let tapOnChalenge = UITapGestureRecognizer(target: self, action: #selector(self.tapOnChalengeName))
        tapOnChalenge.numberOfTapsRequired = 1
        header.lblChallengeName.addGestureRecognizer(tapOnChalenge)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(at: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
    }
    
}

extension PostsVC : PostsViewModelDelegate {
    func openUserProfile(_ uid: String) {
        (self.tabBarController as? TabbarVC)?.pushUserProfile(self, tabbarIndex: 0)
    }
}



extension PostsVC : PostsTableHeaderViewDelegate {
    func sortDidSelected() {
        let vc = FilterVC.init(nibName: "FilterVC", bundle: nil)
        vc.filtertype = FilterType.Reorder_Films
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchDidSelected() {
        let vc = SearchVC.init(nibName: "SearchVC", bundle: nil)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PostsVC : SearchVCDelegate {
    func openUserProfile(_ user: User?) {
        (self.tabBarController as? TabbarVC)?.pushUserProfile(self, tabbarIndex: 0, selectedUser: user)
    }
    
}
