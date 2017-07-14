//
//  PhotoDetailCollectionViewController.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-13.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import UIKit

protocol PhotoDetailCollectionViewControllerDelegate: class {
    func photoDetailCollectionViewControllerDidScrollToNewIndexPath(_: PhotoDetailCollectionViewController, indexPath: IndexPath)
}

private let reuseIdentifier = "PhotoDetailCell"

class PhotoDetailCollectionViewController: UIViewController {

    var dataSource = [Photo]()
    var currentIndexPath: IndexPath?
    weak var delegate: PhotoDetailCollectionViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        }
    }

    @IBAction func handleCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        if let urlString = (photo.images.first { (dictionary) -> Bool in
            return dictionary["url"] != nil
        })?["url"] as? String {
            let url = URL(string: urlString)
            photoDetailCell.imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
        
        // Configure the cell
        
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
        
        print(visibleIndexPath)
        
        currentIndexPath = visibleIndexPath
        
        delegate?.photoDetailCollectionViewControllerDidScrollToNewIndexPath(self, indexPath: visibleIndexPath)
    }
    
}
