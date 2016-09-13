//
//  DTMediasViewController.swift
//  DTMediasViewController
//
//  Created by 但 江 on 16/6/2.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit

public protocol DTMediasViewControllerPhotoURLHandler {
  func mediasViewController(mediasViewController: DTMediasViewController, photo: DTMedia, viewController: UIViewController)
}

public class DTMediasViewController: UIPageViewController {
  
  public var handler: DTMediasViewControllerPhotoURLHandler?
  
  private var mediaViewControllers = [Int: DTMediaViewController]()
  private var currentPage = 0
  private var medias: [DTMedia]
  private var photoPlaceholderImage: UIImage?
  private var gifPlaceholderImage: UIImage?
  private let pageLabel = UILabel()
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public init(medias: [DTMedia], photoPlaceholderImage: UIImage?, gifPlaceholderImage: UIImage?, currentPage: Int) {
    self.medias = medias
    self.photoPlaceholderImage = photoPlaceholderImage
    self.gifPlaceholderImage = gifPlaceholderImage
    self.currentPage = currentPage
    super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
  }

  public override func loadView() {
    super.loadView()
    
    view.backgroundColor = UIColor.blackColor()
    
    dataSource = self
    delegate = self
    
    if medias.count > 1 {
      pageLabel.font = UIFont.systemFontOfSize(14)
      pageLabel.textColor = UIColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 1)
      
      view.addSubview(pageLabel)
      
      pageLabel.translatesAutoresizingMaskIntoConstraints = false
      
      let centerX = NSLayoutConstraint(item: pageLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
      let bottom = NSLayoutConstraint(item: pageLabel, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -10)
      
      view.addConstraints([centerX, bottom])
    }
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    if let photoViewController = mediaViewControllerWithPage(currentPage) {
      setViewControllers([photoViewController], direction: .Forward, animated: false, completion: nil)
    }
    reloadPageLabel()
  }
  
  public func setPhoto(media: DTMedia, forViewController viewController: UIViewController) {
    if let photoViewController = viewController as? DTPhotoViewController {
      photoViewController.setImageViewWithPhoto(media)
    }
  }
  
  private func mediaViewControllerWithPage(page: Int) -> UIViewController? {
    if page >= 0 && page < medias.count {
      if let mediaViewController = mediaViewControllers[page] {
        return mediaViewController
      } else {
        let media = medias[page]
        if media.type == .Video {
          let videoViewController = DTVideoViewController(video: media)
          videoViewController.page = page
          mediaViewControllers[page] = videoViewController
          return videoViewController
        } else {
          let photoViewController = DTPhotoViewController(photo: media)
          photoViewController.delegate = self
          photoViewController.photoPlaceholderImage = photoPlaceholderImage
          photoViewController.gifPlaceholderImage = gifPlaceholderImage
          photoViewController.page = page
          mediaViewControllers[page] = photoViewController
          return photoViewController
        }
      }
    } else {
      return nil
    }
  }
  
  private func reloadPageLabel() {
    pageLabel.text = "\(currentPage + 1) / \(medias.count)"
  }
  
}

// MARK: - UIPageViewControllerDataSource

extension DTMediasViewController: UIPageViewControllerDataSource {
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    if let mediaViewController = viewController as? DTMediaViewController {
      return mediaViewControllerWithPage(mediaViewController.page + 1)
    } else {
      return nil
    }
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    if let mediaViewController = viewController as? DTMediaViewController {
      return mediaViewControllerWithPage(mediaViewController.page - 1)
    } else {
      return nil
    }
  }
  
}

// MARK: - UIPageViewControllerDelegate

extension DTMediasViewController: UIPageViewControllerDelegate {
  
  public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if let mediaViewController = viewControllers?.last as? DTMediaViewController {
        currentPage = mediaViewController.page
        reloadPageLabel()
      }
    }
  }
  
}

// MARK: - DTMediasViewController

extension DTMediasViewController: DTPhotoViewControllerDelegate {
  
  func photoViewControllerLoadPhoto(photoViewController: DTPhotoViewController) {
    handler?.mediasViewController(self, photo: photoViewController.photo, viewController: photoViewController)
  }
  
}
