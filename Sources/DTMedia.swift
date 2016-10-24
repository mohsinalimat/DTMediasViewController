//
//  DTMedia.swift
//  DTMediasViewController
//
//  Created by 但 江 on 16/8/19.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit

public enum DTMediaType {
  case photo
  case gif
  case video
}

public struct DTMedia {
  
  public let type: DTMediaType
  public var image: UIImage?
  public var url: URL?
  public var data: Data?
  
  public init(image: UIImage) {
    self.type = .photo
    self.image = image
  }
  
  public init(data: Data) {
    self.type = .gif
    self.data = data
  }
  
  public init(type: DTMediaType, url: URL) {
    self.type = type
    self.url = url
  }
  
}
