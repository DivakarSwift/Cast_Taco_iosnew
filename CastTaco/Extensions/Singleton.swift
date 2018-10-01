//
//  Singleton.swift
//  OneSecond
//
//  Created by Mrinal Khullar on 23/05/18.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit
import PhotosUI
import AssetsLibrary
import AVFoundation
import Photos
import NVActivityIndicatorView

var PublicLocation:String?

enum QUWatermarkPosition {
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
    case Default
}

class Singleton: NSObject {
    
    var loader: NVActivityIndicatorView?
    
/*
    var hud = JGProgressHUD(style: .dark)
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    var  cancelProcessBlock:(()->())?
    var  interstitialDidDismiss:(()->())?
    
    private var product_id : NSString = ""
    private let testDevicesAds = ["7e8d3f34aadb60f4ce9318c52b3c4fcc","19a425960481279834582b1f7ffce122","e22dec9599238121fcf53ec3958e2665","820b73b5558ebebc9c3983fbe4e4e499"]
    
*/
    
    static var shared:Singleton = {
        return Singleton()
    }()
    
    
    
    // -------------------------------------------------------------------------------------- */
    // MARK: Loader
    
    
    func showLoader(_ on: UIViewController? = nil) {
        loader = NVActivityIndicatorView(frame: UIScreen.main.bounds, type: .ballRotateChase, color: AppColors.TacoPurple)
        loader?.backgroundColor = .white
        loader?.alpha = 0.5
    
        loader?.padding = UIScreen.main.bounds.width/2 - 25
        if let VC = on {
            VC.view.addSubview(loader!)
        } else {
            self.topViewController()?.view.addSubview(loader!)
        }
        
        loader?.startAnimating()
        
    }
    
    func hideLoader() {
        loader?.stopAnimating()
        loader?.removeFromSuperview()
        sleep(1)
    }
    
    
    // -------------------------------------------------------------------------------------- */
    // MARK: Alert
    
    func showAlert(_ from:UIViewController? = nil, title:String, message:String, firstAction:String = "Ok", secondAction:String? = "", firstCallBack:(()->())? = nil, secondCallBack:(()->())? = nil) {
        
        let modalController = AppAlertController(nibName: "AppAlertController", bundle: nil)
        modalController.titleString = title
        modalController.descriptionString = message
        modalController.firstBtnTitle = firstAction
        modalController.secondBtnTitle = secondAction
        modalController.modalPresentationStyle = .overCurrentContext
        modalController.callBackCancel = {
            if let callBack = firstCallBack {
                callBack()
            }
        }
        
        modalController.callBackSecondAction = {
            if let callBack = secondCallBack {
                callBack()
            }
        }
        
        if from != nil {
            from?.present(modalController, animated: false, completion: nil)
        } else if let viewController = self.topViewController() {
            viewController.present(modalController, animated: false, completion: nil)
        }
        
        return
        
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(cancel)
//        self.topViewController()?.present(alertController, animated: true, completion: nil)
    }
   
    // -------------------------------------------------------------------------------------- */
    // MARK: Betting
    
     func setBet(_ onUser: User?, forCatgory: BetType,  _ forRank: Int) {
        
        let userOnBet = UserOnBet.init(rank: forRank, user: onUser)
        usersOnBet = usersOnBet.filter({ $0.category != forCatgory || ($0.bettedUser?.user !== onUser &&  $0.bettedUser?.rank != forRank) })
        usersOnBet.append(Bet(category: forCatgory, userinfo: userOnBet))
    }
    
     func removeBet (_ forCatgory: BetType, forRank: Int) {
        usersOnBet = usersOnBet.filter({ $0.category != forCatgory || $0.bettedUser?.rank != forRank })
    }
    
     func isUserOnBet(_ forCatgory: BetType, forRank:Int) ->Bool {
        return usersOnBet.filter({ $0.category == forCatgory && $0.bettedUser?.rank == forRank }).count > 0
    }
    
    
// -------------------------------------------------------------------------------------- */
// MARK: Action Sheets
    
