//
//  ViewController.swift
//  UIImageSwiftExtensions
//
//  Created by Giacomo Boccardo on 15/09/16.
//  Copyright © 2016 Giacomo Boccardo. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var myImageView: UIImageView!
  
  
  static let id = String(describing: DetailImageViewController.self)
  
  fileprivate var isPortrait = true
  var curImage: UIImage?
  
  // MARK: - View Lifecycles
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 30.0
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let orientation = UIApplication.shared.statusBarOrientation
    isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
    showMyImage()
  }
  
  // MARK: - Orientation
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    isPortrait = UIDevice.current.orientation.isPortrait
    adjustContentMode()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Actions
  
}

// MARK: - Image Processing

extension DetailImageViewController {
  
  fileprivate func showMyImage() {
    if let image = curImage {
      adjustContentMode()
      myImageView.image = image
    }
  }
  
  fileprivate func adjustContentMode() {
    guard let image = curImage else {
      return
    }
    var imageRatio = image.size.height / image.size.width
    if !isPortrait {
      imageRatio = image.size.width / image.size.height
    }
    
    // Image with same ratio as iPhone portrait
    if imageRatio >= 1.5 {
      myImageView.contentMode = .scaleAspectFill
    } else {
      myImageView.contentMode = .scaleAspectFit
    }
  }
  
}

extension DetailImageViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return myImageView
  }
  
}

