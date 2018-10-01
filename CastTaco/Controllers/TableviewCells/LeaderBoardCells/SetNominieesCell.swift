//
//  TableViewCell.swift
//  CastTaco
//
//  Created by brst on 08/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol SetNominieesCellDelegate {
    func firstCirlceTapped()
    func secondCirlceTapped()
    func thirdCirlceTapped()
}

class SetNominieesCell: UITableViewCell {
    @IBOutlet weak var btnCircle1: UIButton!
    @IBOutlet weak var btnCircle2: UIButton!
    @IBOutlet weak var btnCircle3: UIButton!
    @IBOutlet weak var lblRank1: UILabel!
    @IBOutlet weak var lblRank2: UILabel!
    @IBOutlet weak var lblRank3: UILabel!
    
    @IBOutlet weak var lblUsernameRank1: UILabel!
    @IBOutlet weak var lblUsernameRank2: UILabel!
    @IBOutlet weak var lblUsernameRank3: UILabel!
    
    
    var delegate : SetNominieesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func highlightCircle1(_ should: Bool = false) {
        if should {
            btnCircle1.borderColor = AppColors.TacoPurple
            btnCircle1.borderWidth = 2
        } else {
            btnCircle1.borderColor = .clear
            btnCircle1.borderWidth = 0
        }
    }
    
    func highlightCircle2(_ should: Bool = false) {
        if should {
            btnCircle2.borderColor = AppColors.TacoPurple
            btnCircle2.borderWidth = 2
        } else {
            btnCircle2.borderColor = .clear
            btnCircle2.borderWidth = 0
        }
        
    }
    
    func highlightCircle3(_ should: Bool = false) {
        if should {
            btnCircle3.borderColor = AppColors.TacoPurple
            btnCircle3.borderWidth = 2
        } else {
            btnCircle3.borderColor = .clear
            btnCircle3.borderWidth = 0
        }
        
    }
    
    func setCircle1Status(_ isSelected: Bool){
        btnCircle1.isSelected = isSelected
        lblRank1.isHidden = !isSelected
        lblUsernameRank1.isHidden = !isSelected
    }
    
    func setCircle2Status(_ isSelected: Bool){
        btnCircle2.isSelected = isSelected
        lblRank2.isHidden = !isSelected
        lblUsernameRank2.isHidden = !isSelected
    }
    
    func setCircle3Status(_ isSelected: Bool){
        btnCircle3.isSelected = isSelected
        lblRank3.isHidden = !isSelected
        lblUsernameRank3.isHidden = !isSelected
    }
    
    @IBAction func btnCirlce1Action(_ sender: Any) {
        delegate?.firstCirlceTapped()
    }
    
    @IBAction func btnCirlce2Action(_ sender: Any) {
        delegate?.secondCirlceTapped()
    }
    
    @IBAction func btnCirlce3Action(_ sender: Any) {
        delegate?.thirdCirlceTapped()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
