//
//  PostsVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

class PostsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var postsTable: UITableView!
    
    var viewModel = PostsViewModel()
    
    //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initController(nvc: self.navigationController!)
        let nib = UINib.init(nibName: "PostsCell", bundle: nil)
        postsTable.register(nib, forCellReuseIdentifier: "PostsCell")
    }

    //MARK:- Buttons Actions
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = FilterVC.init(nibName: "FilterVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        let vc = SearchVC.init(nibName: "SearchVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Table View methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(at: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath, tableView: tableView)
    }
    
    //MARK:- Memory Warning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

