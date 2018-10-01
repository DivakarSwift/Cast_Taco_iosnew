//
//  SearchVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit

protocol SearchVCDelegate {
    func openUserProfile(_ user: User?)
}

class SearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    
    var delegate:SearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "searchResultCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
    }

    @IBAction func backPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        txtField.becomeFirstResponder()
    }
    
}


extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! SearchTableViewCell
        cell.setup()
        cell.delegate = self
        
        if indexPath.row % 3 == 1 {
            cell.imgPlayBtn.alpha = 0.4
        } else {
            cell.imgPlayBtn.alpha = 1.0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
}

extension SearchVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = (txtField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if string == "\n"{
            tableView.isHidden = true
        } else {
            
            if newText.count > 0 {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}

extension SearchVC : SearchTableViewCellDelegate {
    func OpenUserProfile(_ user: User?) {
        delegate?.openUserProfile(user)
    }
    
}
