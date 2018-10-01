//
//  MyFriendsVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 09/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit


class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var playbuttonImage: UIImageView!
}

protocol FriendsVCDelegate {
    func showUserProfile(_ user: User?)
}

class FriendsVC: UIViewController {

    @IBOutlet weak var txtFSearchUser: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:FriendsVCDelegate?
    var isMyFriends: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let image = UIImageView(frame: CGRect(x: 12, y: 2, width: 18, height: 18))
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "search")
        leftView.addSubview(image)
        
        txtFSearchUser.leftView = leftView
        txtFSearchUser.leftViewMode = .always
        txtFSearchUser.contentVerticalAlignment = .center
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func tapOnUsername () {
        delegate?.showUserProfile(User5)
    }
    
    @objc private func tapOnPlayButtonImage () {
        
    }

}

extension FriendsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsTableViewCell
        
        let tapUsername = UITapGestureRecognizer(target: self, action: #selector(self.tapOnUsername))
        tapUsername.numberOfTapsRequired = 1
        cell.lblUsername.isUserInteractionEnabled = true
        cell.lblUsername.addGestureRecognizer(tapUsername)
        
        let tapProfilePic = UITapGestureRecognizer(target: self, action: #selector(self.tapOnUsername))
        tapProfilePic.numberOfTapsRequired = 1
        cell.profilePic.isUserInteractionEnabled = true
        cell.profilePic.addGestureRecognizer(tapProfilePic)
        
        cell.playbuttonImage.alpha = (indexPath.row % 3) == 0 ? 0.3 : 1
        
        let tapPlay = UITapGestureRecognizer(target: self, action: #selector(self.tapOnPlayButtonImage))
        tapPlay.numberOfTapsRequired = 1
        
        cell.playbuttonImage.isUserInteractionEnabled = true
        cell.playbuttonImage.addGestureRecognizer(tapPlay)
        
        if let friendStatus = isMyFriends, !friendStatus {
            cell.lblUsername.text = "Gavin Ethan"
            cell.profilePic.image = #imageLiteral(resourceName: "img_2.png")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
}
extension FriendsVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
