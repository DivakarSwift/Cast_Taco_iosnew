//
//  BestPictureViewController.swift
//  CastTaco
//
//  Created by brst on 08/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol BestPictureViewControllerDelegate {
    func OpenUserProfile(_ user:User?)
    func changePlayerWindowAppearance(shouldHide:Bool, user: User?)
}

class BestPictureViewController: UIViewController {
    
    private var dragView: UIView?
    private var dropZone1: CGRect!
    private var dropZone2: CGRect!
    private var dropZone3: CGRect!
    
    var showPlayer = false
    var selectedUser: User?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nominieesView: setNominieesView!
    
    var delegate: BestPictureViewControllerDelegate?
    var viewModel = LeaderBoardSegmentsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LeaderBoardSegmentsViewModel(tableView: self.tableView, viewController: self)
        viewModel.delegate = self
        viewModel.showPlayer = self.showPlayer
        if let user = selectedUser {
            viewModel.selectedUser = user
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(rightScrollNotify(notification:)), name:Notification.Name(rawValue: "rightScrollNotify"), object: nil)
        
        containerView.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        
        reloadHeader()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLeaderBoardSegments(value:)), name:Notification.Name(rawValue: "refreshLeaderBoardSegments"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @objc func refreshLeaderBoardSegments(value:NSNotification) {
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func unhideContainer(sender:UIGestureRecognizer) {
        self.containerView.isHidden = false
        
        let embeddedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectBestPicVCId") as! SelectBestPicViewController
        embeddedVC.delegate = self
        embeddedVC.selectedUser = viewModel.selectedUser
        embeddedVC.selectedCategoryType = BetType.BestPicture
        self.addChildViewController(embeddedVC)
        containerView.addSubview(embeddedVC.view)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "containerViewDidAppear"), object: nil)
    }
    
    @objc func rightScrollNotify(notification:NSNotification) {
        self.containerView.isHidden = true
        
       /* if let dic = notification.userInfo {
            if let flag = dic["openVideoPlay"] as? Bool, flag ,
                let user = dic["selectedUser"] as? User {
                self.viewModel.showPlayer = true
                self.viewModel.selectedUser = user
            } else {
                self.viewModel.showPlayer = false
            }
        } */
        
        viewModel.showPlayer = self.showPlayer
        
        if let user = selectedUser {
            viewModel.selectedUser = user
        }
        
        self.tableView.reloadData()
        if self.showPlayer {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        reloadHeader()
    }
   
    func refreshViewController(){
        tableView.contentOffset.y = 0
        reloadHeader()
    }
    
    
    func reloadHeader() {
        
        nominieesView.delegate = self
        nominieesView.highlightCircle1()
        nominieesView.highlightCircle2()
        nominieesView.highlightCircle3()
        
        nominieesView.setCircle1Status(false)
        nominieesView.setCircle2Status(false)
        nominieesView.setCircle3Status(false)
        
        dropZone1 = nominieesView.btnCircle1.frame
        dropZone2 = nominieesView.btnCircle2.frame
        dropZone3 = nominieesView.btnCircle3.frame
       
        for bet in usersOnBet {
            if bet.category == BetType.BestPicture {
                let userInfo = bet.bettedUser?.user
                if bet.bettedUser?.rank == 1 {
                    nominieesView.btnCircle1.setImage(userInfo?.image, for: .selected)
                    nominieesView.lblUsernameRank1.text = (userInfo?.firstName ?? "") + " " + (userInfo?.lastName ?? "" )
                    nominieesView.setCircle1Status(true)
                } else if bet.bettedUser?.rank == 2 {
                    nominieesView.btnCircle2.setImage(userInfo?.image, for: .selected)
                    nominieesView.lblUsernameRank2.text = (userInfo?.firstName ?? "") + " " + (userInfo?.lastName ?? "" )
                    nominieesView.setCircle2Status(true)
                } else if bet.bettedUser?.rank == 3 {
                    nominieesView.btnCircle3.setImage(userInfo?.image, for: .selected)
                    nominieesView.lblUsernameRank3.text = (userInfo?.firstName ?? "") + " " + (userInfo?.lastName ?? "" )
                    nominieesView.setCircle3Status(true)
                }
            }
        }
        
    }
    
    
    @objc func didLongPressCell (recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if viewModel.getDrageView() != nil {
                dragView = viewModel.getDrageView()
                dragView?.frame.origin = recognizer.location(in: view)
                dragView?.backgroundColor = UIColor.white
                dragView?.alpha = 0.6
                dragView?.setNeedsDisplay()
                
                view.addSubview(dragView!)
            }
        case .changed:
            dragView?.center = recognizer.location(in: view)
            
            if (dropZone1.contains((dragView?.center)!)) {
                  nominieesView.highlightCircle1(true)
                  nominieesView.highlightCircle2()
                  nominieesView.highlightCircle3()
                
            } else if (dropZone2.contains((dragView?.center)!)) {
                nominieesView.highlightCircle1()
                nominieesView.highlightCircle2(true)
                nominieesView.highlightCircle3()
                
            } else if (dropZone3.contains((dragView?.center)!)) {
                nominieesView.highlightCircle1()
                nominieesView.highlightCircle2()
                nominieesView.highlightCircle3(true)
                
            } else {
                nominieesView.highlightCircle1()
                nominieesView.highlightCircle2()
                nominieesView.highlightCircle3()
            }
            
        case .ended:
            
            if (dragView == nil) { return }
            
            if (dropZone1.contains((dragView?.center)!)) {
                self.setBet(1)
                
                reloadHeader()
            } else if (dropZone2.contains((dragView?.center)!)) {
                self.setBet(2)
                
                reloadHeader()
            } else if (dropZone3.contains((dragView?.center)!)) {
                self.setBet(3)
                
                reloadHeader()
            } else {
                print("Not Intersected")
            }
            
            dragView?.removeFromSuperview()
            
            nominieesView.highlightCircle1()
            nominieesView.highlightCircle2()
            nominieesView.highlightCircle3()
            
        default:
            print("Any other action?")
        }
    }
    
    private func setBet(_ forRank: Int) {
        Singleton.shared.setBet(viewModel.selectedUser, forCatgory: .BestPicture, forRank)
    }
    
    private func isUserOnBet(_ forRank:Int) ->Bool {
        return Singleton.shared.isUserOnBet(.BestPicture, forRank: forRank)
    }
    
}



