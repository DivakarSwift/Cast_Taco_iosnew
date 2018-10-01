//
//  NextWeekChallengesViewModel.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class NextWeekChallengesViewModel: NSObject {
    
    func numberOfItems() -> Int {
        return 4
    }
    
    func cellForRow(at indexPath:IndexPath, tableView:UITableView) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell") as! PostsCell
        return cell
    }
    
    func didSelectCell(at indexPath:IndexPath, tableView:UITableView)
    {
        
    }
}
