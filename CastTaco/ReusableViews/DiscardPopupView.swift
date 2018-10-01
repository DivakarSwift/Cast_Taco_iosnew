//
//  DiscardPopupView.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol PopUpDelegate: class {
    func isKeepOrDiscard(isKeep:Bool)
}

class DiscardPopupView: UIView {
    var delegate:PopUpDelegate?
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "DiscardPopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func discardAction(_ sender: UIButton) {
       delegate?.isKeepOrDiscard(isKeep: false)
    }
    
    @IBAction func keepAction(_ sender: UIButton) {
        delegate?.isKeepOrDiscard(isKeep: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    class func instanceOfClass() -> DiscardPopupView {
        let myClassNib = UINib(nibName: "DiscardPopupView", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! DiscardPopupView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
