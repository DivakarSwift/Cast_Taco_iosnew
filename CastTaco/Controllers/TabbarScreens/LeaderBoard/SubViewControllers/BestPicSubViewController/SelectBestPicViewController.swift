//
//  SelectBestPicViewController.swift
//  CastTaco
//
//  Created by brst on 10/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol SelectPicViewControllerDelegate {
    func rankSelected(rank:Int, uid:String?)
    func rankRemoved(rank:Int, uid:String?)
    func openUserProfile()
}

class SelectBestPicViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var selectbestPicTable: UITableView!
    
    var delegate: SelectPicViewControllerDelegate?
    
    var firstSelected = false
    var secondSelected = false
    var thirdSelected = false
    
    var viewModel = PostsViewModel()
    var selectedCategoryType: BetType?
    var selectedUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PostsCell", bundle: nil)
        postsTable.register(nib, forCellReuseIdentifier: "postCellId")
        postsTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section > 0  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderPostCirclTableViewCell", for: indexPath) as! LeaderPostCirclTableViewCell
            
            let btn1 = cell.viewWithTag(101) as? UIButton
            let btn2 = cell.viewWithTag(102) as? UIButton
            let btn3 = cell.viewWithTag(103) as? UIButton
            
            btn1?.addTarget(self, action: #selector(self.pridictionCellTapped(sender:)), for: .touchUpInside)
            btn2?.addTarget(self, action: #selector(self.pridictionCellTapped(sender:)), for: .touchUpInside)
            btn3?.addTarget(self, action: #selector(self.pridictionCellTapped(sender:)), for: .touchUpInside)
            
//          btn1?.setImage(selectedUser?.image, for: .selected)
//          btn2?.setImage(selectedUser?.image, for: .selected)
//          btn3?.setImage(selectedUser?.image, for: .selected)
            
            btn1?.isSelected = false
            btn2?.isSelected = false
            btn3?.isSelected = false
            
            firstSelected = false
            secondSelected = false
            thirdSelected = false
            
            for bet in usersOnBet {
                if bet.category == selectedCategoryType {
                    let userInfo = bet.bettedUser?.user
                    if bet.bettedUser?.rank == 1 {
                        btn1?.setImage(userInfo?.image, for: .selected)
                        btn1?.isSelected = true
                        firstSelected = true
                    } else if bet.bettedUser?.rank == 2 {
                        btn2?.setImage(userInfo?.image, for: .selected)
                        btn2?.isSelected = true
                        secondSelected = true
                    } else if bet.bettedUser?.rank == 3 {
                        btn3?.setImage(userInfo?.image, for: .selected)
                        btn3?.isSelected = true
                        thirdSelected = true
                    }
                }
            }
            
            
            return cell
            
        }
        
        guard indexPath.row > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderUserShowTableViewCell", for: indexPath) as! LeaderUserShowTableViewCell
            cell.setup()
            cell.delegate = self
            
            cell.lblUsername.text = selectedUser?.username
            cell.profilePic.image = selectedUser?.image
            
            return cell
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCellId") as! PostsCell
        cell.setUp()
        cell.delegate = self as? PostsCellDelegate
        cell.setEmos(selectedCategories)
        return cell
    }
    
    
    
    @objc func pridictionCellTapped(sender:UIButton){
        
        if sender.tag == 101 {
            firstSelected = !firstSelected
            if firstSelected {
                delegate?.rankSelected(rank: 1, uid: "")
            } else {
                delegate?.rankRemoved(rank: 1, uid: "")
            }
            
        } else if sender.tag == 102 {
            secondSelected  = !secondSelected
            if secondSelected {
                delegate?.rankSelected(rank: 2, uid: "")
            } else {
                delegate?.rankRemoved(rank:2, uid: "")
            }
        } else if sender.tag == 103 {
            thirdSelected  = !thirdSelected
            if thirdSelected {
                delegate?.rankSelected(rank: 3, uid: "")
            } else {
                delegate?.rankRemoved(rank: 3, uid: "")
            }
        }
        postsTable.reloadData()
    }
}

extension SelectBestPicViewController : LeaderUserShowTableViewCellDelegate {
    func OpenUserProfile() {
        delegate?.openUserProfile()
    }
    
}
