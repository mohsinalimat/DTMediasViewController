//
//  DTPlayerView.swift
//  DTMediasViewController
//
//  Created by 但 江 on 16/8/31.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit
import AVFoundation

class DTPlayerView: UIView {

  override class var layerClass : AnyClass {
    return AVPlayerLayer.self
  }
  
  var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue
    }
  }
  
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }

}
