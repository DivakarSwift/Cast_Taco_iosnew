//
//  PostsCell.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

@objc protocol PostsCellDelegate {
    func openUserProfile(_ uid: String)
    func reloadPost(_ indexpath:IndexPath)
    @objc optional func closeCastTable(_ indexpath:IndexPath)
}


fileprivate var openCellIndex: IndexPath?

class PostsCell: UITableViewCell {

    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var emoContainerView: UIView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnCast: UIButton!
    @IBOutlet weak var lblMsgPopUp: PaddingLabel!
    @IBOutlet weak var imgSoundAction: UIImageView!
    @IBOutlet weak var castBtnWidthConstant: NSLayoutConstraint!
    
    @IBOutlet weak var cellTopPadding: NSLayoutConstraint!
    @IBOutlet weak var categoryTableHeightConst: NSLayoutConstraint!
    
    var delegate : PostsCellDelegate?
    var reloadPost: (() -> Void)?
    private var pendingCategories = Array<Emoticon>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func selectedIndex(indexpath:IndexPath) -> Int {
        return self.pendingCategories.count - (indexpath.row)
    }
    
    func setUp() {
       
        categoryTable.isHidden = true
        lblMsgPopUp.isHidden = true
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        btnCast.backgroundColor = UIColor.white
        btnCast.borderWidth = 1.5
        btnCast.isSelected = false
        castBtnWidthConstant.constant = 60
        
        
        let tapUsername = UITapGestureRecognizer(target: self, action: #selector(self.usernameTapped(value:)))
        tapUsername.numberOfTapsRequired = 1
        lblUsername.isUserInteractionEnabled = true
        lblUsername.addGestureRecognizer(tapUsername)
        
        let nib = UINib.init(nibName: "CastTableViewCell", bundle: nil)
        categoryTable.register(nib, forCellReuseIdentifier: "CastCellId")
        categoryTable.clipsToBounds = true

        let check = selectedCategories.contains(where: { $0 is BestMotionPicture})
        if check {
            selectedCategories.remove(at: 0)
        }
        
        categoryTable.transform = CGAffineTransform(scaleX: 1, y: -1)
        
    }
    
    func setTopPadding(_ to: CGFloat) {
        cellTopPadding.constant = to
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let index = openCellIndex {
           //  delegate?.closeCastTable!(index)
           // delegate?.reloadPost(index)
            
            categoryTable.isHidden = true
            emoContainerView.isHidden = false
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.clipsToBounds = true
        
    }
    
    @objc func usernameTapped(value: UITapGestureRecognizer){
        delegate?.openUserProfile("1230")
    }
    
    
    func setEmos(_ cetegoriesArray:Array<Emoticon>?) {
        var origin = UIScreen.main.bounds.width > 375 ? 10 : 5
        let width = UIScreen.main.bounds.width > 320 ? 28 : 22
        let gap = UIScreen.main.bounds.width > 375 ? 6 : 4
        let yOrigin = (Int(emoContainerView.frame.height) - width)/2
        
        _ = emoContainerView.subviews.map({ $0.removeFromSuperview() })
        emoContainerView.isHidden = false
        pendingCategories.removeAll()
        
        for emo in AppCategories {
            let check = selectedCategories.contains(where: { $0 === emo })
            if !check {
                pendingCategories.append(emo)
            }
        }
        
        categoryTable.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        guard let localCetegoriesArray = cetegoriesArray else {
            let addMore = UIImageView(frame: CGRect(x: origin, y: yOrigin, width: width, height: width))
            addMore.contentMode = .scaleAspectFit
            addMore.image = #imageLiteral(resourceName: "addCategory")
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.addCategory(sender:)))
            tap.numberOfTapsRequired = 1
            addMore.addGestureRecognizer(tap)
            addMore.isUserInteractionEnabled = true
            emoContainerView.addSubview(addMore)
            return
        }
        
        for emoObject in localCetegoriesArray {
            
            let imageView = UIImageView(frame: CGRect(x: origin, y: yOrigin, width: width, height: width))
            imageView.contentMode = .scaleAspectFit
            imageView.image = emoObject.image
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeCategory(sender:)))
            tap.numberOfTapsRequired = 1
            
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            
            emoContainerView.addSubview(imageView)
            origin += width + gap
        }
        
        if (!btnCast.isSelected && localCetegoriesArray.count < AppCategories.count) ||
            (btnCast.isSelected && localCetegoriesArray.count < AppCategories.count + 1){
            let addMore = UIImageView(frame: CGRect(x: origin, y: yOrigin, width: width, height: width))
            addMore.contentMode = .scaleAspectFit
            addMore.image = #imageLiteral(resourceName: "addCategory")
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.addCategory(sender:)))
            tap.numberOfTapsRequired = 1
            addMore.addGestureRecognizer(tap)
            addMore.isUserInteractionEnabled = true
            emoContainerView.addSubview(addMore)
        }
        
    }
    
    @objc func removeCategory(sender:UITapGestureRecognizer) {

        guard let image = (sender.view as? UIImageView)?.image else {
            return
        }
    
        let tempArray = selectedCategories
        selectedCategories.removeAll()
        tempArray.forEach { (emo) in
            if emo.image != image {
                selectedCategories.append(emo)
            }
            else if (emo is BestMotionPicture) {
                removePostCated()
            }
        }
        
        self.setEmos(selectedCategories)
    }
    
    @objc func addCategory(sender:UIImageView) {
        if let index = openCellIndex, (self.categoryTable.indexPathsForVisibleRows?.contains(index))!,
            index != self.getIndexPath() {
            delegate?.reloadPost(index)
        }
        
        openCellIndex = self.getIndexPath()
        categoryTable.isHidden = false
        categoryTable.reloadData()
        emoContainerView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func castAction(_ sender: Any) {
        guard let button = sender as? UIButton else{
            return
        }
            
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.backgroundColor = AppColors.JuanPurple
            button.borderWidth = 0
            castBtnWidthConstant.constant = 70
            lblMsgPopUp.isHidden = false
            lblMsgPopUp.text = "Successfully casted for Best Motion Picture"
            
            let check = selectedCategories.contains(where: { $0 is BestMotionPicture})
            if !check {
                selectedCategories.insert(BestMotionPicture(), at: 0)
            }
                        
            showSelectedCategory()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                
                self.lblMsgPopUp.alpha = 0
                UIView.transition(with: self.lblMsgPopUp, duration: 2, options: .transitionCrossDissolve, animations: nil, completion: { (isDone) in
                    self.lblMsgPopUp.isHidden = true
                    self.lblMsgPopUp.alpha = 1
                })
            }
            
        } else {
            
            selectedCategories.remove(at: 0)
            showSelectedCategory()
            button.backgroundColor = UIColor.white
            button.borderWidth = 1.5
            castBtnWidthConstant.constant = 60
            lblMsgPopUp.layer.removeAllAnimations()
            lblMsgPopUp.isHidden = true
            lblMsgPopUp.alpha = 1
        }
    }
    
    private func removePostCated () {
        btnCast.isSelected = false
        btnCast.backgroundColor = UIColor.white
        btnCast.borderWidth = 1.5
        castBtnWidthConstant.constant = 60
        lblMsgPopUp.layer.removeAllAnimations()
        lblMsgPopUp.isHidden = true
        lblMsgPopUp.alpha = 1
    }
    
    @IBAction func reportAction(_ sender: Any) {
        Singleton.shared.openActionSheet(SheetType.userPost, Info: nil) { (action) in
            
        }
    }
    
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        return superView.indexPath(for: self)
    }
    
    
    private func showSelectedCategory() {
       // setUp()
        setEmos(selectedCategories)
        categoryTable.reloadData()
        categoryTable.isHidden = true
        emoContainerView.isHidden = false
    }
    
}

