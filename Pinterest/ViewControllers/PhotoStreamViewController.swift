/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import AVFoundation

class PhotoStreamViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  let viewModel = PhotoStreamViewModel()
  
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
  }
  
  // MARK: - View life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(_:)),
                                           name: NSNotification.Name.UIKeyboardWillShow,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardDidShow(_:)),
                                           name: NSNotification.Name.UIKeyboardDidShow,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardDidHide(_:)),
                                           name: NSNotification.Name.UIKeyboardDidHide,
                                           object: nil)
    
//    if let patternImage = UIImage(named: "Pattern") {
//      view.backgroundColor = UIColor(patternImage: patternImage)
//    }
    
    view.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
    customizeSearchBarTheme()
    
    collectionView?.backgroundColor = .clear
    collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
//    if #available(iOS 10, *) {
//      collectionView.isPrefetchingEnabled = false
//    }
    loadCollectionViewCustomLayout()
    
    invokeSearchWith(Term: "Ocean")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: - Orientation
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    loadCollectionViewCustomLayout()
  }
  
  fileprivate func loadCollectionViewCustomLayout() {
    DispatchQueue.main.async {
      self.collectionView.collectionViewLayout.invalidateLayout()
      
      var layout: PinterestLayout
      let orientation = UIApplication.shared.statusBarOrientation
      let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
      if isPortrait {
        layout = PinterestLayout(columnsNum: 2)
      } else {
        layout = PinterestLayout(columnsNum: 3)
      }
      layout.delegate = self
      self.collectionView.collectionViewLayout = layout
    }
  }
  
  fileprivate func customizeSearchBarTheme() {
    searchBar.placeholder = "Search"
    searchBar.barTintColor = UIColor.white
  }
  
  fileprivate func invokeSearchWith(Term term: String?) {
    MyViewUtil.showLoadingIndicator()
    viewModel.getImagesWithTerm(term, desireNum: 21) { [unowned self] (result) in
      MyViewUtil.removeLoadingIndicator()
      
      switch result {
      case .success(_):
        print("Success")
        DispatchQueue.main.async {
          self.searchBar.text = ""
          self.searchBar.setShowsCancelButton(false, animated: true)
          
          self.collectionView.collectionViewLayout.invalidateLayout()
          self.collectionView.reloadData()
          self.collectionView.setNeedsLayout()
          self.collectionView.layoutIfNeeded()
//          self.loadCollectionViewCustomLayout()
        }
      case .failure(let mess):
        print(mess)
        let alert = UIAlertController(title: "Error!", message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
}

extension PhotoStreamViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.flickrPhotos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: AnnotatedPhotoCell.id, for: indexPath)
      as? AnnotatedPhotoCell else {
        return UICollectionViewCell()
    }
    
    cell.photo = viewModel.flickrPhotos[indexPath.item]
    return cell
  }
  
}

extension PhotoStreamViewController: PinterestLayoutDelegate {
  
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    guard let img = viewModel.flickrPhotos[indexPath.item].thumbnail else {
        return 0
    }
    return CGFloat(img.size.height)
  }
  
}

extension PhotoStreamViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
    return CGSize(width: itemSize, height: itemSize)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let viewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: DetailImageViewController.id)
      as? DetailImageViewController else {
        return
    }
    
    MyViewUtil.showLoadingIndicator()
    viewModel.flickrPhotos[indexPath.item].loadLargeImage { [weak self] (flickRPhoto, err) in
      MyViewUtil.removeLoadingIndicator()
      
      if let err = err {
        let alert = UIAlertController(title: "Error!",
                                      message: err.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self?.present(alert, animated: true, completion: nil)
        
        return
      }
      viewController.curImage = flickRPhoto.largeImage
      self?.searchBar.resignFirstResponder()
      self?.navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
}

extension PhotoStreamViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.searchBar.setShowsCancelButton(false, animated: true)
    self.searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    invokeSearchWith(Term: searchBar.text)
    self.searchBar.resignFirstResponder()
  }
  
}

// MARK: - Keyboard Observing
extension PhotoStreamViewController {
  
  @objc func keyboardWillShow(_ noti: Notification) {
  }
  
  @objc func keyboardDidShow(_ noti: Notification) {
  }
  
  @objc func keyboardDidHide(_ noti: Notification) {
  }
  
}
