//
//  LeaderUserShowTableViewCell.swift
//  CastTaco
//
//  Created by brst on 14/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol LeaderUserShowTableViewCellDelegate {
    func OpenUserProfile()
}

class LeaderUserShowTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    var delegate: LeaderUserShowTableViewCellDelegate?
    
    func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnProfilePic))
        tap.numberOfTapsRequired = 1
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tapOnProfilePic))
        tap2.numberOfTapsRequired = 1
        lblUsername.isUserInteractionEnabled = true
        lblUsername.addGestureRecognizer(tap2)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func tapOnProfilePic() {
        delegate?.OpenUserProfile()
    }
    
    @IBAction func followAction(_ sender: Any) {
        
        btnFollow.isSelected = !btnFollow.isSelected
        
        if btnFollow.isSelected {
            btnFollow.backgroundColor = .white
        } else {
            btnFollow.backgroundColor = AppColors.JuanPurpleTint
        }
        
    }
    
    
}
