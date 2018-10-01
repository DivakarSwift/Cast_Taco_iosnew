//
//  LiveStatsVC.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 09/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import  BetterSegmentedControl
import  ScrollableGraphView
import SwiftChart

class Emoticon {
    var tag: Int
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage, tag: Int) {
        self.image = image
        self.name = name
        self.tag = tag
    }
}

class LiveStatsVC: UIViewController {
    
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var otherUserImageView: UIImageView!
    @IBOutlet weak var statusGraph: UIImageView!
    @IBOutlet weak var segment: BetterSegmentedControl!
    @IBOutlet weak var lineView: ScrollableGraphView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var lblRanking: UILabel!
    @IBOutlet weak var lblCompareTxt: UILabel!
    @IBOutlet weak var lblSelectedCategory: UILabel!
    @IBOutlet weak var emosBackView: UIView!
    @IBOutlet weak var stackViewForGraphOptions: UIStackView!
    //    var imgViewsArray = [UIImageView]()
    //    var imgViewsNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otherUserImageView.isHidden = true
        vsLabel.isHidden = true
        
        //        lblCompareTxt.text = "Compare with a friend"
        
        segment.options = [.cornerRadius(17.0),
                           .backgroundColor(UIColor(red:0.16, green:0.64, blue:0.94, alpha:1.00)),
                           .indicatorViewBackgroundColor(.white)]
        segment.segments = LabelSegment.segments(withTitles: ["Acting status","Casting status"], normalBackgroundColor: UIColor.groupTableViewBackground, normalFont: UIFont(name: AppFont.medium, size: 14), normalTextColor: UIColor.lightGray, selectedBackgroundColor: UIColor.white, selectedFont: UIFont(name: AppFont.medium, size: 14), selectedTextColor: AppColors.GrayText)
        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        lblRanking.attributedText = currentRanking(122, increased: true, byValue: 20)
        
        // // self.setGraph()
        // self.addChart()
        
        self.addCategories(selected: BestMotionPicture())
        
        lblCompareTxt.addLine()
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.compareAction(value:)))
        tap2.numberOfTapsRequired = 1
        lblCompareTxt.isUserInteractionEnabled = true
        lblCompareTxt.addGestureRecognizer(tap2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(compareStatus), name: NSNotification.Name(rawValue: "compareStats"), object: nil)
    }
    
    @IBAction func btnSelectedToChangeGraph(_ sender: UIButton) {
        
        for i in 101..<105 {
            let btn = stackViewForGraphOptions.viewWithTag(i) as! UIButton
            btn.titleLabel?.font = UIFont.init(name: "TTNorms-Regular", size: 12.0)
            btn.alpha = 0.5
        }
        
        let btn = stackViewForGraphOptions.viewWithTag(sender.tag) as! UIButton
        btn.titleLabel?.font = UIFont.init(name: "TTNorms-Medium", size: 12.0)
        btn.alpha = 1.0
    }
    
    @objc func compareStatus() {
        
        statusGraph.image = UIImage.init(named: "Stats.png")
        otherUserImageView.isHidden = false
        vsLabel.isHidden = false
        vsLabel.text = " vs. You"
        
        lblCompareTxt.text = "Dale Cooper"
        lblCompareTxt.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        
        lblCompareTxt.addLine()
    }
    
    func addCategories(selected:Emoticon){
        
        var origin = 0 ; var index = 0
        let width = UIScreen.main.bounds.width > 320 ? 30 : 25
        
        emosBackView.subviews.forEach { (vv) in
            if vv.isKind(of: UIImageView.self) {
                vv.removeFromSuperview()
            }
        }
        
        for object in RankingCategories {
            
            let imageView = UIImageView(frame: CGRect(x: origin, y: 10, width: width, height: width))
            imageView.contentMode = .scaleAspectFit
            imageView.image = object.image
            imageView.tag = index
            
            if (object.name == selected.name) {
                imageView.alpha = 1
                lblSelectedCategory.text = object.name
            } else {
                imageView.alpha = 0.4
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.emoAction(value:)))
            tap.numberOfTapsRequired = 1
            
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            
            emosBackView.addSubview(imageView)
            //            imgViewsArray.append(imageView)
            //            imgViewsNameArray.append(object.name)
            
            origin += width + 8
            index += 1
            
        }
        
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func compareAction(value: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompareWithFriendVCId")
        let value = ["type": "Present", "ViewController" : vc] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addViewController"), object: value)
        
    }
    
    @objc func emoAction(value: UITapGestureRecognizer) {
        
        guard let xx = value.view?.tag else {
            return
        }
        
        self.addCategories(selected: RankingCategories[xx])
       
    }
    
    
    
    @objc func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            
        } else {
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addChart() {
        
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        chart.axesColor = UIColor.white
        chart.highlightLineColor = AppColors.JuanPurple
        chart.highlightLineWidth = 1
        chart.showYLabelsAndGrid = false
        chart.showXLabelsAndGrid = false
        chart.xLabelsFormatter = { index, value in
            if index == 0 {
                return "\(index + 1) DAY"
            } else {
                return "\(index + 1) DAYS"
            }
        }
        
        chart.labelFont = UIFont(name: AppFont.medium, size: 12)
        
        let series1 = ChartSeries([0, 6, 2, 8, 4])
        series1.area = false
        
        chart.add([series1])
        chartView.addSubview(chart)
        
    }
    
    func currentRanking(_ value: Int, increased:Bool, byValue: Int) -> NSAttributedString {
        
        let attrs1 = [NSAttributedStringKey.font : UIFont(name: AppFont.bold, size: 15), NSAttributedStringKey.foregroundColor : AppColors.GrayText]
        let attrs2 = [NSAttributedStringKey.font : UIFont(name: AppFont.bold, size: 35), NSAttributedStringKey.foregroundColor : AppColors.GrayText, .underlineColor : AppColors.GrayText ]
        let attrs3 = [NSAttributedStringKey.font : UIFont(name: AppFont.bold, size: 18), NSAttributedStringKey.foregroundColor : AppColors.Green, .underlineColor : AppColors.GrayText ]
        
        let attachment = NSTextAttachment()
        if increased {
            attachment.image = #imageLiteral(resourceName: "rankingup")
        } else {
            attachment.image = #imageLiteral(resourceName: "rankingdown")
        }
        
        attachment.bounds = CGRect(origin: CGPoint(x: -5, y: -2), size: CGSize(width: 12, height: 12))
        let attachmentString = NSAttributedString(attachment: attachment)
        
        let finalString = NSMutableAttributedString(string:"Ranking", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:" \(value) ", attributes:attrs2)
        let attributedString3 = NSMutableAttributedString(string:" \(byValue)", attributes:attrs3)
        
        finalString.append(attributedString2)
        finalString.append(attachmentString)
        finalString.append(attributedString3)
        
        return finalString
        
    }
    
    
    
}



