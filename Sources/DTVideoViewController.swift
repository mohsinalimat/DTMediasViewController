//
//  DTVideoViewController.swift
//  DTMediasViewController
//
//  Created by 但 江 on 16/8/31.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit
import AVFoundation

class DTVideoViewController: DTMediaViewController {
  
  var video: DTMedia
  
  private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
  private let playerView = DTPlayerView()
  private let controlButton = UIButton()
  private var play = false {
    didSet {
      if oldValue != play {
        if play {
          canAutoPlay = false
          playerView.player?.play()
          controlButton.setImage(imageWithName("pause"), forState: .Normal)
          showControlButtonWithAutoHidden()
        } else {
          playerView.player?.pause()
          controlButton.setImage(imageWithName("play"), forState: .Normal)
          controlButton.hidden = false
        }
      }
    }
  }
  private var isViewAppear = false
  private var canAutoPlay = true
  private var controlButtonHiddenTimer = NSTimer()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    playerView.player?.removeObserver(self, forKeyPath: "status")
    NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerView.player?.currentItem)
  }

  init(video: DTMedia) {
    self.video = video
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blackColor()
    
    layoutPlayerView()
    layoutIndicatorView()
    layoutControlButton()
    
    if let url = video.url {
      indicatorView.startAnimating()
      let player = AVPlayer(URL: url)
      player.actionAtItemEnd = .None
      player.addObserver(self, forKeyPath: "status", options:NSKeyValueObservingOptions(), context: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
      playerView.player = player
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    isViewAppear = true
    autoPlay()
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    isViewAppear = false
    play = false
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if let keyPath = keyPath {
      if keyPath == "status" {
        if let player = object as? AVPlayer {
          if player.status == .ReadyToPlay {
            indicatorView.stopAnimating()
            controlButton.hidden = false
            autoPlay()
          }
        }
      }
    }
  }
  
  func controlPlay() {
    play = !play
  }
  
  func playerDidFinishPlaying(note: NSNotification) {
    play = false
  }
  
  func playerViewSingleTapped(recognizer: UITapGestureRecognizer) {
    if play == true {
      showControlButtonWithAutoHidden()
    } else {
      presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  func hideControlButton() {
    if play == true {
      controlButton.hidden = true
    }
  }
  
  // MARK: - Private
  
  private func imageWithName(name: String) -> UIImage? {
    let bundle = NSBundle(forClass: DTVideoViewController.self)
    return UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: nil)
  }
  
  private func layoutIndicatorView() {
    indicatorView.hidesWhenStopped = true
    
    view.addSubview(indicatorView)
    
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    
    let centerX = NSLayoutConstraint(item: indicatorView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: indicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)

    view.addConstraints([centerX, centerY])
  }
  
  private func layoutPlayerView() {
    playerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playerViewSingleTapped(_:))))

    view.addSubview(playerView)
    
    playerView.translatesAutoresizingMaskIntoConstraints = false
    
    let leading = NSLayoutConstraint(item: playerView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: playerView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0)
    let top = NSLayoutConstraint(item: playerView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
    let bottom = NSLayoutConstraint(item: playerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    
    view.addConstraints([leading, trailing, top, bottom])
  }
  
  private func layoutControlButton() {
    controlButton.hidden = true
    
    controlButton.setImage(imageWithName("play"), forState: .Normal)
    controlButton.addTarget(self, action: #selector(controlPlay), forControlEvents: .TouchUpInside)
    
    view.addSubview(controlButton)
    
    controlButton.translatesAutoresizingMaskIntoConstraints = false
    
    let centerX = NSLayoutConstraint(item: controlButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
    let centerY = NSLayoutConstraint(item: controlButton, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
    
    view.addConstraints([centerX, centerY])
  }
  
  private func showControlButtonWithAutoHidden() {
    controlButton.hidden = false
    controlButtonHiddenTimer.invalidate()
    controlButtonHiddenTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(hideControlButton), userInfo: nil, repeats: false)
  }
  
  private func autoPlay() {
    if isViewAppear && canAutoPlay {
      play = true
    }
  }
  
}
