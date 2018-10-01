//
//  MyVideosCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 09/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol MyVideosCellDelegate {
    func threeDotAction()
}

class MyVideosCell: UITableViewCell {

    var delegate:MyVideosCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func threeDotAction(_ sender: Any) {
        delegate?.threeDotAction()
    }
    
    

}