    func sharePost() {
        
        let modalController = ActionSheetViewController()
        modalController.modalPresentationStyle = .overCurrentContext
        modalController.sheetFor = SheetType.myPost
        topViewController()?.present(modalController, animated: true, completion: {
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            modalController.changeBackGround(UIColor.black, opacity: 0.5)
        }
        
        return
    }
    
    
    func openActionSheet(_ type: SheetType, Info: [String:Any]?, completion: @escaping(ActionSheetCompletionHandler)->()) {
        
        let modalController = ActionSheetViewController()
        modalController.modalPresentationStyle = .overCurrentContext
        modalController.sheetFor = type
        modalController.info = Info
        modalController.alertActionCompletion =  { handler in
            completion(handler)
        }
        
        topViewController()?.present(modalController, animated: true, completion: {
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            modalController.changeBackGround(UIColor.black, opacity: 0.5)
        }
        
        return
        
        
        /*
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let attributted1 = NSAttributedString(string: "Unfollow username", attributes: [NSAttributedStringKey.foregroundColor : AppColors.JuanPurple, .font : UIFont(name: AppFont.regular, size: 16)!])
            
            let attributted2 = NSAttributedString(string: "Inappropriate. \"Watch out Mr. Taco!\" ", attributes: [.font : UIFont(name: AppFont.regular, size: 16)!])
            
            let attributted3 = NSAttributedString(string: "Never mind", attributes: [NSAttributedStringKey.foregroundColor : AppColors.JuanPurple, .font : UIFont(name: AppFont.regular, size: 16)!])
            
            let action1 = UIAlertAction(title: "", style: .default) { (action) in
                
            }
            
            let action2 = UIAlertAction(title: "", style: .destructive) { (action) in
                
            }
            
            let action3 = UIAlertAction(title: "", style: .cancel) { (action) in
                
            }
            
            // controller.view.tintColor = UIColor.white
            
            controller.addAction(action1)
            controller.addAction(action2)
            controller.addAction(action3)
            
            topViewController()?.present(controller, animated: true, completion: nil)
            
            guard let label = (action1.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            label.attributedText = attributted1
            
            guard let label2 = (action2.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            label2.attributedText = attributted2
            
            guard let label3 = (action3.value(forKey: "__representer") as AnyObject).value(forKey: "label") as? UILabel else { return }
            label3.attributedText = attributted3
        
         */
        
         
    }
    
    
    // -------------------------------------------------------------------------------------- */
    // MARK: Others
    
    
    func termsConditionString() -> NSMutableAttributedString {
        let attrs1 = [NSAttributedStringKey.font : UIFont(name: AppFont.medium, size: 13), NSAttributedStringKey.foregroundColor : AppColors.GrayText]
        let attrs2 = [NSAttributedStringKey.font : UIFont(name: AppFont.medium, size: 14), NSAttributedStringKey.foregroundColor : AppColors.GrayText, .underlineColor : AppColors.GrayText ]
        
        let attributedString1 = NSMutableAttributedString(string:"By continuing you indicate that you've read \n and agree to our ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Terms of services", attributes:attrs2)
        
        attributedString2.addAttribute(NSAttributedStringKey.underlineStyle,
                                       value: NSUnderlineStyle.styleThick.rawValue,
                                       range: NSRange(location: 0, length: attributedString2.length))
        
        attributedString2.addAttribute(NSAttributedStringKey.underlineColor,
                                       value: AppColors.GrayTint1,
                                       range: NSRange(location: 0, length: attributedString2.length))
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
    
     func topViewController() -> UIViewController? {
        
        let base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        if let nav = base as? UINavigationController {
            return nav.visibleViewController
        }
        
        if let tab = base as? UITabBarController {
            return tab
//            if let selected = tab.selectedViewController {
//                if let nav = selected as? UINavigationController {
//                    return nav.visibleViewController
//                } else {
//                    return selected
//                }
//            }
        }
        
        if let presented = base?.presentedViewController {
            return presented
        }
        return base
        
    }
    
    
    func manageCroppingToSquare(filePath: URL, cameraPosition: CameraPosition, completion: @escaping (_ outputURL : URL?) -> ()) {
        
        // output file
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let outputPath = documentsURL?.appendingPathComponent("squareVideo.mov")
        
        if FileManager.default.fileExists(atPath: (outputPath?.path)!) {
            do {
                try FileManager.default.removeItem(atPath: (outputPath?.path)!)
            }
            catch {
                print ("Error deleting file")
            }
        }
        
        //input file
        let asset = AVAsset.init(url: filePath)
        print (asset)
        let composition = AVMutableComposition.init()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        //input clip
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        //make it square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: CGFloat(clipVideoTrack.naturalSize.height), height: CGFloat(clipVideoTrack.naturalSize.height))
        videoComposition.frameDuration = CMTimeMake(1, 30)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        //rotate to potrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        if cameraPosition == .front {
            var transform:CGAffineTransform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.translatedBy(x: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            transform = transform.rotated(by: .pi/2)
            transform = transform.translatedBy(x: 0.0, y: clipVideoTrack.naturalSize.height)
            transformer.setTransform(transform, at: kCMTimeZero)
            
        } else {
            var transform = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            transform = transform.rotated(by: .pi/2)
            
            transformer.setTransform(transform, at: kCMTimeZero)
        }
        
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        //exporter
        let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter?.outputFileType = AVFileType.mp4
        exporter?.outputURL = outputPath
        exporter?.videoComposition = videoComposition
        exporter?.exportAsynchronously(completionHandler: {
            if exporter?.status == .completed {
                //print("Export complete")
                DispatchQueue.main.async(execute: {
                    completion(outputPath)
                })
                return
            } else if exporter?.status == .failed {
                //print("Export failed - \(String(describing: exporter?.error))")
            }
            completion(nil)
            return
        })
    }
    
    
    
    
    /*
     func showProgressView(text:String){
     hud = JGProgressHUD(style: .dark)
     hud.textLabel.text = text
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(tapCancel(tap:)))
     hud.detailTextLabel.addGestureRecognizer(tap)
     hud.detailTextLabel.isUserInteractionEnabled = true
     
     hud.show(in: (self.topViewController()?.view)!)
     }
     
     func changeProgressText(text:String) {
     DispatchQueue.main.async {
     self.hud.textLabel.text = text
     }
     }
     
     func showProgressPercentage(text:String) {
     hud.indicatorView = JGProgressHUDPieIndicatorView()
     hud.textLabel.text = text
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(tapCancel(tap:)))
     hud.detailTextLabel.addGestureRecognizer(tap)
     hud.detailTextLabel.isUserInteractionEnabled = true
     
     hud.progress = 0.0
     hud.vibrancyEnabled = false
     hud.show(in: (self.topViewController()?.view)!)
     }
     
     @objc func tapCancel(tap: UITapGestureRecognizer) {
     guard let range = hud.detailTextLabel.text?.range(of: "Cancel")?.nsRange else {
     return
     }
     
     if tap.didTapAttributedTextInLabel(label: hud.detailTextLabel, inRange: range) {
     cancelProcessBlock?()
     }
     }
     
     func incrementDownloading(value:Float){
     DispatchQueue.main.async {
     self.hud.progress = value/100
     
     let str = String(format: "%.0f", value) + " % Completed \n\n Cancel"
     let range = (str as NSString).range(of: "Cancel")
     let attribute = NSMutableAttributedString(string: str)
     attribute.addAttribute(NSAttributedStringKey.font, value:appFont.AmericanTypewriter_Bold!, range: range)
     attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: range)
     
     self.hud.detailTextLabel.attributedText = attribute
     }
     }
     
     func hideProgressView(){
     DispatchQueue.main.async() {
     self.changeProgressText(text:"")
     self.hud.dismiss(animated: true)
     }
     }
     
     func hideProgressViewWithSuccess(){
     DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
     UIView.animate(withDuration: 0.1, animations: {
     self.hud.textLabel.text = "Success"
     self.hud.detailTextLabel.text = nil
     self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
     })
     
     self.hud.dismiss(afterDelay: 1.0)
     
     //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
     //                self.showHUDWithTransform()
     //            }
     }
     }
     
     
     func showHUDWithTransform() {
     let hud = JGProgressHUD(style: .light)
     hud.vibrancyEnabled = true
     hud.textLabel.text = "Loading"
     hud.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
     hud.show(in: (self.topViewController()?.view)!)
     
     DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
     UIView.animate(withDuration: 0.3) {
     hud.indicatorView = nil
     hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
     hud.textLabel.text = "Done"
     hud.position = .bottomCenter
     }
     }
     
     hud.dismiss(afterDelay: 4.0)
     
     //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
     //            self.showSimpleHUD()
     //        }
     }
     
     */
    
    // -------------------------------------------------------------------------------------- */
    // MARK: Rating
    /*
     
     func rateTheApp() {
     
     let controller = UIAlertController(title: "Rate One Second", message: "To add unlimited clips to your video for FREE please leave a 5 star written review.", preferredStyle: .alert)
     
     let rateNow = UIAlertAction(title: "Rate Now", style: .cancel) { (rateAction) in
     DataManager.shared.applicationRated = true
     self.showRatePopUp()
     }
     
     let later = UIAlertAction(title: "Maybe Later", style: .default) { (laterAction) in
     
     }
     
     controller.addAction(rateNow)
     controller.addAction(later)
     
     self.topViewController()?.present(controller, animated: true, completion: nil)
     
     }
     
     
     func showRatePopUp() {
     if #available(iOS 10.3, *) {
     SKStoreReviewController.requestReview()
     } else {
     self.rateApp { (done) in
     }
     }
     }
     
     
     private func rateApp(completion: @escaping ((_ success: Bool)->())) {
     // itms-apps://itunes.apple.com/app/id1079309759   Fast And Easy
     guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1383226753") else {
     completion(false)
     return
     }
     
     guard #available(iOS 10, *) else {
     completion(UIApplication.shared.openURL(url))
     return
     }
     UIApplication.shared.open(url, options: [:], completionHandler: completion)
     }
     */
    
    // -------------------------------------------------------------------------------------- */
    // MARK: Ads
    
    /*
     func ShowAds() {
     
     guard !DataManager.shared.AdsRemoved else {
     self.bannerView = nil
     return
     }
     
     guard bannerView == nil else {
     return
     }
     
     bannerView = GADBannerView(adSize: kGADAdSizeBanner)
     bannerView.adUnitID = bannerId
     bannerView.rootViewController = UIApplication.shared.keyWindow?.rootViewController
     bannerView.delegate = self
     let request = GADRequest()
     request.testDevices = testDevicesAds
     bannerView.load(request)
     bannerView.translatesAutoresizingMaskIntoConstraints = true
     
     if let window = UIApplication.shared.keyWindow {
     bannerView.frame.origin.y = window.frame.maxY - 50
     bannerView.center.x = window.center.x
     window.addSubview(bannerView)
     }
     
     // return bannerView
     }
     
     func showInterstitialAds(_ from: UIViewController) -> Bool {
     guard !DataManager.shared.AdsRemoved else {
     return false
     }
     
     if interstitial.isReady {
     interstitial.present(fromRootViewController: from)
     return true
     } else {
     loadInterstitial()
     return false
     }
     }
     
     func loadInterstitial() {
     guard !DataManager.shared.AdsRemoved else {
     return
     }
     
     interstitial = GADInterstitial(adUnitID: interstitialId) //"ca-app-pub-3940256099942544/4411468910"
     
     let request = GADRequest()
     request.testDevices = testDevicesAds
     interstitial.load(request)
     interstitial.delegate = self
     }
     
     func removeAds() {
     
     for subView in (UIApplication.shared.keyWindow?.subviews)! {
     if subView is GADBannerView {
     subView.removeFromSuperview()
     }
     }
     
     guard bannerView != nil else {
     return
     }
     
     bannerView.removeFromSuperview()
     bannerView = nil
     }
     
     func hideBannerAds() {
     for subView in (UIApplication.shared.keyWindow?.subviews)! {
     if subView is GADBannerView {
     subView.isHidden = true
     }
     }
     }
     
     func unhideBannerAds() {
     for subView in (UIApplication.shared.keyWindow?.subviews)! {
     if subView is GADBannerView {
     subView.isHidden = false
     }
     }
     }
     
     
     */
    
    
    
    
    /*
    func parseLocationInfo(_ currenctLocation:CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currenctLocation) { [weak self] placeMarks, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if let placeMark = placeMarks?.first {
                
                var placeString = ""
                if let cityName = placeMark.administrativeArea {
                    placeString += cityName
                }
                
                if let country = placeMark.country {
                    placeString += ", \(country)"
                }
        
                PublicLocation = placeString
            }
        }
    }
    
    
    
    func checkPhotoAuthorization(viewController:UIViewController)  {
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            let picker = UIImagePickerController()
            picker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            //  picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = ["public.image", "public.movie"]
            viewController.present(picker, animated: true, completion: nil)
        }
        else if status == .denied {
            DispatchQueue.main.async(execute: {() -> Void in
                self.accessMethod("Please go to Settings and enable the photos for this app to use this feature.")
            })
        } else if status == .notDetermined {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({(_ status: PHAuthorizationStatus) -> Void in
                
                if status == .authorized {
                    DispatchQueue.main.async(execute: {() -> Void in
                        let picker = UIImagePickerController()
                        picker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        // picker.allowsEditing = true
                        picker.sourceType = .photoLibrary
                        picker.mediaTypes = ["public.image", "public.movie"]
                        //picker.videoMaximumDuration = 15
                        viewController.present(picker, animated: true, completion: nil)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.accessMethod("Please go to Settings and enable the photos for this app to use this feature.")
                    })
                }
            })
        }
        else if status == .restricted {
            // Restricted access - normally won't happen.
        }
        
    }
    
    private func accessMethod(_ message: String) {
        let alertController = UIAlertController(title: "Not Authorized", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
        let Settings = UIAlertAction(title: "Settings", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        })
        alertController.addAction(Settings)
        alertController.addAction(cancel)
        self.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    func topBarHeight(_ viewController: UIViewController?) -> Int {
        guard let controller = viewController, controller.prefersStatusBarHidden else {
            return 78
        }
        return 58
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func getThumbnailFrom(fromTime:Float64 ,path: URL, completion:@escaping(UIImage?)->()) {
        let asset = AVURLAsset(url: path , options: nil)
        let composition = AVVideoComposition(propertiesOf: asset)
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, composition.frameDuration.timescale)
        VideoThumbnail.generateAsyncronously(time, videoAsset: asset) { (image) in
            completion(image)
        }
        
        
       /*
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            imgGenerator.requestedTimeToleranceAfter = kCMTimeZero
            imgGenerator.requestedTimeToleranceBefore = kCMTimeZero
            
            let composition = AVVideoComposition(propertiesOf: asset)
            let time:CMTime = CMTimeMakeWithSeconds(fromTime, composition.frameDuration.timescale)
            
            let cgImage:CGImage?
            
            do {
                cgImage = try imgGenerator.copyCGImage(at:time, actualTime:nil)
            } catch {
                cgImage = nil
            }
            
            guard let img:CGImage = cgImage else {
                return nil
            }
            
            let frameImg:UIImage = UIImage(cgImage:img)
            return frameImg
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
        */
    }
    
    */
// -------------------------------------------------------------------------------------- */
// MARK: Local Notification
    
     /*
    func setReminderNotification(identifier:String) {
        let content = UNMutableNotificationContent()
        content.title = "Time to record a video!"
        content.body = "Capture a great moment today!"
        content.categoryIdentifier = "OneSecond.reminder.6PM"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 00
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        clearReminderNotification(identifiers: [LocalNotificationID.reminder])
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error in pizza reminder: \(error.localizedDescription)")
            }
        }
        print("added notification:\(request.identifier)")
    }
    
    func clearReminderNotification(identifiers:Array<String>) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}

extension Singleton:GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        self.bannerView = nil
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

extension Singleton: GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        hideBannerAds()
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        interstitialDidDismiss?()
        loadInterstitial()
        unhideBannerAds()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
}



extension Singleton:SKRequestDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        
    }
    
    func restoreProducts() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts(_ productId:NSString) {
        SKPaymentQueue.default().add(self)
        
        if (SKPaymentQueue.canMakePayments()) {
            
            self.showActivityIndi()
            self.product_id = productId
            
            let productID:NSSet = NSSet(array: [self.product_id as NSString]);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
            
        } else {
            print("can't make purchases");
        }
    }
    
    private func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
    }
    
    // SKProductRequest Delegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print(response.products)
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id as String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                self.buyProduct(product: validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                
                var productsTypes = Array<NSString>()
               
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    let t: SKPaymentTransaction = trans
                    let prodID = t.payment.productIdentifier as NSString
                    
                    switch prodID {
                    case InAppProducts.Unlock4kSec:
                        DataManager.shared.is4kVideoUnlocked = true
                        productsTypes.append(InAppProducts.Unlock4kSec)
                        print("Unlock4KSecAction restored")
                        break
                    case InAppProducts.GetEvery:
                        DataManager.shared.isGetEveryUnlocked = true
                        DataManager.shared.AdsRemoved = true
                        DataManager.shared.isWatermarkRemoved = true
                        DataManager.shared.isMusicUnlocked = true
                        DataManager.shared.isClipsUnlocked = true
                        DataManager.shared.is4kVideoUnlocked = true
                        productsTypes.append(InAppProducts.GetEvery)
                        print("1Sec_GetEvery restored")
                        break
                    case InAppProducts.RemoveAds:
                        DataManager.shared.AdsRemoved = true
                        productsTypes.append(InAppProducts.RemoveAds)
                        print("RemoveAds restored")
                        break
                    case InAppProducts.RemoveWatermark:
                        DataManager.shared.isWatermarkRemoved = true
                        productsTypes.append(InAppProducts.RemoveWatermark)
                        print("RemoveWatermark restored")
                        break
                    case InAppProducts.OneSecUnlockMusic:
                        DataManager.shared.isMusicUnlocked = true
                        productsTypes.append(InAppProducts.OneSecUnlockMusic)
                        print("OneSecUnlockMusic restored")
                        break
                    case InAppProducts.UnlockClips:
                        DataManager.shared.isClipsUnlocked = true
                        productsTypes.append(InAppProducts.UnlockClips)
                        print("UnlockClips restored")
                        break
                    default:
                        print("iap not found")
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PurchaseSuccess"), object: nil, userInfo: ["purchased":productsTypes])
                    
                    break;
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    Singleton.shared.showAlert(title: (trans.error?.localizedDescription)!, message: "Please check your apple account.")
                    break;
                case .restored:
                    print("Already Purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break;
                }
                
                hideActivityIndi()
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        var restored = Bool()
        var productsTypes = Array<NSString>()

        for transaction in queue.transactions {
            
            if transaction.transactionState == SKPaymentTransactionState.restored {
                let t: SKPaymentTransaction = transaction
                let prodID = t.payment.productIdentifier as NSString
                
                switch prodID {
                case InAppProducts.Unlock4kSec:
                    DataManager.shared.is4kVideoUnlocked = true
                    print("Unlock4KSecAction restored")
                    productsTypes.append(InAppProducts.Unlock4kSec)
                    restored = true
                    break
                case InAppProducts.GetEvery:
                    DataManager.shared.isGetEveryUnlocked = true
                    DataManager.shared.isGetEveryUnlocked = true
                    DataManager.shared.AdsRemoved = true
                    DataManager.shared.isWatermarkRemoved = true
                    DataManager.shared.isMusicUnlocked = true
                    DataManager.shared.isClipsUnlocked = true
                    DataManager.shared.is4kVideoUnlocked = true
                    restored = true
                    productsTypes.append(InAppProducts.GetEvery)
                    break
                case InAppProducts.RemoveAds:
                    DataManager.shared.AdsRemoved = true
                    print("RemoveAds restored")
                    restored = true
                    productsTypes.append(InAppProducts.RemoveAds)
                    break
                case InAppProducts.RemoveWatermark:
                    DataManager.shared.isWatermarkRemoved = true
                    print("RemoveWatermark restored")
                    restored = true
                    productsTypes.append(InAppProducts.RemoveWatermark)
                    break
                case InAppProducts.OneSecUnlockMusic:
                    DataManager.shared.isMusicUnlocked = true
                    print("OneSecUnlockMusic restored")
                    productsTypes.append(InAppProducts.OneSecUnlockMusic)
                    restored = true
                    break
                case InAppProducts.UnlockClips:
                    DataManager.shared.isClipsUnlocked = true
                    print("UnlockClips restored")
                    productsTypes.append(InAppProducts.UnlockClips)
                    restored = true
                    break
                default:
                    print("iap not found")
                    restored = false
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PurchaseSuccess"), object: nil, userInfo: ["purchased":productsTypes])
            }
        }
        
        if restored == true {
            Singleton.shared.showAlert(title: "Success", message: "Your all purchased products have been restored.")
        }
    }
    
    func requestDidFinish(_ request: SKRequest) {
        hideActivityIndi()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        hideActivityIndi()
        Singleton.shared.showAlert(title: "Request Failed", message: error.localizedDescription)
    }
    
    private func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        for transaction:SKPaymentTransaction  in queue.transactions {
            if transaction.transactionState == SKPaymentTransactionState.restored {
                SKPaymentQueue.default().finishTransaction(transaction)
                hideActivityIndi()
                break
            }
        }
        hideActivityIndi()
    }
    
    private func showActivityIndi() {
        DispatchQueue.main.async {
            Singleton.shared.showProgressView(text: "Loading")
        }
    }
    
    private func hideActivityIndi() {
        DispatchQueue.main.async {
            Singleton.shared.hideProgressView()
        }
    }
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
 */
}
