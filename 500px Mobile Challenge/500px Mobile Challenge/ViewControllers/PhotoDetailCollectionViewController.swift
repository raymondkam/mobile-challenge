//
//  PhotoDetailCollectionViewController.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-13.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoDetailCollectionViewControllerDelegate: class {
    func photoDetailCollectionViewControllerDidScrollToNewIndexPath(_: PhotoDetailCollectionViewController, indexPath: IndexPath)
}

private let reuseIdentifier = "PhotoDetailCell"

class PhotoDetailCollectionViewController: UIViewController {

    var dataSource = [Photo]()
    var currentIndexPath: IndexPath?
    weak var delegate: PhotoDetailCollectionViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoDetailsStackView: UIStackView!
    @IBOutlet weak var userThumbnailImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up collection view delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let currentIndexPath = currentIndexPath {
            collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: false)
            
            let photo = dataSource[currentIndexPath.item]
            updatePhotoDetails(with: photo)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
        
        coordinator.animate(alongsideTransition: { [weak self] (context:UIViewControllerTransitionCoordinatorContext) in
            guard let currentIndexPath = self?.currentIndexPath else {
                return
            }
            
            self?.collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: false)
            
        }) { (context:UIViewControllerTransitionCoordinatorContext) in
            
        }
    }
    
    fileprivate func updatePhotoDetails(with photo: Photo) {
        let user = photo.user
        let url = URL(string: user.userPicUrl)
        userThumbnailImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        usernameLabel.text = user.fullName
        titleLabel.text = photo.name
        votesLabel.text = "\(photo.votesCount) people"
    }
    
    @IBAction func handleCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoDetailCollectionViewController: UICollectionViewDelegate {
    
}

extension PhotoDetailCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoDetailCollectionViewCell
        
        let photo = dataSource[indexPath.item]
        var placeholderImage: Image?
        
        if let lowResUrlString = photo.lowResUrlString {
            ImageCache.default.retrieveImage(forKey: lowResUrlString, options: nil) { (image, cacheType) in
                if let image = image {
                    placeholderImage = image
                }
            }
        }
        
        if let highResString = photo.highResUrlString {
            photoDetailCell.imageView.kf.setImage(with: URL(string: highResString), placeholder: placeholderImage, options: [.transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
        } else {
            if let lowResUrlString = photo.lowResUrlString {
                photoDetailCell.imageView.kf.setImage(with: URL(string: lowResUrlString))
            }
        }
        
        return photoDetailCell
    }

}

extension PhotoDetailCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
}

extension PhotoDetailCollectionViewController: UIScrollViewDelegate {
    
    /*
     * Know which index path the collection view is on after a
     * swipe to the next image
     * From https://stackoverflow.com/a/36549067/5091298
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        if currentIndexPath != visibleIndexPath {
            currentIndexPath = visibleIndexPath
            
            let photo = dataSource[visibleIndexPath.item]
            updatePhotoDetails(with: photo)
            
            delegate?.photoDetailCollectionViewControllerDidScrollToNewIndexPath(self, indexPath: visibleIndexPath)
        }
        
    }
    
}