extension BestPictureViewController :UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.tableView(tableView, heightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.tableView(tableView, estimatedHeightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections(in:tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.tableView(tableView, titleForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        viewModel.tableView(tableView, willDisplayHeaderView: view, forSection: forSection)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.tableView(tableView, cellForRowAt: indexPath)
    }
    
}


extension BestPictureViewController : SelectPicViewControllerDelegate {
    func openUserProfile() {
        delegate?.OpenUserProfile(viewModel.selectedUser)
    }
    
    func rankSelected(rank: Int, uid: String?) {
        Singleton.shared.setBet(viewModel.selectedUser, forCatgory: .BestPicture, rank)
        reloadHeader()
    }
    
    func rankRemoved(rank: Int, uid: String?) {
        Singleton.shared.removeBet(.BestPicture, forRank: rank)
        reloadHeader()
    }
}

extension BestPictureViewController : setNominieesViewDelegate {
    func firstCirlceTapped() {
        if viewModel.showPlayer, !isUserOnBet(1) {
            Singleton.shared.setBet(viewModel.selectedUser, forCatgory: .BestPicture, 1)
        } else {
            Singleton.shared.removeBet(.BestPicture, forRank: 1)
        }
        reloadHeader()
    }
    
    func secondCirlceTapped() {
        if viewModel.showPlayer, !isUserOnBet(2) {
            Singleton.shared.setBet(viewModel.selectedUser, forCatgory: .BestPicture, 2)
        } else {
             Singleton.shared.removeBet(.BestPicture, forRank: 2)
        }
        reloadHeader()
    }
    
    func thirdCirlceTapped() {
        if viewModel.showPlayer, !isUserOnBet(3) {
            Singleton.shared.setBet(viewModel.selectedUser, forCatgory: .BestPicture, 3)
        } else {
            Singleton.shared.removeBet(.BestPicture, forRank: 3)
        }
        reloadHeader()
    }
    
}


extension BestPictureViewController : LeaderBoardSegmentsViewModelDelegate {
    func changePlayerWindowAppearance(shouldHide: Bool, user: User?) {
        delegate?.changePlayerWindowAppearance(shouldHide: shouldHide, user: user)
    }
    
    func showContainer(sender: UIGestureRecognizer) {
        self.unhideContainer(sender: sender)
    }
    
    func longPressAction(recognizer: UILongPressGestureRecognizer) {
        self.didLongPressCell(recognizer: recognizer)
    }
    
    func reloadHeaderView() {
        print("header view relaod")
        
        self.reloadHeader()
    }
    
    func OpenUserProfile(_ user: User?) {
        delegate?.OpenUserProfile(user)
    }

}

