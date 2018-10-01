//
//  StatsCompare_FriendVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 10/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
protocol StatsCompare_FriendVCDelegate {
    func compare(name:String, uid: String)
}


class StatsCompare_FriendVC: UIViewController {
    
    @IBOutlet weak var txtFSearchUser: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCompare: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var selectedIndex : IndexPath?
    var delegate:StatsCompare_FriendVCDelegate?
    
    @IBOutlet weak var tblViewBottomConstant: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = nil
        
        tblViewBottomConstant.constant = 0.0
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 58, height: 25))
        let image = UIImageView(frame: CGRect(x: 12, y: 2, width: 22, height: 22))
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "search")
        leftView.addSubview(image)
        
        txtFSearchUser.leftView = leftView
        txtFSearchUser.leftViewMode = .always
        txtFSearchUser.contentVerticalAlignment = .center
        
        bottomView.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func compareStatusSelected(_ sender: Any) {
        
        delegate?.compare(name: "abc", uid: "123")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = AppColors.TacoPurple
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension StatsCompare_FriendVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StatsCompare_FriendCell
        
        if indexPath == selectedIndex {
            cell.buttonCell.image = #imageLiteral(resourceName: "select_checkmark")
        } else {
            cell.buttonCell.image = #imageLiteral(resourceName: "select-empty")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath {
            selectedIndex = nil
            
            UIView.transition(with: bottomView, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            bottomView.isHidden = true
            
        } else {
            selectedIndex = indexPath
            if bottomView.isHidden {
                UIView.transition(with: bottomView, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                bottomView.isHidden = false
            }
        }
        tableView.reloadData()
    }
    
    
}
