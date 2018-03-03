//
//  NetworkState.swift
//  Pinterest
//
//  Created by 2B on 3/3/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire


class NetworkState {
  
  // MARK: - If using Wifi then we can upload images
  
  func isReachableViaWifi(host: String) -> Bool {
    guard let connectionState = NetworkReachabilityManager(host: host) else {
      print("Wrong Host!")
      return false
    }
    
    return connectionState.isReachableOnEthernetOrWiFi
  }
  
}
