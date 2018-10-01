//
//  MySuggestionsCollectionCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 07/09/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
protocol MySuggestionsCollectionCellDelegate {
    func mySuggestionDeleteAction(suggestion_Id:String)
}

class MySuggestionsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var twTextLbl: UITextView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblStarCount: UILabel!
    
    var delegate: MySuggestionsCollectionCellDelegate?
    var suggestion: ChallengeSuggestion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func deleteAction(_ sender: Any) {
        delegate?.mySuggestionDeleteAction(suggestion_Id: suggestion?.id ?? "")
    }
    
}
