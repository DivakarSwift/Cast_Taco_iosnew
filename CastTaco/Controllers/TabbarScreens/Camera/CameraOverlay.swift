//
//  CameraOverlay.swift
//  Ludi
//
//  Created by Mrinal Khullar on 07/12/17.
//  Copyright © 2017 Brst-Pc109. All rights reserved.
//

import UIKit
//import MBProgressHUD
import PhotosUI
// import SDWebImage
// import PhotoEditorSDK
// import Alamofire


class CameraOverlay: UIViewController {
    
    func ImageCropViewControllerCancelled() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
   
    
//    @IBAction func saveImageInGallery(_ sender: Any) {
//
//        Singleton.albumName = "Ludi"
//
//        if mediaType  == "public.image" {
//            Singleton.shared.save(image: self.capturedImage.image!)
//            downloadBtnCameraView.setImage(#imageLiteral(resourceName: "downloadComplete"), for: .normal)
//            downloadBtnCameraView.isUserInteractionEnabled = false
//        }
//
//        if mediaType == "public.movie" {
//            self.videoPlayer.pause()
//            self.videoPlayer.isMuted = true
//            self.playBtn.isSelected = false
//
//            Singleton.shared.saveVideo(videoPath: self.videoPath as URL)
//            downloadBtnCameraView.setImage(#imageLiteral(resourceName: "downloadComplete"), for: .normal)
//            downloadBtnCameraView.isUserInteractionEnabled = false
//        }
//    }
    
    
    
    
    //MARK: Edit Image Action
    
//    @IBAction func editImage(_ sender: Any) {
//
//        if self.capturedImage.image != nil {
//            self.presentPhotoEditorViewController(image: self.capturedImage.image!)
//        }
//
//    }
    
    
    //MARK: Present Photo Editor
 /*
    func presentPhotoEditorViewController(image:UIImage) {
        
        let orient = image.imageOrientation
        //print(orient)
        
        let configuration = Configuration() { builder in
            
            builder.configurePhotoEditorViewController { options in
                
                options.discardButtonConfigurationClosure  = { options in
                    
                    (options as UIButton).isHidden = true
                }
                
                options.applyButtonConfigurationClosure  = { options in
                    
                    (options as UIButton).setImage(nil, for: .normal)
                    (options as UIButton).setTitle("Done", for: .normal)
                    (options as UIButton).setTitleColor(UIColor.white, for: .normal)
                    
                }
                
                options.titleViewConfigurationClosure = { options in
                    (options as! UILabel).text = ""
                }
                
                options.actionButtonConfigurationClosure = { cell, menuItem in
                    switch menuItem {
                    case .tool(let toolMenuItem):
                        if toolMenuItem.toolControllerClass == TransformToolController.self {
                            
                        }
                    default:
                        break
                    }
                    
                }
                
            }
            
        }
        
        if self.media_uploadedFrom == "Camera" && orient == UIImageOrientation.leftMirrored{
            
            let p = self.cameraView.takeSnapshot()
            let photoEditViewController = PhotoEditViewController(photo: p, configuration: configuration)
            photoEditViewController.delegate = self
            self.present(photoEditViewController, animated: true, completion: nil)
            
        }
        else{
            
            let photoEditViewController = PhotoEditViewController(photo: image, configuration: configuration)
            photoEditViewController.delegate = self
            self.present(photoEditViewController, animated: true, completion: nil)
            
        }
        
    }
    */
    
    
  
    
    //MARK: Upload Methods.
    
    
//    func campaignPreUploadProcess() {
//
//        var mimeType = String()
//        var fileName = String()
//        var imageData = Data()
//
//        if mediaType  == "public.movie" {
//            mimeType = "video/mp4"
//            fileName = "video.mp4"
//
//            do {
//                imageData =  try NSData(contentsOfFile: (self.videoPath.relativePath)!, options: NSData.ReadingOptions.alwaysMapped) as Data
//            } catch {
//
//            }
//        }
//        else if mediaType  == "public.image"{
//            mimeType = "image/jpg"
//            fileName = "file.jpg"
//            imageData = UIImageJPEGRepresentation(self.capturedImage.image!,1)!
//
//        }
//
//
//        let parameters: Parameters =
//            ["auth_token":DataManager.authToken!,
//             "user_id":DataManager.UserId!
//        ]
//
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData, withName: "campaign_media",fileName:fileName ,mimeType:mimeType )
//            for (key, value) in parameters {
//                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//            }
//        },to:Constants.baseUrl + "campaign/addCampaignMedia")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//
//                upload.uploadProgress(closure: { (progress) in
//                    //print("Upload Progress: \(progress.fractionCompleted)")
//                })
//
//                upload.responseString(completionHandler: { (respo) in
//                    //print(respo)
//                })
//
//                upload.responseJSON { response in
//
//                    //print(response)
//                    if let json = response.result.value as? NSDictionary {
//
//                        if(json.value(forKey: "status") as! String == "200"){
//                            DataManager.campaignPreUploadedMediaUrl = json.value(forKey: "data") as? String
//
//                        }
//                        else{
//                            DataManager.campaignPreUploadedMediaUrl = nil
//                        }
//
//                    }
//
//                    if response.result.isFailure {
//
//                    }
//
//                }
//
//            case .failure(let encodingError):
//                print(encodingError)
//
//
//            }
//
//        }
//
//
//    }
    
