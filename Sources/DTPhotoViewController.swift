//
//  DTPhotoViewController.swift
//  DTMediasViewController
//
//  Created by 但 江 on 16/6/1.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit
import FLAnimatedImage

protocol DTPhotoViewControllerDelegate {
  func photoViewControllerLoadPhoto(_ photoViewController: DTPhotoViewController)
}

class DTPhotoViewController: DTMediaViewController {
  
  var delegate: DTPhotoViewControllerDelegate?
  var photoPlaceholderImage: UIImage?
  var gifPlaceholderImage: UIImage?
  var photo: DTMedia
  
  fileprivate let scrollView = UIScrollView()
  fileprivate let imageView: UIImageView
  fileprivate var fitScale: CGFloat = 1

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(photo: DTMedia) {
    self.photo = photo
    if photo.type == .gif {
      imageView = FLAnimatedImageView()
    } else {
      imageView = UIImageView()
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.black
    
    scrollView.backgroundColor = UIColor.black
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delegate = self
    scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollViewSingleTapped(_:))))
    scrollView.isScrollEnabled = false
    
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    let leading = NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
    let top = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
    let bottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    
    view.addConstraints([leading, trailing, top, bottom])
    
    let width = view.bounds.width
    let height = view.bounds.height
    if photo.type == .gif {
      imageView.image = gifPlaceholderImage
    } else {
      imageView.image = photoPlaceholderImage
    }
    imageView.frame = CGRect(x: 0, y: (height - width) / 2, width: width, height: width)
    
    setImageViewWithPhoto(photo)
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    scrollView.zoomScale = fitScale
  }
  
  func setImageViewWithPhoto(_ photo: DTMedia) {
    self.photo = photo
    if photo.type == .gif {
      if let data = photo.data {
        let image = FLAnimatedImage(animatedGIFData: data)!
        let animatedImageView = imageView as! FLAnimatedImageView
        animatedImageView.animatedImage = image
        caculateFitScaleWithImageSize(image.size)
      } else if let _ = photo.url {
        delegate?.photoViewControllerLoadPhoto(self)
      }
    } else {
      if let image = photo.image {
        imageView.image = image
        caculateFitScaleWithImageSize(image.size)
      } else if let _ = photo.url {
        delegate?.photoViewControllerLoadPhoto(self)
      }
    }
  }
  
  func scrollViewSingleTapped(_ recognizer: UITapGestureRecognizer) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  fileprivate func caculateFitScaleWithImageSize(_ size: CGSize) {
    imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    scrollView.contentSize = size
    
    let boundsSize = view.bounds.size
    let scaleWidth = boundsSize.width / scrollView.contentSize.width
    let scaleHeight = boundsSize.height / scrollView.contentSize.height
    fitScale = min(scaleWidth, scaleHeight)
    
    if fitScale < 1 {
      scrollView.minimumZoomScale = fitScale
      scrollView.maximumZoomScale = 1
    } else {
      scrollView.minimumZoomScale = fitScale
      scrollView.maximumZoomScale = fitScale * 1.5
    }
    if scrollView.zoomScale != fitScale {
      scrollView.zoomScale = fitScale
    } else {
      centerScrollViewContents()
    }
  }
  
  fileprivate func centerScrollViewContents() {
    let boundsSize = view.bounds.size
    var contentsFrame = imageView.frame
    
    if contentsFrame.size.width < boundsSize.width {
      contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
    } else {
      contentsFrame.origin.x = 0
    }
    
    if contentsFrame.size.height < boundsSize.height {
      contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
    } else {
      contentsFrame.origin.y = 0
    }
    
    imageView.frame = contentsFrame
  }
  
}

// MARK: - UIScrollViewDelegate

extension DTPhotoViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    centerScrollViewContents()
  }
  
}
