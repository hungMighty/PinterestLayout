//
//  ImaggaRouter.swift
//  PhotoTagger
//
//  Created by 2B on 12/8/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire
import CoreTelephony

public enum ImagesRouter: URLRequestConvertible {
  
  static let baseURLPath = "https://api.flickr.com/services/rest"
  
  case searchContents(String)
  
  var method: HTTPMethod {
    switch self {
    case .searchContents:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .searchContents:
      return ""
    }
  }
  
  
  public func asURLRequest() throws -> URLRequest {
    let parameters: [String: Any] = {
      switch self {
        
      case .searchContents(let searchTerm):
        guard let escapedTerm = searchTerm
          .addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            print("Search Term is in wrong Format")
            return [:]
        }
        
        return [
          "method": "flickr.photos.search",
          "text": escapedTerm,
          "per_page": 30,
          "format": "json",
          "nojsoncallback": "1"
        ]
      }
    }()
    
    let url = try ImagesRouter.baseURLPath.asURL()
    
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    request.setValue(Constants.apiKeys.flickr, forHTTPHeaderField: "Authorization")
    request.timeoutInterval = TimeInterval(10 * 1000)
    
    return try URLEncoding.default.encode(request, with: parameters)
  }
  
}
