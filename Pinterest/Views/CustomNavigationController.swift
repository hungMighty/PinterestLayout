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
    let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    item.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    viewController.navigationItem.backBarButtonItem = item
  }
  
}
