//
//  CustomCameraVC.swift
//  CastTaco
//
//  Created by brst on 8/2/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import PhotosUI

@objc protocol CustomCameraVCDelegate {
    func didDismissed(videoUrl: URL?)
    @objc optional func willDismissed(videoUrl: URL?)
    func videoDidCaptured(videoUrl: URL?)
}

class CustomCameraVC: UIViewController {
    
    var coverView = UIView()
//  var popUpView = DiscardPopupView.instanceOfClass()
    var delegate: CustomCameraVCDelegate?
    var topTitle: String?
    private var videoCapturedUrl: URL?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var captureBtn: UIButton!
    @IBOutlet var capturedImage: UIImageView!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet weak var timeCountLbl: UILabel!
    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var cameraFlipButton: UIButton!
    @IBOutlet var btnUpload: UIButton!
   
    @IBOutlet var downloadBtnCameraView: UIButton!
    @IBOutlet var galleryBtn: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    @IBOutlet weak var leadingConstCameraView: NSLayoutConstraint!
    @IBOutlet weak var trailingConstCameraView: NSLayoutConstraint!
    @IBOutlet weak var topConstCameraView: NSLayoutConstraint!
    
    @IBOutlet weak var controlsView: UIView!
    
    var cameraController = CameraController()
    var capturedTime = Float()
    var timer: Timer!
    var videoPlayer = AVPlayer()
    var progressCircle = CAShapeLayer()
    var media_uploadedFrom = String()
    var crossCount = Int()
    var video_duration = Float()
    var mediaType = String()
    var parentClass = UIViewController()
    var galleryPicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popUpView.delegate = self
        coverView.frame = self.view.bounds
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        lblTitle.text = self.topTitle
        initCameraView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = AppColors.TacoPurple
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    private func initCameraView() {
      //  customLayer(layer: sendBtnCameraView.layer)
        initCameraOverlay()
        
        crossCount = 1
        mediaType = "public.image"
        playBtn.isHidden = true
        controlsView.isHidden = true
        
        // timeCountLbl.isHidden = true
        
        checkCameraAuthorization()
        
        PHPhotoLibrary.requestAuthorization({(newStatus) in })
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        
//      let longPress = UILongPressGestureRecognizer(target: self, action:
//      #selector(self.longPress(guesture:)))
//      captureBtn.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DoubleTap(sender:)))
        tap.numberOfTapsRequired = 2
        cameraView.isUserInteractionEnabled = true
        cameraView.addGestureRecognizer(tap)
        cameraView.backgroundColor = UIColor.black
        
        capturedImage.backgroundColor = UIColor.black
        capturedImage.contentMode = .scaleAspectFit
       // capturedImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
       // flashButton.setImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        
        UIApplication.shared.statusBarStyle = .default
        
    //    captureBtn.frame.size.height = captureBtn.frame.size.width
    //    galleryBtn.frame.size.height = galleryBtn.frame.size.width
    //    sendBtnCameraView.frame.size.height = sendBtnCameraView.frame.size.width
        
    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        videoPlayer.pause()
//        videoPlayer.isMuted = true
//        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer)
//    }
    
    
    @IBAction func backPress(_ sender: UIButton) {
//        self.popUpView.setNeedsLayout()
//        self.popUpView.frame = CGRect(x:40,y:150,width:self.view.frame.size.width - 80,height:self.popUpView.frame.size.height + 15)
//        self.view.addSubview(self.coverView)
//        coverView.addSubview(popUpView)
        
        Singleton.shared.showAlert(self, title: "Discard and record new video?", message: "If you record a new video your current video will be discarded", firstAction: "Keep", secondAction: "Discard",
        firstCallBack: {
            
        }, secondCallBack: {
            self.initCameraOverlay()
            self.delegate?.willDismissed!(videoUrl: self.videoCapturedUrl)
            self.dismiss(animated: false) {
                defer {
                    self.delegate?.didDismissed(videoUrl: self.videoCapturedUrl)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func customLayer(layer:CALayer) {
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    
    //MARK: Custom Camera functions
    
    func startTimer() {
        if timer == nil {
            capturedTime = 0
            
            
            //timeCountLbl.text =
            timeCountLbl.attributedText = self.currentTime("00:0\(Int(capturedTime))")
         // timeCountLbl.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
      //  timeCountLbl.isHidden = true
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timeCountLbl.text = "Tap to record video"
    }
    
    @objc func runTimedCode() {
        
        if capturedTime < 14.5 {
            capturedTime += 0.25
            
            if capturedTime < 9 {
                // timeCountLbl.text = "00:0\(Int(capturedTime) + 1)"
                timeCountLbl.attributedText = self.currentTime("00:0\(Int(capturedTime) + 1)")
            } else {
               // timeCountLbl.text = "00:\(Int(capturedTime) + 1)"
                timeCountLbl.attributedText = self.currentTime("00:\(Int(capturedTime) + 1)")
            }
            
            return
        }
        
        capturedTime += 0.25
        // timeCountLbl.text = "00:\(Int(capturedTime))"
        timeCountLbl.attributedText = self.currentTime("00:\(Int(capturedTime))")
        cameraController.stopRecording()
        
        stopTimer()
        
        // crossCount = 0
        // progressCircle.removeFromSuperlayer()
        //captureBtn.setImage(UIImage(named: "circle2"), for: .normal)
        
    }
    
    func configureCameraController() {
        
        cameraController.prepare {(error) in
            try? self.cameraController.displayPreview(on: self.cameraView)
            self.cameraController.flashMode = .auto
            
        /*  if let error = error {
                //print(error)
            }
            self.flashButton.setImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
            */
        }
    }
    
    
    func initCameraOverlay()  {
        
        playBtn.isHidden = true
        capturedImage.isHidden = true
        
        videoPlayer.pause()
        videoPlayer.isMuted = true
        playBtn.isSelected = false
        
        timeCountLbl.text = "Tap to record video"
        
        capturedImage.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer)
        
        
    /*  downloadBtnCameraView.isHidden = true
        flashButton.isHidden = false
        editButton.isHidden = true
        cameraFlipButton.isHidden = false
        sendBtnCameraView.isHidden = true
        
        galleryBtn.isHidden = false
        captureBtn.isHidden = false
        progressCircle.removeFromSuperlayer()
        captureBtn.setImage(#imageLiteral(resourceName: "record"), for: .normal)
        */
    }
    
    func finalizeCameraOverlay()  {
        capturedImage.isHidden = false
        
  
   /*   galleryBtn.isHidden = true
        downloadBtnCameraView.isHidden = false
        flashButton.isHidden = true
        
        if mediaType == "public.image" {
            // editButton.isHidden = false
        }
        
        cameraFlipButton.isHidden = true
        sendBtnCameraView.isHidden = false
        captureBtn.isHidden = true
        downloadBtnCameraView.setImage(#imageLiteral(resourceName: "download"), for: .normal)
        downloadBtnCameraView.isUserInteractionEnabled = true
    */
    }
    
    
    //MARK: Gesture Recognizers
    
    @objc func DoubleTap(sender: UITapGestureRecognizer?) {
        
        do {
            try cameraController.switchCameras()
        } catch{
            
        }
        
    }
    
    
 /*   @objc func longPress(guesture: UILongPressGestureRecognizer) {
        
        if guesture.state == UIGestureRecognizerState.began {
            
            cameraController.startVideoRecord(completion: { (url, error) in
                
                if((error) != nil){
                    //print(error as Any)
                } else {
                    
                    self.mediaType = "public.movie"
                    
                    let asset : AVURLAsset = AVURLAsset(url: url!)
                    self.video_duration = (Float(asset.duration.seconds))
                    //print("Selected video_duration-> \(self.video_duration)")
                    self.videoPath = asset.url as NSURL
                    self.playBtn.isHidden = false
                    
                    self.videoPlayer = AVPlayer(url: self.videoPath as URL)
                    let playerLayer = AVPlayerLayer(player: self.videoPlayer)
                    playerLayer.frame = self.capturedImage.bounds
                    self.videoPlayer.play()
                    self.videoPlayer.isMuted = false
                    
                    self.capturedImage.image = nil
                    self.capturedImage.backgroundColor = UIColor.black
                    self.capturedImage.layer.addSublayer(playerLayer)
                    self.capturedImage.layoutIfNeeded()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: nil, using: { (_) in
                        DispatchQueue.main.async {
                            self.videoPlayer.seek(to: kCMTimeZero)
                            self.videoPlayer.play()
                            self.videoPlayer.isMuted = false
                            self.playBtn.isSelected  = true
                        }
                    })
                    
                    self.media_uploadedFrom = "Camera"
                    self.finalizeCameraOverlay()
                }
            })
            
            let lineWidth:CGFloat = 3
            let rectFofOval = CGRect(x: lineWidth / 2, y: lineWidth / 2 , width: captureBtn.bounds.width - lineWidth, height: captureBtn.bounds.height - lineWidth)
            let circlePath = UIBezierPath(ovalIn: rectFofOval)
            
            self.progressCircle.path = circlePath.cgPath
            self.progressCircle.strokeColor = AppColors.JuanPurple.cgColor
            self.progressCircle.fillColor = UIColor.clear.cgColor
            self.progressCircle.lineWidth = 4.0
            self.progressCircle.frame = view.bounds
            self.progressCircle.lineCap = "round"
            
            self.captureBtn.layer.addSublayer(self.progressCircle)
            self.captureBtn.setImage(UIImage(named: "greenDot"), for: .normal)
            self.captureBtn.transform = CGAffineTransform(rotationAngle: -90)
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = (1)
            animation.duration = 17
            animation.repeatCount = 1
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            self.progressCircle.add(animation, forKey: nil)
         //   self.flashButton.isUserInteractionEnabled = false
         //   self.cameraFlipButton.isUserInteractionEnabled = false
          //  self.galleryBtn.isUserInteractionEnabled = false
            
            self.startTimer()
            
        }
        
        if guesture.state == UIGestureRecognizerState.ended {
            
            self.cameraController.stopRecording()
            
            self.crossCount = 0
            self.progressCircle.removeFromSuperlayer()
            self.captureBtn.setImage(UIImage(named: "circle2"), for: .normal)
            self.stopTimer()
            
        //  self.flashButton.isUserInteractionEnabled = true
        //  self.cameraFlipButton.isUserInteractionEnabled = true
         // self.galleryBtn.isUserInteractionEnabled = true
            
        }
        
        if guesture.state == UIGestureRecognizerState.failed {
            
            self.crossCount = 0
            self.progressCircle.removeFromSuperlayer()
            self.captureBtn.setImage(UIImage(named: "circle2"), for: .normal)
            self.stopTimer()
            
         //   self.flashButton.isUserInteractionEnabled = true
         //   self.cameraFlipButton.isUserInteractionEnabled = true
         //   self.galleryBtn.isUserInteractionEnabled = true
            
        }
     
    }
    */
    
    @IBAction func cancelBtnFromKeyboardClicked(sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: Camera Buttons
    
    @IBAction func uploadAction(_ sender: Any) {
        
        self.initCameraOverlay()
        self.delegate?.willDismissed!(videoUrl: self.videoCapturedUrl)
        self.dismiss(animated: false) {
            defer {
                self.delegate?.videoDidCaptured(videoUrl: self.videoCapturedUrl)
            }
        }
    }
    
    @IBAction func turnflashOn(_ sender: Any) {
        
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
        /// self.flashButton.setImage(#imageLiteral(resourceName: "flashOff"), for: .normal)
        
        } else if cameraController.flashMode == .off {
        //  self.flashButton.setImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
            cameraController.flashMode = .auto
            
        } else {
         // self.flashButton.setImage(#imageLiteral(resourceName: "flashIcon"), for: .normal)
            cameraController.flashMode = .on
        }
    }
    
    @IBAction func flipCamera(_ sender: Any) {
        
        do {
            try cameraController.switchCameras()
        } catch {
            
        }
        
    }
    
    
    @IBAction func imageCaptureAction(_ sender: Any) {
        
/*      cameraController.captureImage { (image, error) in

            self.mediaType = "public.image"
            self.capturedImage.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            self.playBtn.isHidden = true
            self.capturedImage.image = image

            self.crossCount = 0
            self.media_uploadedFrom = "Camera"
            self.finalizeCameraOverlay()

        }
*/
        if captureBtn.isSelected {
            cameraController.stopRecording()
            captureBtn.isSelected = false
            stopTimer()
            
        /*
            leadingConstCameraView.constant = 16
            trailingConstCameraView.constant = -238
            topConstCameraView.constant = 226
            cameraView.layoutIfNeeded()
            cameraController.changePreviewLayoutSize(cameraView)
        */
            
        } else {
            
            captureBtn.isSelected = true
            startTimer()
            controlsView.isHidden = true
            captureBtn.isHidden = false
            initCameraOverlay()
     /*
            leadingConstCameraView.constant = 0
            trailingConstCameraView.constant = 0
            topConstCameraView.constant = 0
            cameraView.layoutIfNeeded()
            cameraController.changePreviewLayoutSize(cameraView)
     */
            cameraController.startVideoRecord(completion: { (url, error) in
                
                guard error == nil, let outPutUrl = url else {
                    return
                }
                DispatchQueue.main.async {
                    self.controlsView.isHidden = false
                    self.captureBtn.isHidden = true
                    self.timeCountLbl.isHidden = true
                    self.cameraFlipButton.isHidden = true
                    
                    self.mediaType = "public.movie"
                    
                    let asset : AVURLAsset = AVURLAsset(url: outPutUrl)
                    self.video_duration = (Float(asset.duration.seconds))
                    self.videoCapturedUrl = asset.url
                    self.playBtn.isHidden = false
                    
                    self.videoPlayer = AVPlayer(url: outPutUrl)
                    let playerLayer = AVPlayerLayer(player: self.videoPlayer)
                    playerLayer.frame = self.capturedImage.bounds
                    self.videoPlayer.play()
                    self.videoPlayer.isMuted = false
                    
                    self.capturedImage.image = nil
                    self.capturedImage.backgroundColor = UIColor.black
                    self.capturedImage.layer.addSublayer(playerLayer)
                    self.capturedImage.layoutIfNeeded()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: nil, using: { (_) in
                        DispatchQueue.main.async {
                            self.videoPlayer.seek(to: kCMTimeZero)
                            self.videoPlayer.play()
                            self.videoPlayer.isMuted = false
                            self.playBtn.isSelected  = true
                        }
                    })
                    
                    self.media_uploadedFrom = "Camera"
                    self.finalizeCameraOverlay()
                }
               
            })
            
        }
        
    }
    
    @IBAction func openGallery(_ sender: Any) {
        self.checkPhotoAuthorization()
        self.crossCount = 0
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        } else {
         // self.downloadBtnCameraView.isHidden = true
            let ac = UIAlertController(title: "Saved!", message: "Captured image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
/*
    @IBAction func cameraCrossAction(_ sender: Any) {
        
        crossCount = crossCount + 1
        
        if(crossCount == 2) {
            dismiss(animated: true, completion: nil)
        } else {
            initCameraOverlay()
        }
        
    }
 */
    
    @IBAction func sendActionCameraView(_ sender: Any) {
        
        self.crossCount = 0
        self.videoPlayer.pause()
        self.videoPlayer.isMuted = true
        self.playBtn.isSelected = false
        
    }
    
    @IBAction func playVideo(_ sender: Any){
        
        if(playBtn.isSelected){
            self.videoPlayer.pause()
            self.videoPlayer.isMuted = true
            self.playBtn.isSelected = false
        } else {
            self.playBtn.isSelected = true
            self.videoPlayer.play()
            self.videoPlayer.isMuted = false
        }
    }
    
    
    //MARK: Private Method
    
    func currentTime(_ value: String) -> NSAttributedString {
        
        let attrs1 = [NSAttributedStringKey.font : UIFont(name: AppFont.medium, size: 16), NSAttributedStringKey.foregroundColor : AppColors.GrayTint1 ]
        
        let attributedString1 = NSMutableAttributedString(string:"  \(value) ", attributes:attrs1 as Any as? [NSAttributedStringKey : Any])
        
        let attachment = NSTextAttachment()
        attachment.image = #imageLiteral(resourceName: "Red-circle-hi")
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: 2.5), size: CGSize(width: 5, height: 5))
        let attachmentString = NSAttributedString(attachment: attachment)
        
        let finalString = NSMutableAttributedString(string: "")
        finalString.append(attachmentString)
        finalString.append(attributedString1)

        return finalString
        
    }
    
    
}

extension CustomCameraVC :UIGestureRecognizerDelegate {
    
}

extension CustomCameraVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Camera Authorization
    
    func checkCameraAuthorization() {
        
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == .authorized {
            
            self.configureCameraController()
            
        } else if status == .denied {
            
            if AVCaptureDevice.responds(to: #selector(AVCaptureDevice.requestAccess(for:completionHandler:))) {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(_ granted: Bool) -> Void in
                    
                    if granted {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.configureCameraController()
                        })
                    
                    } else {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.accessMethod("Please go to Settings and enable the camera for this app to use this feature.")
                        })
                    }
                })
            }
            
        } else if status == .restricted {
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.accessMethod("Please go to Settings and enable the camera for this app to use this feature.")
            })
        
        } else if status == .notDetermined {
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(_ granted: Bool) -> Void in
                if granted {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.configureCameraController()
                    })
                } else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.accessMethod("Please go to Settings and enable the camera for this app to use this feature.")
                    })
                }
            })
        }
    }
    
    
    func accessMethod(_ message: String) {
        
        Singleton.shared.showAlert(self, title: "Not Authorized", message: message, firstAction: "Ok", secondAction: "Settings",
        firstCallBack: {
            self.dismiss(animated: true, completion: nil)
        }, secondCallBack: {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: nil)
        })
        
        /*
         let alertController = UIAlertController(title: "Not Authorized", message: message, preferredStyle: .alert)
         let cancel = UIAlertAction(title: "Ok", style: .default) { (action) in
         
         }
         let Settings = UIAlertAction(title: "Settings", style: .default, handler: {(_ action: UIAlertAction) -> Void in
         
         })
         alertController.addAction(Settings)
         alertController.addAction(cancel)
         present(alertController, animated: true, completion: nil)
 
        */
    }
    
    
    
    func checkPhotoAuthorization()  {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            let localPicker = UIImagePickerController()
            localPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            localPicker.videoMaximumDuration = 15.0
            //localPicker.allowsEditing = true
            localPicker.delegate = self
            self.present(localPicker, animated: true, completion: nil)
            
        } else if status == .denied {
            DispatchQueue.main.async(execute: {() -> Void in
                self.accessMethodPhotos("Please go to Settings and enable the photos for this app to use this feature.")
            })
            
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({(_ status: PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        let localPicker = UIImagePickerController()
                        localPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                        localPicker.videoMaximumDuration = 15.0
                        //   localPicker.allowsEditing = true
                        localPicker.delegate = self
                        self.present(localPicker, animated: true, completion: nil)
                    })
                    
                } else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.accessMethodPhotos("Please go to Settings and enable the photos for this app to use this feature.")
                    })
                }
            })
            
        } else if status == .restricted {
            
        }
        
    }
    
    func accessMethodPhotos(_ message: String) {
        let alertController = UIAlertController(title: "Not Authorized", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        let Settings = UIAlertAction(title: "Settings", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: nil)
        })
        alertController.addAction(Settings)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            self.mediaType = mediaType
            
            capturedImage.layer.sublayers?.forEach {
                $0.removeFromSuperlayer()
            }
            
            if mediaType  == "public.image",
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                    self.playBtn.isHidden = true
                    self.capturedImage.image = image
            }
            
            else if mediaType == "public.movie",
                let videoURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                
                    let asset : AVURLAsset = AVURLAsset(url: videoURL as URL)
                    self.video_duration = (Float(asset.duration.seconds))
                    self.videoCapturedUrl = asset.url
                    self.playBtn.isHidden = false
                    
                    self.videoPlayer = AVPlayer(url: videoURL as URL)
                    let playerLayer = AVPlayerLayer(player: self.videoPlayer)
                    playerLayer.frame = self.capturedImage.bounds
                    self.videoPlayer.play()
                    self.videoPlayer.isMuted = false
                    
                    self.capturedImage.image = nil
                    self.capturedImage.backgroundColor = UIColor.black
                    self.capturedImage.layer.addSublayer(playerLayer)
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: nil, using: { (_) in
                        DispatchQueue.main.async {
                            self.videoPlayer.seek(to: kCMTimeZero)
                            self.videoPlayer.play()
                            self.videoPlayer.isMuted = false
                            self.playBtn.isSelected  = true
                        }
                    })
            }
            
            self.finalizeCameraOverlay()
        }
        
        if(picker.sourceType == .photoLibrary) {
            
            self.media_uploadedFrom = "Gallery"
            if self.capturedImage.image != nil {
                galleryPicker = picker
                let shittyVC = ImageCropVC(frame: UIScreen.main.bounds, image:self.capturedImage.image!, aspectWidth: 1, aspectHeight: 1) //(self.navigationController?.view.frame)!
                shittyVC.delegate = self
                picker.present(shittyVC, animated: true, completion: nil)
            } else {
                picker.dismiss(animated: false) {
                    
                }
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.crossCount = 1
        picker.dismiss(animated: false, completion: nil)
        
    }
    
    //MARK: Image cropp Delegate
    
    func imageCropped(image: UIImage) {
        galleryPicker.dismiss(animated: true) {
            self.capturedImage.image = image
        }
    }
    
    
}

extension CustomCameraVC :UIVideoEditorControllerDelegate, UITextViewDelegate, CroppedImageDelegate {
    func ImageCropViewControllerCancelled() {
        
    }
    
}

//extension CustomCameraVC: DiscardPopupViewDelegate {
//    func cancelPressed() {
//        popUpView.removeFromSuperview()
//        coverView.removeFromSuperview()
//    }
//
//    func donePressed() {
//        popUpView.removeFromSuperview()
//        coverView.removeFromSuperview()
//        initCameraOverlay()
//        self.dismiss(animated: true) {
//            defer {
//                self.delegate?.backAction(videoUrl: self.videoCapturedUrl)
//            }
//        }
//    }
//}
