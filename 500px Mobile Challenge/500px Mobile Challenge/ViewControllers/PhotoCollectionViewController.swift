
//
//  PhotoCollectionViewController.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-12.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import UIKit
import Kingfisher
import GreedoLayout

let fetchNumberOfImages = 20

private let reuseIdentifier = "PhotoCell"
private let loadNextPageIndexPathOffset = 5
private let greedoRowMaximumHeight: CGFloat = 200.0

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var dataSource = [Photo]()
    var nextPage = 1
    var greedoLayout: GreedoCollectionViewLayout?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNextPageOfPhotos()
        
        if let collectionView = collectionView {
            greedoLayout = GreedoCollectionViewLayout.init(collectionView: collectionView)
            greedoLayout?.rowMaximumHeight = greedoRowMaximumHeight
            greedoLayout?.dataSource = self
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
                    photoDetailViewController.nextPage = nextPage
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
        
        coordinator.animate(alongsideTransition: { (context) in
            flowLayout.invalidateLayout()
        }) { [weak self] (context) in
            self?.greedoLayout?.clearCache()
            self?.collectionView?.reloadData()
        }
        
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
        return greedoLayout!.sizeForPhoto(at: indexPath)
    }

}

extension PhotoCollectionViewController: PhotoDetailCollectionViewControllerDelegate {
    func photoDetailCollectionViewControllerDidFetchNextPageOfPhotos(_: PhotoDetailCollectionViewController, photos: [Photo], nextPage: Int) {
        self.nextPage = nextPage
        self.dataSource.append(contentsOf: photos)
        self.collectionView?.reloadData()
    }

    
    func photoDetailCollectionViewControllerDidScrollToNewIndexPath(_: PhotoDetailCollectionViewController, indexPath: IndexPath) {
        collectionView?.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
}

extension PhotoCollectionViewController: GreedoCollectionViewLayoutDataSource {
    func greedoCollectionViewLayout(_ layout: GreedoCollectionViewLayout!, originalImageSizeAt indexPath: IndexPath!) -> CGSize {
        if indexPath.item < dataSource.count {
            let photo = dataSource[indexPath.item]
            return CGSize(width: photo.width, height: photo.height)
        }
        return .zero
    }
}
