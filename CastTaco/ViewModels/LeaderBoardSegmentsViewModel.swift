//
//  LeaderBoardSegmentsViewModel.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 29/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol LeaderBoardSegmentsViewModelDelegate {
    
    func reloadHeaderView()
    func longPressAction(recognizer: UILongPressGestureRecognizer)
    func showContainer(sender:UIGestureRecognizer)
    func OpenUserProfile(_ user: User?)
    func changePlayerWindowAppearance(shouldHide: Bool, user:User?)
}

class LeaderBoardSegmentsViewModel: NSObject {
    
    var showPlayer : Bool = false
    var delegate : LeaderBoardSegmentsViewModelDelegate?
    
    var viewController:UIViewController?
    var tableView: UITableView?
    var selectedUser:User?
    
    var usersArray:Array<User> = [User1, User2, User3, DataManager.shared.Me!, User4, User5, User1, User2, User3]
    var topUsersArray:Array<User> = [User1, User2, User3, User4, User5, User1, User2, User3]
    
    init(tableView:UITableView = UITableView(), viewController:UIViewController = UIViewController()) {
        self.viewController = viewController
        self.tableView = tableView
        
        let nib = UINib(nibName: "SetNominieesCell", bundle: nil)
        self.tableView?.register(nib , forCellReuseIdentifier: "SetNominieesCellId")
        let nib2 = UINib(nibName: "NominationRankingCell", bundle: nil)
        self.tableView?.register(nib2 , forCellReuseIdentifier: "NominationRankingCellId")
        let nib3 = UINib(nibName: "NominieesCell", bundle: nil)
        self.tableView?.register(nib3 , forCellReuseIdentifier: "NominieesCellId")
        let nib4 = UINib(nibName: "PlayVideoCell", bundle: nil)
        self.tableView?.register(nib4 , forCellReuseIdentifier: "PlayVideoCellId")
        let nib5 = UINib(nibName: "PredictionBannerCell", bundle: nil)
        self.tableView?.register(nib5 , forCellReuseIdentifier: "PredictionBannerCellId")
        
    }
    
    func startShowPlayer() {
        
        print("delegate")
        
        DispatchQueue.main.async {
            self.delegate?.changePlayerWindowAppearance(shouldHide: false, user: self.selectedUser)
        }
        
        showPlayer = true
        tableView?.reloadData()
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return  45
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 350
        } else {
            return 83
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showPlayer ? 1 : section == 0 ? (1 + topUsersArray.count) : usersArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return showPlayer ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 1:return "YOUR RANKING"
            
        default :return ""
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        
        guard let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView else {
            return
        }
        tableViewHeaderFooterView.textLabel?.textColor = UIColor(red: 69/255.0, green: 66/255.0, blue: 201/255.0, alpha: 1.0)
        tableViewHeaderFooterView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewHeaderFooterView.frame.size.width, height: 45))
        myView.backgroundColor = UIColor.white
        let label = UILabel(frame:CGRect(x: 16, y: 5, width: tableViewHeaderFooterView.frame.size.width, height: 35))
        label.text = "YOUR RANKING"
        label.textColor = AppColors.TacoPurple
        label.font = UIFont(name: AppFont.bold, size: 13)!
        myView.addSubview(label)
        view.addSubview(myView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !showPlayer else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayVideoCellId", for: indexPath) as! PlayVideoCell
            
            cell.delegate = self
            cell.lblUsername.text = selectedUser?.username  //userInfo?.name
            cell.profilePic.image = selectedUser?.image //userInfo?.image
            
            let lpGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell(sender:)))
            cell.contentView.addGestureRecognizer(lpGestureRecognizer)
            
            return cell
        }
        
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NominationRankingCellId", for: indexPath) as! NominationRankingCell
            cell.setup()
            cell.delegate = self
            
            cell.profilePic.image = usersArray[indexPath.row ].image  //userInfo?.image
            cell.lblName.text = usersArray[indexPath.row ].username  // userInfo?.name
            
            if usersArray[indexPath.row].uid == DataManager.shared.Me?.uid {
                cell.lblName.text = "You"
                cell.profilePic.sd_setImage(with: URL(string: (DataManager.shared.Me?.avatarUrl)!), placeholderImage: #imageLiteral(resourceName: "sample-user"))
                cell.setBackgroundColor(color: AppColors.LightBlue)
                cell.shouldHideSeprator(true)
                
                if let previousCell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1 , section: indexPath.section)) as? NominationRankingCell {
                    previousCell.shouldHideSeprator(true)
                }
            }
            
            return cell
            
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionBannerCellId", for: indexPath) as! PredictionBannerCell
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NominieesCellId", for: indexPath) as! NominieesCell
            cell.setup()
            cell.delegate = self
            
            cell.profilePic.image = topUsersArray[indexPath.row - 1].image  // userInfo?.image
            cell.lblName.text = topUsersArray[indexPath.row - 1].username  // userInfo?.name
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func getDrageView() -> UIView? {
        
        if let cellView = UINib(nibName: "PlayVideoCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? PlayVideoCell {
            cellView.lblUsername.text = selectedUser?.username  // forUser.name
            cellView.profilePic.image = selectedUser?.image   // forUser.image
            return cellView.contentView
        }
        
        return nil
    }
    
    
    @objc func didLongPressCell(sender: UILongPressGestureRecognizer) {
        delegate?.longPressAction(recognizer: sender)
    }
    
    
    @objc func showContainer(sender: UIGestureRecognizer) {
        delegate?.showContainer(sender: sender)
    }
    
}


extension LeaderBoardSegmentsViewModel : setNominieesViewDelegate {
    func firstCirlceTapped() {
        delegate?.reloadHeaderView()
    }
    
    func secondCirlceTapped() {
        delegate?.reloadHeaderView()
    }
    
    func thirdCirlceTapped() {
        delegate?.reloadHeaderView()
    }
    
}

extension LeaderBoardSegmentsViewModel: PlayVideoCellDelegate {
    func playerWillRemove() {
        print("delegate 2")
        
        showPlayer = false
        tableView?.reloadData()
        delegate?.changePlayerWindowAppearance(shouldHide: true, user: selectedUser)
    }
    
}

extension LeaderBoardSegmentsViewModel: NominieesCellDelegate, NominationRankingCellDelegate {
    
    func showContainerView(sender: UIGestureRecognizer) {
        
        if sender .isKind(of: UITapGestureRecognizer.self) {
            if let indexpath = tableView?.indexPathForRow(at: sender.location(in: tableView)) {
                if indexpath.section == 0 {
                    self.selectedUser = topUsersArray[indexpath.row - 1]
                } else {
                    self.selectedUser = usersArray[indexpath.row]
                }
            }
        }
        
        delegate?.showContainer(sender: sender)
    }
    
    func playButtonPressed(sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = self.tableView?.indexPathForRow(at: buttonPosition) {
            if indexPath.section == 0 {
                self.selectedUser = topUsersArray[indexPath.row - 1]
            } else {
                self.selectedUser = usersArray[indexPath.row]
            }
        }
        startShowPlayer()
    }
    
    func longPressCell(sender:UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            if let indexPath = tableView?.indexPathForRow(at: sender.location(in: tableView)) {
                if indexPath.section == 0 {
                    self.selectedUser = topUsersArray[indexPath.row - 1]
                } else {
                    self.selectedUser = usersArray[indexPath.row]
                }
            }
        }
        
        delegate?.longPressAction(recognizer: sender)
    }
    
}

