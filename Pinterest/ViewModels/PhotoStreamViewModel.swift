//
//  PhotoStreamViewModel.swift
//  Pinterest
//
//  Created by 2B on 3/3/18.
//  Copyright © 2018 Razeware LLC. All rights reserved.
//

import Foundation
import Alamofire


enum PhotoStreamOutput<T> {
  case success(T)
  case failure(String)
}

class PhotoStreamViewModel {
  
  var flickrPhotos = [FlickrPhoto]()
  var defaultPhotos = Photo.allPhotos()
  
  
  init() {}
  
  func getImagesWithTerm(_ searchTerm: String?, desireNum: Int,
                         completion: @escaping (PhotoStreamOutput<String>) -> ()) {
    guard let term = searchTerm, !term.isEmpty else {
      completion(.failure("Please input a Search Term!"))
      return
    }
    
    Alamofire
      .request(ImagesRouter.searchContents(term, desireNum))
      .responseJSON { [weak self] response in
        guard response.result.isSuccess else {
          if let errCode = response.response?.statusCode {
            completion(.failure("Search API returns error code: \(errCode)" +
              "and error: \(response.result.error?.localizedDescription ?? "")"))
          } else {
            completion(.failure("Fail with error: \(response.result.error?.localizedDescription ?? "")"))
          }
          return
        }
        
        guard let resultsDictionary = response.result.value as? [String: Any],
          let photosContainer = resultsDictionary["photos"] as? [String: Any],
          let photosReceived = photosContainer["photo"] as? [[String: Any]]
          else {
            completion(.failure("Fail to parse images json"))
            return
        }
        
        var photos = [FlickrPhoto]()
        for photoObject in photosReceived {
          guard let flickrPhoto = FlickrPhoto(withJson: photoObject),
            let url = flickrPhoto.flickrImageURL(),
            let imageData = try? Data(contentsOf: url as URL) else {
              continue
          }
          
          if let image = UIImage(data: imageData) {
            flickrPhoto.thumbnail = image
            photos.append(flickrPhoto)
          }
        }
        
        self?.flickrPhotos = photos
        completion(.success("Flickr Images were retrieved successfully"))
    }
  }
  
}
