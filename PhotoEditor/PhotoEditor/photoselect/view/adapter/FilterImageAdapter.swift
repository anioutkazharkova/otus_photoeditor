//
//  FilterImageAdapter.swift
//  PhotoEditor
//
//  Created by Anna Zharkova on 19.05.2022.
//

import Foundation

import Foundation
import UIKit

class FilterImageAdapter : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var images: [ImageItem] = [ImageItem]()
    
    var side: CGFloat = 130.0
    
    weak var listOwner: ListOwner?
    
    func setupItems(items: [ImageItem]) {
        self.images = [ImageItem]()
        self.images.append(contentsOf: items)
    }
    
    func changeItem(index: Int, item: ImageItem) {
        self.images[index] = item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellId, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.setupOutputImage(image: images[indexPath.row].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.listOwner?.selectImage(index: indexPath.row)
    }
    
}
