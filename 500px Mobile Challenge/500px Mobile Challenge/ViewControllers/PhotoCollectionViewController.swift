//
//  PhotoCollectionViewController.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-12.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "PhotoCell"
private let loadNextPageIndexPathOffset = 4
private let fetchNumberOfImages = 20

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var dataSource = [Photo]()
    var nextPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNextPageOfPhotos()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {
            print("no segue identifier")
            return
        }
        switch segueIdentifer {
        case "PhotoDetail":
            if let cell = sender as? PhotoCollectionViewCell {
                if let indexPath = collectionView?.indexPath(for: cell) {
                    let photoDetailViewController = segue.destination as! PhotoDetailCollectionViewController
                    photoDetailViewController.dataSource = dataSource
                    photoDetailViewController.currentIndexPath = indexPath
                    photoDetailViewController.delegate = self
                }
            }
        default:
            print("segue not recognized")
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    fileprivate func fetchNextPageOfPhotos() {
        APIManager.sharedInstance.fetchPhotos(feature: APIConstants.FeaturePopular, page: nextPage, numberOfImages: fetchNumberOfImages, imageSize: APIConstants.ImageSize300pxHigh, includeNsfw: false) { [weak self] (photoStream, error) in
            guard error == nil else {
                print("error fetching photos \(String(describing: error?.localizedDescription))")
                return
            }
            guard let photoStream = photoStream else {
                print("no photostream received")
                return
            }
            self?.dataSource.append(contentsOf: photoStream.photos)
            self?.collectionView?.reloadData()
            self?.nextPage += 1
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = dataSource[indexPath.item]
        if let urlString = (photo.images.first { (dictionary) -> Bool in
            return dictionary["url"] != nil
        })?["url"] as? String {
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // start fetching the next set of photos
        if indexPath.item == dataSource.count - loadNextPageIndexPathOffset {
            fetchNextPageOfPhotos()
        }
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
    }

}

extension PhotoCollectionViewController: PhotoDetailCollectionViewControllerDelegate {
    
    func photoDetailCollectionViewControllerDidScrollToNewIndexPath(_: PhotoDetailCollectionViewController, indexPath: IndexPath) {
        collectionView?.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
}
