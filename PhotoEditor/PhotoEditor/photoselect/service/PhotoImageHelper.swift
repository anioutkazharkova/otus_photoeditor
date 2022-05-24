//
//  PhotoImageHelper.swift
//  PhotoEditor
//
//  Created by Anna Zharkova on 19.05.2022.
//

import Foundation
import UIKit
import Photos

class PhotoImageHelper: NSObject, PhotoHolderProtocol {
    var assets: PHFetchResult<AnyObject>?
    static let shared = PhotoImageHelper()
    
    var currentAsset: PHAsset?
    
    func saveImage(image: UIImage, successResult:@escaping()->Void,
                   failure: @escaping()->Void) {
        let size = CGSize(width: currentAsset?.pixelWidth ?? 0 , height: currentAsset?.pixelHeight ?? 0)
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { [weak self] success, error in
            guard let self = self else {return}
            if success {
                self.currentAsset = nil
                successResult()
            } else  {
                failure()
            }
        }

    }
    
    func loadAssets(success: @escaping(PHFetchResult<AnyObject>)->Void, failure: @escaping()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.loadAssets(success: success)
        }else {
            PHPhotoLibrary.requestAuthorization {
                status in
                if status == .authorized {
                    self.loadAssets(success: success)

                } else {
                    failure()
                }
            }
        }
    }
    
    func selectAsset(index: Int) {
        self.currentAsset = assets?[index] as? PHAsset
    }
    
    func loadAssets(success: @escaping(PHFetchResult<AnyObject>)->Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 20000
        assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) as? PHFetchResult<AnyObject>
        if let assets = assets {
            success(assets)
        }
    }
    
    func loadImageForCurrentAsset(success: @escaping(UIImage)->Void) {
        let width = UIScreen.main.bounds.width
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .fast
        if let item = currentAsset {
            PHImageManager.default().requestImage(for: item, targetSize: CGSize(width: width, height: width * 0.75), contentMode: .aspectFill, options: option) { image, data in
                if let _image = image {
                    success(_image)
                }
            }
        }
    }
    
    func loadImageForAsset(index: Int, size: CGSize, success: @escaping(UIImage)->Void) {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .fast
        if let item = assets?[index] as? PHAsset {
            PHImageManager.default().requestImage(for: item, targetSize: size, contentMode: .aspectFill, options: option) { image, data in
                if let _image = image {
                    success(_image)
                }
            }
        }
    }
}

protocol PhotoHolderProtocol: AnyObject {
    var assets: PHFetchResult<AnyObject>? {get set}
    
    func loadImageForAsset(index: Int, size: CGSize, success: @escaping(UIImage)->Void)
}
