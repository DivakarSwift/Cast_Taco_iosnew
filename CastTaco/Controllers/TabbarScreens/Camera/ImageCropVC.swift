
import UIKit

protocol CroppedImageDelegate : class {
    func imageCropped(image:UIImage)
    func ImageCropViewControllerCancelled()
}


class ImageCropVC: UIViewController, UIScrollViewDelegate{
  
  var aspectW: CGFloat!
  var aspectH: CGFloat!
  var img: UIImage!
  var imageView: UIImageView!
  var scrollView: UIScrollView!
  var closeButton: UIButton!
  var cropButton: UIButton!
  var holeRect: CGRect!
  weak var delegate: CroppedImageDelegate?
    
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  init(frame: CGRect, image: UIImage, aspectWidth: CGFloat, aspectHeight: CGFloat) {
    super.init(nibName: nil, bundle: nil)
    aspectW = aspectWidth
    aspectH = aspectHeight
    view.frame = frame

    if (image.imageOrientation != .up) {
      UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
      var rect = CGRect.zero
      rect.size = image.size
      image.draw(in: rect)
      img = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    } else {
      img = image
    }
    
    setupView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func setupView() {
    closeButton = UIButton(frame: CGRect(x: 10, y: view.frame.height - 45, width: 60, height: 45))
    //closeButton.setImage(#imageLiteral(resourceName: "back_nav_white.png"), for: .normal)
    closeButton.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
    closeButton.setTitle("Close", for: .normal)
    closeButton.setTitleColor(UIColor.white, for: .normal)
   
    cropButton = UIButton(frame: CGRect(x: view.frame.width - 90, y: view.frame.height - 45, width: 90, height: 45))
   // cropButton.setImage(#imageLiteral(resourceName: "arrowSend-White"), for: .normal)
    cropButton.addTarget(self, action: #selector(tappedCrop), for: .touchUpInside)
    cropButton.setTitle("Choose", for: .normal)
    cropButton.setTitleColor(UIColor.white, for: .normal)
    view.backgroundColor = UIColor.gray
    
    // TODO: improve to handle super tall aspects (this one assumes full width)
    let holeWidth = view.frame.width
    print(aspectH)
    let holeHeight = holeWidth * aspectH/aspectW
    holeRect = CGRect(x: 0, y: view.frame.height/2-holeHeight/2, width: holeWidth, height: holeHeight)
    
    imageView = UIImageView(image: img)
    scrollView = UIScrollView(frame: view.bounds)
    scrollView.addSubview(imageView)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alwaysBounceHorizontal = true
    scrollView.alwaysBounceVertical = true
    scrollView.delegate = self
    view.addSubview(scrollView)
    
    let minZoom = max(holeWidth / imageView!.bounds.width, holeHeight / imageView!.bounds.height)
    scrollView.minimumZoomScale = minZoom
    scrollView.zoomScale = minZoom
    scrollView.maximumZoomScale = minZoom*4
    
    let viewFinder = hollowView(frame: view.frame, transparentRect: holeRect)
    view.addSubview(viewFinder)
    
    view.addSubview(closeButton)
    view.addSubview(cropButton)
  }
  
  // MARK: scrollView delegate
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    let gapToTheHole = view.frame.height/2-holeRect.height/2
    scrollView.contentInset = UIEdgeInsetsMake(gapToTheHole, 0, gapToTheHole, 0)
  }
  
  // MARK: actions
  
    @objc func tappedClose() {
    print("tapped close")
    
    self.dismiss(animated: true) {
        self.delegate?.ImageCropViewControllerCancelled()
    }
  }
  
    @objc func tappedCrop() {
    print("tapped crop")
    
    var imgX: CGFloat = 0
    if scrollView.contentOffset.x > 0 {
      imgX = scrollView.contentOffset.x / scrollView.zoomScale
    }
    
    let gapToTheHole = view.frame.height/2 - holeRect.height/2
    var imgY: CGFloat = 0
    if scrollView.contentOffset.y + gapToTheHole > 0 {
      imgY = (scrollView.contentOffset.y + gapToTheHole) / scrollView.zoomScale
    }
    
    let imgW = holeRect.width  / scrollView.zoomScale
    let imgH = holeRect.height  / scrollView.zoomScale
    
    print("IMG x: \(imgX) y: \(imgY) w: \(imgW) h: \(imgH)")
    
    let cropRect = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
    let imageRef = img.cgImage!.cropping(to: cropRect)
    let croppedImage = UIImage(cgImage: imageRef!)
    
    //UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    
    self.dismiss(animated: true, completion: {
        self.delegate?.imageCropped(image: croppedImage)
    })
  }
  
  func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
    if error == nil {
      print("saved cropped image")
    } else {
      print("error saving cropped image")
    }
  }
  
}


// MARK: hollow view class

class hollowView: UIView {
  var transparentRect: CGRect!
  
  init(frame: CGRect, transparentRect: CGRect) {
    super.init(frame: frame)
    
    self.transparentRect = transparentRect
    self.isUserInteractionEnabled = false
    self.alpha = 0.5
    self.isOpaque = false
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    backgroundColor?.setFill()
    UIRectFill(rect)
    
    let holeRectIntersection = transparentRect.intersection( rect )
    
    UIColor.clear.setFill();
    UIRectFill(holeRectIntersection);
  }
}


