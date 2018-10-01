//
//  CameraController.swift
//  AV Foundation
//
//  Created by Pranjal Satija on 29/5/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import AVFoundation
import UIKit

var imageSizeRequired: CGRect?
var previewLayer: AVCaptureVideoPreviewLayer?

public enum CameraPosition {
    case front
    case rear
}

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    var currentCameraPosition: CameraPosition?
    
    var frontCamera: AVCaptureDevice?
    var captureAudio :AVCaptureDevice?
    
    var captureAudioInput: AVCaptureDeviceInput?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureMovieFileOutput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var videoCaptureCompletionBlock: ((URL?, Error?) -> Void)?
    
    var flashEnabled = false
    
    var lastZoomFactor: CGFloat = 1.0
}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
            
            //            if (self.captureSession?.canSetSessionPreset(AVCaptureSessionPreset1280x720))!{
            //                self.captureSession?.sessionPreset = AVCaptureSessionPreset1280x720
            //            }
            
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInMicrophone], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = (session.devices.compactMap { $0 })
            guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
            
            self.captureAudio = AVCaptureDevice.default(for: AVMediaType.audio)
            
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
                
                self.currentCameraPosition = .rear
                
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
            
            if let captureAudio = self.captureAudio{
                self.captureAudioInput = try AVCaptureDeviceInput(device: captureAudio)
                
                if captureSession.canAddInput(self.captureAudioInput!) { captureSession.addInput(self.captureAudioInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession
                else {
                    throw CameraControllerError.captureSessionIsMissing
            }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
            
            captureSession.startRunning()
            
        }
        
        
        func configureVideoOutput() throws {
            
            guard self.captureSession != nil
                else {
                    throw CameraControllerError.captureSessionIsMissing
            }
            self.videoOutput = AVCaptureMovieFileOutput()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                try configureVideoOutput()
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
        
    }
    
    func displayPreview(on view: UIView) throws {
        
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        previewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        
        let v = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(_:)))
        view.addGestureRecognizer(v)
    }
    
    func changePreviewLayoutSize(_ equalTo: UIView) {
        for layer in equalTo.layer.sublayers! {
            if layer == previewLayer {
                layer.frame = CGRect(x: 0, y: 0, width: equalTo.frame.width, height: equalTo.frame.width)
            }
        }
        
    }
    
    
    func switchCameras() throws {
        
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        captureSession.beginConfiguration()
        
        
        func switchToFrontCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
            
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                self.currentCameraPosition = .front
                self.lastZoomFactor =  1.0
            }
            else {
                throw CameraControllerError.invalidOperation
            }
        }
        
        func switchToRearCamera() throws {
            guard let inputs = captureSession.inputs as? [AVCaptureInput], let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput),
                let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
            
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
                
                self.currentCameraPosition = .rear
                self.lastZoomFactor =  1.0
            }
                
            else { throw CameraControllerError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        
        captureSession.commitConfiguration()
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let captureSession = self.captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        var device : AVCaptureDevice
        if self.currentCameraPosition == CameraPosition.front{
            device = self.frontCamera!
        }
        else{
            device = self.rearCamera!
        }
        
        if device.hasFlash == true{
            let settings = AVCapturePhotoSettings()
            settings.flashMode = self.flashMode
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
            self.photoCaptureCompletionBlock = completion
        }
        else if device.hasFlash == false && self.currentCameraPosition == CameraPosition.front {
            
            let settings = AVCapturePhotoSettings()
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
            self.photoCaptureCompletionBlock = completion
        }
        
        
        
        //   settings.flashMode = self.frontCamera == .front || self.currentCameraPosition == .unspecified  ? .off : .auto
        
        //    self.photoOutput?.capturePhoto(with: settings, delegate: self)
        //    self.photoCaptureCompletionBlock = completion
        
        
        /*
         
         var device : AVCaptureDevice
         if self.currentCameraPosition == CameraPosition.front{
         device = self.frontCamera!
         }
         else{
         device = self.rearCamera!
         }
         
         
         if device.hasFlash == true && flashEnabled == true /* TODO: Add Support for Retina Flash and add front flash */ {
         changeFlashSettings(device: device, mode: self.flashMode)
         
         
         } else if device.hasFlash == false && flashEnabled == true && self.currentCameraPosition == CameraPosition.front {
         
         //            flashView = UIView(frame: view.frame)
         //            flashView?.alpha = 0.0
         //            flashView?.backgroundColor = UIColor.white
         //            previewLayer.addSubview(flashView!)
         //
         //            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
         //                self.flashView?.alpha = 1.0
         
         //            }, completion: { (_) in
         //                self.capturePhotoAsyncronously(completionHandler: { (success) in
         //                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
         //                        self.flashView?.alpha = 0.0
         //                    }, completion: { (_) in
         //                        self.flashView?.removeFromSuperview()
         //                    })
         //                })
         //            })
         } else {
         if device.isFlashActive == true {
            changeFlashSettings(device: device, mode: .off)
         }
         
         }
         
         
         */
        
        
    }
    
    func startVideoRecord(completion: @escaping (URL?, Error?) -> Void){
        
        if let output = videoOutput, (self.captureSession?.canAddOutput(output))! {
            self.captureSession?.addOutput(output)
            
            // let videoSettings = [av ] as [String : Any];
            // self.videoOutput?.setOutputSettings(<#T##outputSettings: [AnyHashable : Any]!##[AnyHashable : Any]!#>, for: AVCaptureConnection!)
        }
        
        do{
            if self.currentCameraPosition == CameraPosition.rear && (rearCamera?.hasTorch)!
            {
                try rearCamera?.lockForConfiguration()
                
                switch self.flashMode {
                    case .on : rearCamera?.torchMode = .on
                    case .auto : rearCamera?.torchMode = .auto
                    case .off : rearCamera?.torchMode = .off
                }
                rearCamera?.flashMode  = self.flashMode
                rearCamera?.unlockForConfiguration()
            }
            else if self.currentCameraPosition == CameraPosition.front && (frontCamera?.hasTorch)!
            {
                
                try frontCamera?.lockForConfiguration()
                switch self.flashMode {
                    case .on : rearCamera?.torchMode = .on
                    case .auto : rearCamera?.torchMode = .auto
                    case .off : rearCamera?.torchMode = .off
                }
                
                frontCamera?.flashMode  = self.flashMode
                frontCamera?.unlockForConfiguration()
                
            }
        }
        catch {
            //DISABEL FLASH BUTTON HERE IF ERROR
            //print("Device tourch Flash Error ");
        }
        
        
        self.captureSession?.startRunning()
        
        let fileName = "video.mov";
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent(fileName)
        
        self.videoOutput?.startRecording(to: filePath, recordingDelegate: self)
        self.videoCaptureCompletionBlock = completion
        
    }
    
    func stopRecording() {
        if (self.videoOutput?.isRecording)! {
            
            do {
                if self.currentCameraPosition == CameraPosition.rear && (rearCamera?.hasTorch)!{
                    try rearCamera?.lockForConfiguration()
                    rearCamera?.torchMode = .off
                    rearCamera?.flashMode = .off
                    rearCamera?.unlockForConfiguration()
                    
                } else if self.currentCameraPosition == CameraPosition.front && (frontCamera?.hasTorch)! {
                    try frontCamera?.lockForConfiguration()
                    frontCamera?.torchMode = .off
                    frontCamera?.flashMode  = .off
                    frontCamera?.unlockForConfiguration()
                }
            }
                
            catch {
                //DISABEL FLASH BUTTON HERE IF ERROR
                //print("Device tourch Flash Error ");
            }
            
            self.videoOutput?.stopRecording()
        }
        
    }
    
    
    fileprivate func changeFlashSettings(device: AVCaptureDevice, mode: AVCaptureDevice.FlashMode) {
        do {
            try device.lockForConfiguration()
            device.flashMode = mode
            device.unlockForConfiguration()
        } catch {
            //print("[SwiftyCam]: \(error)")
        }
    }
    
    
    func getVideoOrientation() -> AVCaptureVideoOrientation {
        guard  let deviceOrientation = previewLayer?.connection?.videoOrientation else { return (previewLayer?.connection!.videoOrientation)! }
        
        switch deviceOrientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        
        var device = self.rearCamera!
        
        if self.currentCameraPosition == CameraPosition.front {
            device = self.frontCamera!
        } else {
            device = self.rearCamera!
        }
        
        let maximumZoom : CGFloat = 5.0
        let minimumZoom : CGFloat = 1.0
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                //print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    
    /*
     func getSettings(camera: AVCaptureDevice, flashMode: AVCaptureFlashMode ) -> AVCapturePhotoSettings {
     let settings = AVCapturePhotoSettings()
     
     if camera.hasFlash {
     switch flashMode {
     case .auto: settings.flashMode = .auto
     case .on: settings.flashMode = .on
     default: settings.flashMode = .off
     }
     }
     return settings
     }
     */
    
}

