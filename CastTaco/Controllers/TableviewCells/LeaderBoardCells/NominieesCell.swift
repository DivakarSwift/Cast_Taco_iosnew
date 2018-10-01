//
//  NominieesCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 17/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol NominieesCellDelegate {
    func showContainerView(sender:UIGestureRecognizer)
    func playButtonPressed(sender:UIButton)
    func longPressCell(sender:UILongPressGestureRecognizer)
}

class NominieesCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var btnPlayVideo: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var seprator: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    
    var delegate:NominieesCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func shouldHideSeprator(_ isTrue:Bool = false){
        seprator.isHidden = isTrue
    }
    
    func setBackgroundColor(color: UIColor = .white){
        backView.backgroundColor = color
    }
    
    func setup(){
        let lpGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell(sender:)))
        self.contentView.addGestureRecognizer(lpGestureRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showContainer(sender:)))
        tap.numberOfTapsRequired = 1
        self.lblName.isUserInteractionEnabled = true
        self.lblName.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.showContainer(sender:)))
        tap2.numberOfTapsRequired = 1
        self.profilePic.isUserInteractionEnabled = true
        self.profilePic.addGestureRecognizer(tap2)
        
    }

    @objc func didLongPressCell(sender: UILongPressGestureRecognizer) {
        delegate?.longPressCell(sender: sender)
    }
    
    @objc func showContainer(sender:UIGestureRecognizer) {
        delegate?.showContainerView(sender: sender)
    }
    
    @IBAction func playAction(_ sender: Any) {
        delegate?.playButtonPressed(sender: sender as! UIButton)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
