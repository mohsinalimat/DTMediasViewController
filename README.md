## Introduction

![Demo](Demo.gif)

Browse photo, gif and video. Swipe left or right to see next or previous. Pinch to zoom in or out photo and gif. Video with control button to play or pause. Single tap should dismiss view controller.

## Installation

### Requirement

iOS 8+

### [CocoaPods](http://cocoapods.org)

To install DTMediasViewController add a dependency to your Podfile:

```
pod "DTMediasViewController"
```

### [Carthage](https://github.com/Carthage/Carthage)

First, add FLAnimatedImage to your Cartfile and update. It is needed to support gif:

```
github "Flipboard/FLAnimatedImage"
```

```
carthage update --platform ios
```

Second, add DTMediasViewController to your Cartfile and update:

```
github "danjiang/DTMediasViewController"
```

```
carthage update --platform ios
```

## Usage

### Import

```swift
import DTMediasViewController
```

### Load Mixed Local and Remote Medias

```swift
class ViewController: UIViewController {
  
  private let session = NSURLSession.sharedSession()
  private let medias = [DTMedia(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("animate", withExtension: "gif")!)!),
                        DTMedia(image: UIImage(named: "apple-keynote")!),
                        DTMedia(type: .Video, url: NSURL(string: "https://ob0h37q93.qnssl.com/waiting.mp4?avvod/m3u8/pipeline/da/s/960x640/vb/1000k")!),
                        DTMedia(type: .Gif, url: NSURL(string: "http://www.uimaker.com/uploads/allimg/141226/101RIF6-3.gif?imageView2/2/q/90")!),
                        DTMedia(type: .Photo, url: NSURL(string: "http://img5.imgtn.bdimg.com/it/u=1879925847,3681677304&fm=11&gp=0.jpg")!)]
  private let placeholderImage = UIImage(named: "placeholder_large")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func showMedias(sender: AnyObject) {
    let mediasViewController = DTMediasViewController(medias: medias, photoPlaceholderImage: placeholderImage, gifPlaceholderImage: placeholderImage, currentPage: 0)
    mediasViewController.handler = self
    showDetailViewController(mediasViewController, sender: nil)
  }
  
}

// MARK - DTPhotosViewControllerPhotosURLHandler

extension ViewController: DTMediasViewControllerPhotoURLHandler {
  
    func mediasViewController(mediasViewController: DTMediasViewController, photo: DTMedia, viewController: UIViewController) {
    let task = session.dataTaskWithURL(photo.url!) { (data, response, error) in
      if let error = error {
        print(error)
      } else if let data = data {
        dispatch_async(dispatch_get_main_queue(), {
          var newPhoto = photo
          if newPhoto.type == .Gif {
            newPhoto.data = data
            mediasViewController.setPhoto(newPhoto, forViewController: viewController)
          } else if let image = UIImage(data: data) {
            newPhoto.image = image
            mediasViewController.setPhoto(newPhoto, forViewController: viewController)
          }
        })
      }
    }
    task.resume()
  }
  
}
```
