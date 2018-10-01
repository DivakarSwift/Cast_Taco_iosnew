//
//  DiscardPopupView.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

<<<<<<< HEAD
protocol DiscardPopupViewDelegate: class {
    func cancelPressed()
    func donePressed()
}

class DiscardPopupView: UIView {
    var delegate:DiscardPopupViewDelegate?
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "DiscardPopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DiscardPopupView
    }
    
    func setUpfrom(_ viewController: UIViewController, title: String, description:String) {
        lblTitle.text = title
        lblDescription.text = description
        
//      self.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: 200)
//      self.widthAnchor.constraint(equalToConstant: 60).isActive = true
//      self.heightAnchor.constraint(equalToConstant: 10).isActive = true
//      self.centerXAnchor.constraint(equalTo: postViewtap.centerXAnchor).isActive = true
//      self.bottomAnchor.constraint(equalTo: postViewtap.bottomAnchor, constant: -5).isActive = true
//      self.addConstraints(<#T##constraints: [NSLayoutConstraint]##[NSLayoutConstraint]#>)
        
//        self.heightAnchor.constraint(equalToConstant: 300)
//        self.widthAnchor.constraint(equalToConstant: 100)
        
        self.setNeedsLayout()
    }
    
    @IBAction func discardAction(_ sender: UIButton) {
       delegate?.donePressed()
    }
    
    @IBAction func keepAction(_ sender: UIButton) {
        delegate?.cancelPressed()
=======
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
>>>>>>> origin/master
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
