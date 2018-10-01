//
//  NextWeekChallengesVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import ISPageControl

class NextWeekChallengesVC: UIViewController {
    
    @IBOutlet weak var descreptionTextView: UITextView!
    @IBOutlet weak var postViewtap: UIView!
    @IBOutlet weak var textViewDecription: UITextView!
    @IBOutlet weak var tableTopConstant: NSLayoutConstraint!
    @IBOutlet weak var tableTopConstWithMySuggestionView: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var lblFilterBy: UILabel!
    @IBOutlet weak var tableView: UITableView!
   // @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    
    private var newPageControl:ISPageControl!
    private var refreshControl: UIRefreshControl!
    private var viewModel = NextWeekChallengesViewModel()
    private var selectedFilter =  "1"
    private var placeholder = "Lorem ipsum dolore sit."
    private var capturedVideo: URL?
    
    //MARK:- view life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postViewtap.isHidden = true
        self.postButton.alpha = 0.6
        self.postButton.isUserInteractionEnabled = false
        
        lblUsername.text = DataManager.shared.Me?.username
        
        let nib = UINib.init(nibName: "SuggestionsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SuggestionsCell")
        
        let nib4 = UINib(nibName: "PlayVideoCell", bundle: nil)
        self.tableView?.register(nib4 , forCellReuseIdentifier: "PlayVideoCellId")
        
        tableView.contentInset = UIEdgeInsetsMake(-8, 0, 40, 0)
        
      //let nib3 = UINib.init(nibName: "MySuggestionsCollectionCell", bundle: nil)
      //collectionView.register(nib3, forCellWithReuseIdentifier: "MySuggestionsCell")
        
//      let nib2 = UINib.init(nibName: "suggestionVideoCell", bundle: nil)
//      tableView.register(nib2, forCellReuseIdentifier: "suggestionVideoCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.backPress(_:)), name: NSNotification.Name.init("moveToChallengeVC"), object: nil)
        
        
        refreshControl = UIRefreshControl()
       // refreshControl.tintColor = AppColors.TacoPurple
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(sender:)), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        

        
        viewModel.delegate = self
        
        viewModel.getChallengeSuggetions(filter: selectedFilter, page: "1")
       // viewModel.getMySuggetions(page: "1")
        viewModel.reloadSuggetions = { [weak self] model in
//            if model.mySuggestions.count > 0 {
//                self?.showMySuggestion()
//            } else {
//                self?.showAddSuggestionOption()
//            }
            self?.tableView.reloadData()
        }
        
        
        self.lblNotification.layer.shadowColor = AppColors.GrayTint3.cgColor
        self.lblNotification.layer.shadowOpacity = 0.4
        self.lblNotification.layer.shadowOffset = CGSize.zero
        self.lblNotification.layer.shadowRadius = 3
        self.lblNotification.layer.masksToBounds = false
        
        self.lblNotification.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
//        if self.postViewtap.isHidden {
//            tableTopConstant.isActive = true
//            tableTopConstWithMySuggestionView.isActive = false
//            tableTopConstant.constant = 22
//        } else {
//            tableTopConstWithMySuggestionView.isActive = true
//            tableTopConstant.isActive = false
//            tableTopConstWithMySuggestionView.constant = 0
//        }
        
        self.textViewDecription.addInnerShadow(edges: [.Top, .Left], removePrevious: true, radius: 3, color: AppColors.GrayTint3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.descreptionTextView.resignFirstResponder()
    }
    
    //MARK:- Memory Warning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Buttons Actions
    @IBAction func filterAction(_ sender: UIButton) {
        let filterVC = FilterVC.init(nibName: "FilterVC", bundle: nil)
        filterVC.filtertype = FilterType.Sort
        filterVC.delegate = self
        if let filterIndex = Int(self.selectedFilter) {
            filterVC.selectedFilter = filterIndex - 1
        }
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        viewModel.deAllocate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postSuggestionAction(_ sender: UIButton) {
        
        Singleton.shared.showAlert(title: "Would you like to add video?", message: "You can add video in your suggestion too.", firstAction: "Yes", secondAction: "No", firstCallBack: {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraVCId") as! CustomCameraVC
            vc.delegate = self
            vc.topTitle = "Capture Suggestion"
            self.navigationController?.present(vc, animated: true, completion: nil)
        }, secondCallBack: {
            self.submitSuggestion()
        })
        
    }
    
//    @IBAction func writePostAction(_ sender: UIButton) {
//         self.showAddSuggestionOption()
//    }
    
//    @IBAction func showMySuggestionsAction(_ sender: UIButton) {
//        self.showMySuggestion()
//    }
    
    //MARK:- Private Methods
    
    @objc func refreshControlAction(sender:UIRefreshControl) {
        
        viewModel.getChallengeSuggetions(filter: selectedFilter, page: "1")
       // viewModel.getMySuggetions(page: "1")
        refreshControl.endRefreshing()
    }
    
//    private func showMySuggestion() {
//        self.postViewtap.isHidden = false
//        self.textViewDecription.resignFirstResponder()
//
//        self.tableTopConstWithMySuggestionView.isActive = true
//        self.tableTopConstant.isActive = false
//        self.tableTopConstWithMySuggestionView.constant = 0
//        //self.collectionView.reloadData()
//
//        self.view.layoutIfNeeded()
//    }
    
    private func showAddSuggestionOption() {
        postViewtap.isHidden = true
        textViewDecription.resignFirstResponder()
        
        self.descreptionTextView.text = placeholder
        self.descreptionTextView.textColor = UIColor.lightGray
        self.postButton.isUserInteractionEnabled = false
        self.postButton.alpha = 0.6
        
       // tableTopConstant.isActive = true
        //tableTopConstWithMySuggestionView.isActive = false
       // tableTopConstant.constant = 22
        
        self.view.layoutIfNeeded()
    }
    
    
    private func submitSuggestion () {
        let description = self.descreptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        postButton.isUserInteractionEnabled = false
        viewModel.submitSuggestion(video: capturedVideo, suggestion: description, firstResponse: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.showAddSuggestionOption()
            }
        }) {
            self.lblNotification.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                self.lblNotification.alpha = 0
                UIView.transition(with: self.lblNotification, duration: 2, options: .transitionCrossDissolve, animations: nil, completion: { (isDone) in
                    self.lblNotification.isHidden = true
                    self.lblNotification.alpha = 1
                })
            }
            
            if self.selectedFilter == "3" {
                self.viewModel.getChallengeSuggetions(filter: self.selectedFilter, page: "1")
            }
        }
    }
    
    
 }

