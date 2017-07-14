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

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var dataSource = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.fetchPhotos(feature: APIConstants.FeaturePopular, numberOfImages: 20, imageSize: APIConstants.ImageSize300pxHigh) { [weak self] (photoStream, error) in
            guard error == nil else {
                print("error fetching photos \(String(describing: error?.localizedDescription))")
                return
            }
            guard let photoStream = photoStream else {
                print("no photostream received")
                return
            }
            self?.dataSource = photoStream.photos
            self?.collectionView?.reloadData()
        }
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
            cell.imageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
    }
    
}

extension PhotoCollectionViewController: PhotoDetailCollectionViewControllerDelegate {
    
    func photoDetailCollectionViewControllerDidScrollToNewIndexPath(_: PhotoDetailCollectionViewController, indexPath: IndexPath) {
        collectionView?.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
}