extension LiveStatsVC : ChartDelegate {
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        for dataIndex in indexes {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                let value = chart.valueForSeries(0, atIndex: dataIndex)
            }
        }
    }
    
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
}










extension LiveStatsVC : ScrollableGraphViewDataSource {
    
    func setGraph() {
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        linePlot.lineColor = UIColor.blue
        linePlot.lineWidth = 2
        linePlot.fillType = .gradient
        
        let nm = [1,2,3,4]
        
        let referenceLines = ReferenceLines()
        referenceLines.shouldShowReferenceLines = false
        referenceLines.dataPointLabelColor = AppColors.GrayText
        referenceLines.referenceLineLabelFont = UIFont(name: AppFont.medium, size: 20)!
        referenceLines.referenceLinePosition = .both
        // referenceLines.shouldShowLabels = false
        
        lineView.dataSource = self
        lineView.addPlot(plot: linePlot)
        lineView.addReferenceLines(referenceLines: referenceLines)
        
        for index in nm {
            let lbl = UILabel(frame: CGRect(x: (index * 10) + 40, y: 10, width: 40, height: 50))
            lbl.backgroundColor = AppColors.GrayText
        }
        
        lineView.rangeMax = 1000
        lineView.rangeMin = 1
        lineView.leftmostPointPadding = 10
        lineView.rightmostPointPadding = 10
        lineView.showsVerticalScrollIndicator = false
        lineView.showsHorizontalScrollIndicator = false
        
    }
    
    
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            
            if pointIndex == 0 {
                return 1000
            } else if pointIndex == 1 {
                return 100
            } else if pointIndex == 2 {
                return 700
            }else if pointIndex == 3 {
                return 200
            }
            
            return Double(10 * pointIndex)
        default:
            return 0
        }
    }
    
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
        //        if pointIndex == 3 {
        //            return "ALL kjas kaj kjab "
        //        }
        //        return "\(pointIndex + 1) DAY"
    }
    
    func numberOfPoints() -> Int {
        return 4
    }
}
