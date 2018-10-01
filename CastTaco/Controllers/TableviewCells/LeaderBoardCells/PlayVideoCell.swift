//
//  PlayVideoCell.swift
//  CastTaco
//
//  Created by Mrinal Khullar on 22/08/18.
//  Copyright © 2018 brst. All rights reserved.
//

import UIKit
import AVFoundation


protocol PlayVideoCellDelegate {
    func playerWillRemove()
}

class PlayVideoCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    var delegate:PlayVideoCellDelegate?

    private var videoPlayer: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(thumbnail:UIImage?) {
        self.thumbnail.image = thumbnail
        self.thumbnail.backgroundColor = UIColor.lightGray
        self.videoPlayer?.replaceCurrentItem(with: nil)
        self.videoPlayer = nil
        self.playerLayer = nil
    }
    
    func setVideoLayerwith(_ videoPath:URL) {
        
        self.videoPlayer = AVPlayer(url: videoPath)
        self.playerLayer = AVPlayerLayer(player: self.videoPlayer)
        self.playerLayer?.frame = self.thumbnail.bounds
        
       // self.videoPlayer?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
        _ = self.thumbnail.layer.sublayers?.map({$0.removeFromSuperlayer()})
        
        self.thumbnail.image = nil
        self.thumbnail.backgroundColor = UIColor.black
        self.thumbnail.layer.addSublayer(playerLayer!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.videoPlayer?.play()
            self.videoPlayer?.isMuted = false
        }
        
        thumbnail.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.playPauseVideo))
        tap.numberOfTapsRequired = 1
        thumbnail.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.videoPlayer?.seek(to: kCMTimeZero)
                self.videoPlayer?.play()
                self.videoPlayer?.isMuted = false
            }
        })
        
        
        self.videoPlayer?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.videoPlayer?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        self.videoPlayer?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        self.loader.isHidden = false
        self.loader.startAnimating()
    }
    
    @objc func playPauseVideo() {
        if let rate = videoPlayer?.rate, rate > 0.1 {
            self.videoPlayer?.pause()
            self.videoPlayer?.isMuted = true
        } else {
            self.videoPlayer?.play()
            self.videoPlayer?.isMuted = false
        }
    }
    
    @IBAction func cossPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.videoPlayer?.pause()
            self.videoPlayer?.isMuted = true
            self.playerLayer?.removeFromSuperlayer()
            self.videoPlayer?.replaceCurrentItem(with: nil)
            self.videoPlayer = nil
            self.playerLayer = nil
            
            self.loader.stopAnimating()
            
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer)
            
        }
        delegate?.playerWillRemove()
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is AVPlayerItem {
            switch keyPath {
            case "playbackBufferEmpty":
                // Show loader
                print("Buffering")
                DispatchQueue.main.async {
                    self.loader.isHidden = false
                    self.loader.startAnimating()
                }
            case "playbackLikelyToKeepUp":
                // Hide loader
                print("Keep Buffering")
                DispatchQueue.main.async {
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                }
            case "playbackBufferFull":
                // Hide loader
                print("Stop Buffering")
                DispatchQueue.main.async {
                    self.loader.isHidden = true
                    self.loader.stopAnimating()
                }
            case .none: break
                
            case .some(_): break
                
            }
        }
    }
    
    
}
