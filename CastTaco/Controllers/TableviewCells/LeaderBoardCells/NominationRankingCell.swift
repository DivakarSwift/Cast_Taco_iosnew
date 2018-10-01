//
//  NominationRankingCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 17/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol NominationRankingCellDelegate {
    func showContainerView(sender:UIGestureRecognizer)
    func playButtonPressed(sender:UIButton)
    func longPressCell(sender:UILongPressGestureRecognizer)
}

class NominationRankingCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var seprator: UILabel!
    @IBOutlet weak var imgPlayButton: UIImageView!
    
    var delegate: NominationRankingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func setup() {
        
        let lpGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressCell(sender:)))
        self.contentView.addGestureRecognizer(lpGestureRecognizer)
        
        lblName.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showContainer(sender:)))
        tap.numberOfTapsRequired = 1
        lblName.addGestureRecognizer(tap)
        
        profilePic.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.showContainer(sender:)))
        tap2.numberOfTapsRequired = 1
        profilePic.addGestureRecognizer(tap2)
        
        setBackgroundColor(color: .white)
        
    }
    
    func setCellForIndexpath(indexpath:IndexPath){
        
    }
    
    
    func shouldHideSeprator(_ isTrue:Bool = false){
        seprator.isHidden = isTrue
    }
    
    
    @objc func didLongPressCell(sender: UILongPressGestureRecognizer) {
        delegate?.longPressCell(sender: sender)
    }
    
    @objc func showContainer(sender: UIGestureRecognizer) {
        delegate?.showContainerView(sender: sender)
    }
    
    @IBAction func playAction(_ sender: Any) {
        delegate?.playButtonPressed(sender: sender as! UIButton)
    }
    
    func setBackgroundColor(color: UIColor = .white){
        backView.backgroundColor = color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