extension NextWeekChallengesVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.descreptionTextView.text = descreptionTextView.text == placeholder ? "" : descreptionTextView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if text == "\n" {
            if newText == "\n" {
                self.descreptionTextView.text = placeholder
                self.descreptionTextView.textColor = UIColor.lightGray
                self.postButton.isUserInteractionEnabled = false
                self.postButton.alpha = 0.6
            }
            textView.endEditing(true)
            return false
            
        } else {
            
            guard newText != "" else {
                self.descreptionTextView.text = placeholder
                self.descreptionTextView.textColor = UIColor.lightGray
                self.postButton.isUserInteractionEnabled = false
                self.postButton.alpha = 0.6
                textView.endEditing(true)
                return false
            }
            
            guard newText.count < 60 else {
                return false
            }
            
            self.descreptionTextView.textColor = AppColors.GrayText
            self.postButton.isUserInteractionEnabled = true
            self.postButton.alpha = 1
            
            return true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}


extension NextWeekChallengesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.numberOfItems()
        if numberOfRows > 0 {
            tableView.backgroundColor = .white
        } else {
            tableView.backgroundColor = .clear
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            return viewModel.cellForRow(at: indexPath, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath, tableView: tableView)
    }
}

/*
extension NextWeekChallengesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = viewModel.numberOfMySuggestion()
      //self.newPageControl.numberOfPages = items
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.itemForMySuggestions(collectionView: collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //  self.newPageControl.currentPage = indexPath.row
    }

}*/

extension NextWeekChallengesVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UITableView {
            viewModel.tableScrollViewDidEndDecelerating(scrollView, filter: selectedFilter)
        } else if let _ = scrollView as? UICollectionView {
           // viewModel.collectionScrollViewDidEndDecelerating(scrollView)
        }
    }
}

extension NextWeekChallengesVC: FilterVCDelegate {
    func selectedFilter(_ name: String, index: Int) {
        lblFilterBy.text = name
        selectedFilter = "\(index + 1)"
        viewModel.getChallengeSuggetions(filter: selectedFilter, page: "1")
        
        /* if index == 2 {
            viewModel.getMySuggetions(page: "1")
        } else {
            viewModel.getChallengeSuggetions(filter: selectedFilter, page: "1")
        }*/
    }
}

extension NextWeekChallengesVC : NextWeekChallengesViewModelDelegate {
    func OpenUserProfile() {
        (self.tabBarController as? TabbarVC)?.pushUserProfile(self, tabbarIndex: 1, selectedUser: User4)
    }
}

extension NextWeekChallengesVC : CustomCameraVCDelegate {
    func videoDidCaptured(videoUrl: URL?) {
        self.capturedVideo = videoUrl
        self.submitSuggestion()
    }
    
    @objc func willDismissed(videoUrl: URL?) {
        
    }
    
    func didDismissed(videoUrl: URL?) {
        
    }
    
}
