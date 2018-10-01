//
//  SearchTableViewCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 08/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol SearchTableViewCellDelegate {
    func OpenUserProfile(_ user: User?)
}

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgPlayBtn: UIImageView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    var delegate : SearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup() {
        
        let tapUsername = UITapGestureRecognizer(target: self, action: #selector(self.showUserProfile(value:)))
        tapUsername.numberOfTapsRequired = 1
        lblUserName.isUserInteractionEnabled = true
        lblUserName.addGestureRecognizer(tapUsername)
        
        let tapUserPic = UITapGestureRecognizer(target: self, action: #selector(self.showUserProfile(value:)))
        tapUserPic.numberOfTapsRequired = 1
        imgProfilePic.isUserInteractionEnabled = true
        imgProfilePic.addGestureRecognizer(tapUserPic)
        
    }
    
    @objc func showUserProfile(value: UITapGestureRecognizer) {
        delegate?.OpenUserProfile(User2)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