extension CameraController: AVCapturePhotoCaptureDelegate,AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error { self.videoCaptureCompletionBlock?(nil, error) }
            
        else{
            Singleton.shared.manageCroppingToSquare(filePath: outputFileURL, cameraPosition: self.currentCameraPosition!) { (croppedVideoUrl) in
                if croppedVideoUrl != nil{
                    self.videoCaptureCompletionBlock?(croppedVideoUrl!, error)
                }
            }
        }
    }
    
    
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data){
            
            if self.currentCameraPosition == CameraPosition.front{
                
                let originalSize : CGSize
                let visibleLayerFrame = previewLayer?.bounds // THE ACTUAL VISIBLE AREA IN THE LAYER FRAME
                
                let metaRect : CGRect = (previewLayer?.metadataOutputRectConverted(fromLayerRect: visibleLayerFrame!))!
                if (image.imageOrientation == UIImageOrientation.left || image.imageOrientation == UIImageOrientation.right) {
                    
                    originalSize = CGSize(width: image.size.height, height: image.size.width)
                }
                else {
                    originalSize = image.size
                }
                
                let cropRect : CGRect =
                    CGRect( x: metaRect.origin.x * originalSize.width,
                            y: metaRect.origin.y * originalSize.height,
                            width: metaRect.size.width * originalSize.width,
                            height: metaRect.size.height * originalSize.height)
                
                let finalImage : UIImage = UIImage.init(cgImage: (image.cgImage?.cropping(to: cropRect.integral))!, scale: 1, orientation: UIImageOrientation.leftMirrored)
                
                //print(finalImage)
                
                self.photoCaptureCompletionBlock?( finalImage ,  nil)
                
            }
            else{
                
                let originalSize : CGSize
                let visibleLayerFrame = previewLayer?.bounds
                
                let metaRect : CGRect = (previewLayer?.metadataOutputRectConverted(fromLayerRect: visibleLayerFrame!))!
                if (image.imageOrientation == UIImageOrientation.left || image.imageOrientation == UIImageOrientation.right) {
                    
                    originalSize = CGSize(width: image.size.height, height: image.size.width)
                }
                else {
                    originalSize = image.size
                }
                
                let cropRect : CGRect =
                    CGRect( x: metaRect.origin.x * originalSize.width,
                            y: metaRect.origin.y * originalSize.height,
                            width: metaRect.size.width * originalSize.width,
                            height: metaRect.size.height * originalSize.height)
                
                let finalImage : UIImage = UIImage.init(cgImage: (image.cgImage?.cropping(to: cropRect.integral))!, scale: 1, orientation: image.imageOrientation)
                
                self.photoCaptureCompletionBlock?( finalImage ,  nil)
                
            }
            
        }
        else{
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
    
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
}