extension PostsCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.categoryTableHeightConst.constant = CGFloat((35 * (pendingCategories.count + 1)))
        return pendingCategories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CastCellId") as! CastTableViewCell
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            
            if indexPath.row == 0 { //pendingCategories.count
                imageView.image = #imageLiteral(resourceName: "removeCategory")
            } else {
                let emoObject = pendingCategories[selectedIndex(indexpath: indexPath)]
                imageView.image = emoObject.image
            }
        }
        
        if let nameLabel = cell.viewWithTag(2) as? UILabel {
            
            if indexPath.row == 0 { //pendingCategories.count
                nameLabel.text = "Collapse"
                nameLabel.numberOfLines = 2
            } else {
                let emoObject = pendingCategories[selectedIndex(indexpath: indexPath)]
                nameLabel.text = emoObject.name
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cellSelected(sender:)))
        tap.numberOfTapsRequired = 1
        cell.contentView.addGestureRecognizer(tap)
        cell.contentView.isUserInteractionEnabled = true
        cell.contentView.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func cellSelected(sender: UITapGestureRecognizer?) {
        let buttonPosition: CGPoint = sender!.location(in: categoryTable)
        guard let indexPath = categoryTable?.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        if indexPath.row == 0 { //pendingCategories.count
            categoryTable.isHidden = true
            emoContainerView.isHidden = false
            return
        }
        
        let check = selectedCategories.contains(where: { $0 ===  pendingCategories[selectedIndex(indexpath: indexPath)]})
        if !check {
            selectedCategories.append(pendingCategories[selectedIndex(indexpath: indexPath)])
        }
        
        showSelectedCategory()
    }
    
}
