//
//  PostsTableHeaderView.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 24/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol PostsTableHeaderViewDelegate {
    func sortDidSelected()
    func searchDidSelected()
}

class PostsTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lblChallengeName: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    
    var delegate:PostsTableHeaderViewDelegate?
    
    @IBAction func sortAction(_ sender: Any) {
        delegate?.sortDidSelected()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        delegate?.searchDidSelected()
    }

}
