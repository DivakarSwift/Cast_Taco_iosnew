//
//  PostsCell.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol SuggestionsCellDelegate {
    func OpenUserProfile()
    func likeUnlikeSuggetion(sender:UIButton)
    func openActionSheet(sender:UIButton)
    func playAction(sender:UIButton)
}

class SuggestionsCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblSuggestion: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    var delegate : SuggestionsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp() {
        btnStar.isSelected = false
        profilePic.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.TapOnProfilePic))
        tap.numberOfTapsRequired = 1
        profilePic.addGestureRecognizer(tap)
        
        btnPlay.alpha = 0.4
        btnPlay.isUserInteractionEnabled = false
    }
    
    @IBAction func starAction(_ sender: Any) {
        btnStar.isSelected = !btnStar.isSelected
        delegate?.likeUnlikeSuggetion(sender: sender as! UIButton)
    }
    
    @IBAction func reportAction(_ sender: Any) {
        delegate?.openActionSheet(sender: sender as! UIButton)
    }
    
    @IBAction func playAction(_ sender: Any) {
        delegate?.playAction(sender: sender as! UIButton)
    }
    
    @objc func TapOnProfilePic() {
        delegate?.OpenUserProfile()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
