//
//  DTMedia.swift
//  DTMediasViewController
//
//  Created by 但 江 on 16/8/19.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit

public enum DTMediaType {
  case Photo
  case Gif
  case Video
}

public struct DTMedia {
  
  public let type: DTMediaType
  public var image: UIImage?
  public var url: NSURL?
  public var data: NSData?
  
  public init(image: UIImage) {
    self.type = .Photo
    self.image = image
  }
  
  public init(data: NSData) {
    self.type = .Gif
    self.data = data
  }
  
  public init(type: DTMediaType, url: NSURL) {
    self.type = type
    self.url = url
  }
  
}