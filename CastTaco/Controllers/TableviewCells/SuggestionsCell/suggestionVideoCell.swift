//
//  suggestionVideoCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 20/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol SuggestionsVideoCellDelegate {
    func OpenUserProfile()
    func likeUnlikeSuggetion(sender:UIButton)
    func openActionSheet(sender:UIButton)
}

class suggestionVideoCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblSuggestion: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    
    var delegate : SuggestionsVideoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        btnStar.isSelected = false
        profilePic.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.TapOnProfilePic))
        tap.numberOfTapsRequired = 1
        profilePic.addGestureRecognizer(tap)
    }
    
    @IBAction func starAction(_ sender: Any) {
        btnStar.isSelected = !btnStar.isSelected
        delegate?.likeUnlikeSuggetion(sender: sender as! UIButton)
    }
    
    @IBAction func reportAction(_ sender: Any) {
        delegate?.openActionSheet(sender: sender as! UIButton)
    }
    
    @objc func TapOnProfilePic(){
        delegate?.OpenUserProfile()
    }
    
}
