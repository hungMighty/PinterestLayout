//
//  CustomNavigationBar.swift
//  Pinterest
//
//  Created by 2B on 3/4/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit


class CustomNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIApplication.shared.statusBarStyle = .lightContent
    
    self.delegate = self
    self.navigationBar.barTintColor = UIColor.white
    self.navigationBar.tintColor = UIColor.white
    self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    self.navigationBar.isTranslucent = false
  }
  
}

extension CustomNavigationController: UINavigationControllerDelegate {
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    let item = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
    viewController.navigationItem.backBarButtonItem = item
  }
  
}
