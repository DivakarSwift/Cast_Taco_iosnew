//
//  FilterVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit



enum FilterType {
    case Sort
    case Reorder_Films
}

protocol FilterVCDelegate {
    func selectedFilter(_ name: String, index: Int)
}

class FilterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTItle: UILabel!
    var filtertype : FilterType?
    var delegate:FilterVCDelegate?
    var selectedFilter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        if filtertype == FilterType.Reorder_Films {
            lblTItle.text = "Reorder films"
        } else if filtertype == FilterType.Sort {
            lblTItle.text = "Sort by"
        }
    }

    @IBAction func backPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = AppColors.TacoPurple
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FilterVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let seprator = UILabel(frame: CGRect(x: 20, y: 59, width: tableView.frame.width - 40, height: 1))
        seprator.backgroundColor = UIColor.groupTableViewBackground
        cell?.contentView.addSubview(seprator)
        
        if indexPath.row == selectedFilter {
            cell?.contentView.backgroundColor = AppColors.LightBlue
        } else {
            cell?.contentView.backgroundColor = UIColor.white
        }
        
        cell?.textLabel?.font = UIFont(name: AppFont.medium, size: 16)
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.textColor = AppColors.GrayText
        
        if filtertype == FilterType.Reorder_Films {
            cell?.textLabel?.text = SortTypes[indexPath.row]
        } else if filtertype == FilterType.Sort {
            cell?.textLabel?.text = RankBy[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtertype == FilterType.Reorder_Films {
            return SortTypes.count
        } else if filtertype == FilterType.Sort {
            return RankBy.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedFilter = indexPath.row
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.popViewController(animated: true)
            
            defer {
                if self.filtertype == FilterType.Reorder_Films {
                    self.delegate?.selectedFilter("\(SortTypes[indexPath.row])", index: indexPath.row)
                } else if self.filtertype == FilterType.Sort {
                    self.delegate?.selectedFilter("\(RankBy[indexPath.row])", index: indexPath.row)
                }
            }
        }
        
        
        
      

    }
    
}
