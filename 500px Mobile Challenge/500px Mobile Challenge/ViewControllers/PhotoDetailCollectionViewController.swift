//
//  PhotoDetailCollectionViewController.swift
//  500px Mobile Challenge
//
//  Created by Raymond Kam on 2017-07-13.
//  Copyright © 2017 Raymond Kam. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoDetailCell"

class PhotoDetailCollectionViewController: UIViewController {

    var dataSource = [Photo]()
    var currentIndexPath: IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up collection view delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        if let currentIndexPath = currentIndexPath {
            collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: false)
        }
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
        if let urlString = (photo.images.first { (dictionary) -> Bool in
            return dictionary["url"] != nil
        })?["url"] as? String {
            let url = URL(string: urlString)
            photoDetailCell.imageView.kf.setImage(with: url)
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
