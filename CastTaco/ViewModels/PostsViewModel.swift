//
//  PostsViewModel.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

<<<<<<< HEAD

protocol PostsViewModelDelegate {
    func openUserProfile(_ uid: String)
}

class PostsViewModel: NSObject {

    var nvc:UINavigationController!
    private var tableView: UITableView?
    var delegate : PostsViewModelDelegate?
    
    func initController(nvc:UINavigationController) {
=======
class PostsViewModel: NSObject {

    var nvc:UINavigationController!
    
    func initController(nvc:UINavigationController)
    {
>>>>>>> origin/master
        self.nvc = nvc
    }
    
    func numberOfItems() -> Int {
<<<<<<< HEAD
      return 6
    }
    
    func cellForRow(at indexPath:IndexPath, tableView:UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCellId") as! PostsCell
        self.tableView = tableView
        cell.setUp()
        
        if indexPath.row == 0 {
            cell.setTopPadding(14)
        }
        
        cell.delegate = self
        cell.setEmos(selectedCategories)
        
        return cell
    }
    
    func willBeginEditingRowAt(at indexPath:IndexPath, tableView:UITableView) {
        
    }
    
    @objc func selected(sender:UITapGestureRecognizer) {
        
        guard let cell = sender.view?.superview?.superview as? PostsCell else {
            return
        }
        
        if let indexPath = self.tableView?.indexPath(for: cell) {
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
}

extension PostsViewModel : PostsCellDelegate {
    func reloadPost(_ indexpath: IndexPath) {
        self.tableView?.reloadRows(at: [indexpath], with: .automatic)
    }
    
    func openUserProfile(_ uid: String) {
        self.delegate?.openUserProfile(uid)
    }
    
    func closeCastTable(_ indexpath: IndexPath) {
//        guard (self.tableView?.indexPathsForVisibleRows?.contains(indexpath))!,
//        let cell = self.tableView?.cellForRow(at: indexpath) as? PostsCell
//            else {
//            return
//        }
//        cell.categoryTable.isHidden = true
//        cell.categoryTable.reloadData()
//        cell.emoContainerView.isHidden = true
=======
      return 4
    }
    
    func cellForRow(at indexPath:IndexPath, tableView:UITableView) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell") as! PostsCell
        return cell
    }

    func didSelectCell(at indexPath:IndexPath, tableView:UITableView)
    {
        let vc = OtherProfileVC.init(nibName: "OtherProfileVC", bundle: nil)
        self.nvc.pushViewController(vc, animated: true)
>>>>>>> origin/master
    }
    
}
