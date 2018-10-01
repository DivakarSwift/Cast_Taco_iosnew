//
//  contentbestPicTableViewCell.swift
//  CastTaco
//
//  Created by brst on 08/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class contentbestPicTableViewCell: UITableViewCell {
  @IBOutlet weak var cellImageView: UIImageView!
     @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.cellImageView.layer.cornerRadius = self.cellImageView.frame.width / 2
        self.cellImageView.layer.masksToBounds = true
    }
   
    
    //MARK: - Configure Cell Methods
//    func configureCell(profile: ProfileData) {
//        self.cellImageView?.image = UIImage(named: profile.profileImageName)
//        self.labelName.text = profile.age
//     //   self.labelName.text = profile.name
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
