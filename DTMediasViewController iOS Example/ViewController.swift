//
//  ViewController.swift
//  DTPhotosVDTMediasViewControlleriewControllerDemo
//
//  Created by 但 江 on 16/6/1.
//  Copyright © 2016年 Dan Thought Studio. All rights reserved.
//

import UIKit
import DTMediasViewController

class ViewController: UIViewController {
  
  fileprivate let session = URLSession.shared
  fileprivate let medias = [DTMedia(data: try! Data(contentsOf: Bundle.main.url(forResource: "animate", withExtension: "gif")!)),
                        DTMedia(image: UIImage(named: "apple-keynote")!),
                        DTMedia(type: .video, url: URL(string: "https://ob0h37q93.qnssl.com/waiting.mp4?avvod/m3u8/pipeline/da/s/960x640/vb/1000k")!),
                        DTMedia(type: .gif, url: URL(string: "http://www.uimaker.com/uploads/allimg/141226/101RIF6-3.gif?imageView2/2/q/90")!),
                        DTMedia(type: .photo, url: URL(string: "http://img5.imgtn.bdimg.com/it/u=1879925847,3681677304&fm=11&gp=0.jpg")!)]
  fileprivate let placeholderImage = UIImage(named: "placeholder_large")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func showMedias(_ sender: AnyObject) {
    let mediasViewController = DTMediasViewController(medias: medias, photoPlaceholderImage: placeholderImage, gifPlaceholderImage: placeholderImage, currentPage: 0)
    mediasViewController.handler = self
    showDetailViewController(mediasViewController, sender: nil)
  }
  
}

// MARK - DTPhotosViewControllerPhotosURLHandler

extension ViewController: DTMediasViewControllerPhotoURLHandler {
  
    func mediasViewController(_ mediasViewController: DTMediasViewController, photo: DTMedia, viewController: UIViewController) {
    let task = session.dataTask(with: photo.url!) { (data, response, error) in
      if let error = error {
        print(error)
      } else if let data = data {
        DispatchQueue.main.async {
          var newPhoto = photo
          if newPhoto.type == .gif {
            newPhoto.data = data
            mediasViewController.setPhoto(newPhoto, forViewController: viewController)
          } else if let image = UIImage(data: data) {
            newPhoto.image = image
            mediasViewController.setPhoto(newPhoto, forViewController: viewController)
          }
        }
      }
    }
    task.resume()
  }
  
}
