//
//  MyViewUtil.swift
//  QRCodeGenerator
//
//  Created by Hùng Nguyễn on 1/12/18.
//  Copyright © 2018 Sita. All rights reserved.
//

import Foundation
import UIKit


class MyViewUtil {
  
  static var indicatorView: UIView?
  static var spinner: UIActivityIndicatorView?
  
  static func showLoadingIndicator() {
    guard let window = UIApplication.shared.keyWindow else {
      print("Key Window not found")
      return
    }
    
    self.indicatorView = UIView(frame: CGRect(x: window.frame.origin.x,
                                              y: window.frame.origin.y,
                                              width: window.frame.width,
                                              height: window.frame.height))
    guard let indicatorView = self.indicatorView else {
      print("Indicator View not created")
      return
    }
    
    DispatchQueue.main.async {
      window.addSubview(indicatorView)
      indicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
      let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
      self.spinner = spinner
      spinner.frame = CGRect(x: (window.frame.width - spinner.frame.width) / 2,
                             y: (window.frame.height - spinner.frame.height) / 2,
                             width: spinner.frame.width, height: spinner.frame.height)
      indicatorView.addSubview(spinner)
      spinner.startAnimating()
    }
  }
  
  static func removeLoadingIndicator() {
    guard let indicatorView = self.indicatorView,
      let spinner = self.spinner else {
        print("Indicator View not created")
        return
    }
    DispatchQueue.main.async {
      spinner.stopAnimating()
      spinner.removeFromSuperview()
      indicatorView.removeFromSuperview()
    }
    self.spinner = nil
    self.indicatorView = nil
  }
  
}
