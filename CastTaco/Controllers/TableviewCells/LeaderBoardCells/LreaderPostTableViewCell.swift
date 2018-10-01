//
//  LreaderPostTableViewCell.swift
//  CastTaco
//
//  Created by brst on 10/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class LreaderPostTableViewCell: UITableViewCell {

     @IBOutlet weak var followButton: UIButton!
     @IBOutlet weak var userImageView: UIImageView!
     @IBOutlet weak var userLable: UILabel!
    
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var emoContainerView: UIView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnCast: UIButton!
    
    @IBOutlet weak var lblMsgPopUp: UILabel!
    
    @IBOutlet weak var imgSoundAction: UIImageView!
    
    private let allCategories = ["1","2","3","4"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp() {
        _ = emoContainerView.subviews.map({ $0.removeFromSuperview() })
        emoContainerView.isHidden = false
        categoryTable.isHidden = true
        lblMsgPopUp.isHidden = true
//        categoryTable.delegate = self
//        categoryTable.dataSource = self
        
        btnCast.backgroundColor = UIColor.white
        btnCast.borderWidth = 1
        btnCast.isSelected = false
        
    }
    
    func setEmos(_ cetegoriesArray:Array<String>) {
        var origin = 0
        let width = UIScreen.main.bounds.width > 320 ? 30 : 23
        let yOrigin = (Int(emoContainerView.frame.height) - width)/2
        for emo in cetegoriesArray {
            let imageView = UIImageView(frame: CGRect(x: origin, y: yOrigin, width: width, height: width))
            imageView.contentMode = .scaleAspectFit
            
            if emo == "1" { imageView.image = #imageLiteral(resourceName: "bestmotion") }
            else if emo == "2" { imageView.image = #imageLiteral(resourceName: "comedy") }
            else if emo == "3" { imageView.image = #imageLiteral(resourceName: "costume") }
            
            emoContainerView.addSubview(imageView)
            origin += width + 5
        }
        
        let addMore = UIImageView(frame: CGRect(x: origin, y: yOrigin, width: width, height: width))
        addMore.contentMode = .scaleAspectFit
        addMore.image = #imageLiteral(resourceName: "addCategory")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.addCategory(sender:)))
        tap.numberOfTapsRequired = 1
        addMore.addGestureRecognizer(tap)
        addMore.isUserInteractionEnabled = true
        emoContainerView.addSubview(addMore)
    }
    
    @objc func addCategory(sender:UIImageView){
        categoryTable.isHidden = false
        categoryTable.reloadData()
        emoContainerView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func castAction(_ sender: Any) {
        guard let button = sender as? UIButton else{
            return
        }
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.backgroundColor = AppColors.JuanPurple
            button.borderWidth = 0
            lblMsgPopUp.isHidden = false
            lblMsgPopUp.text = "Successfully caseted for Best Motion Picture"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               // self.lblMsgPopUp.isHidden = true
            }
        } else {
            button.backgroundColor = UIColor.white
            button.borderWidth = 1
        }
    }
    
    @IBAction func reportAction(_ sender: Any) {
        Singleton.shared.openActionSheet(SheetType.userPost, Info: nil) { (action) in
            
        }
    }
    
}

extension LreaderPostTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if let imageView = cell?.viewWithTag(1) as? UIImageView {
            
            if indexPath.row == allCategories.count {
                imageView.image = #imageLiteral(resourceName: "removeCategory")
            } else {
                let emo = allCategories[indexPath.row]
                if emo == "1" { imageView.image = #imageLiteral(resourceName: "bestmotion") }
                else if emo == "2" { imageView.image = #imageLiteral(resourceName: "comedy") }
                else if emo == "3" { imageView.image = #imageLiteral(resourceName: "costume") }
                else if emo == "4" { imageView.image =  #imageLiteral(resourceName: "sound")}
            }
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cellSelected(sender:)))
        tap.numberOfTapsRequired = 1
        cell?.contentView.addGestureRecognizer(tap)
        cell?.contentView.isUserInteractionEnabled = true
        
        return cell!
    }
    
    @objc func cellSelected(sender: UITapGestureRecognizer?) {
        let buttonPosition: CGPoint = sender!.location(in: categoryTable)
        let indexPath = categoryTable?.indexPathForRow(at: buttonPosition)
        
        categoryTable.isHidden = true
        emoContainerView.isHidden = false
    }
    

}