//    func submissionPreUploadProcess(){
//
//        var mimeType = String()
//        var fileName = String()
//        var imageData = Data()
//
//        if mediaType  == "public.movie" {
//            mimeType = "video/mp4"
//            fileName = "video.mp4"
//
//            do{
//                imageData =  try NSData(contentsOfFile: (self.videoPath.relativePath)!, options: NSData.ReadingOptions.alwaysMapped) as Data
//                self.uploadMediaForSubmission( imageData: imageData, fileName: fileName, mimeType: mimeType)
//            }
//            catch{
//                //self.AlertMessage(title: "Alert", message: "Unable to process the selected video. Please try again.", buttonTitle: "Try Again")
//            }
//        }
//        else if mediaType  == "public.image"{
//
//            mimeType = "image/jpg"
//            fileName = "file.jpg"
//
//            imageData = UIImageJPEGRepresentation(self.capturedImage.image!,1)!
//            self.uploadMediaForSubmission( imageData: imageData, fileName: fileName, mimeType: mimeType)
//
//        }
//
//    }
    
    
//    func uploadMediaForSubmission(imageData:Data  , fileName:String  , mimeType:String ) {
//        
//        let parameters: Parameters =
//            ["auth_token":DataManager.authToken!,
//             "user_id":DataManager.UserId!
//        ]
//        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(imageData, withName: "media",fileName:fileName ,mimeType:mimeType )
//            for (key, value) in parameters {
//                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//            }
//        },to:Constants.baseUrl + "campaign/addSubmissionMedia")
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                
//                upload.uploadProgress(closure: { (progress) in
//                    //print("Upload Progress: \(progress.fractionCompleted)")
//                })
//                
//                upload.responseString(completionHandler: { (respo) in
//                    //print(respo)
//                })
//                
//                upload.responseJSON { response in
//                    
//                    //print(response)
//                    if let json = response.result.value as? NSDictionary {
//                        
//                        if(json.value(forKey: "status") as! String == "200"){
//                            DataManager.submissionPreUploadedMediaUrl = json.value(forKey: "data") as? String
//                        } else {
//                            DataManager.submissionPreUploadedMediaUrl = nil
//                        }
//                    
//                    }
//                    if response.result.isFailure {
//                    }
//                }
//                
//            case .failure(let encodingError):
//                print(encodingError)
//                
//                
//            }
//            
//        }
//        
//        
//    }
    
    
    //MARK: Common Methods.
    
    func customLayer(layer:CALayer){
        
        layer.cornerRadius = 8
        layer.masksToBounds = false;
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
 
}

extension UIView {
    
    func takeSnapshot() -> UIImage {
        
        //print(self.bounds)
        //print(bounds.size)
        //print(UIScreen.main.scale)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: (previewLayer?.frame.size.width)!, height: (previewLayer?.frame.size.width)!), true, UIScreen.main.scale)
        drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: -UIScreen.main.bounds.height/10 ), size: self.bounds.size), afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        return image
    }
}
