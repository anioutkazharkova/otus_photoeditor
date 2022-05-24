//
//  FilterManager.swift
//  PhotoEditor
//
//  Created by Anna Zharkova on 19.05.2022.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

class FilterManager : NSObject {
    static let shared = FilterManager()
    
    var defaultImage: UIImage? = nil
    var selectedImage: UIImage? = nil
    var currentFilter: CIFilter? = nil
    var selectFilter: CIFilter? = nil
    
    let context = CIContext()
    
    lazy var filterList = ["CISepiaTone", "CIPhotoEffectChrome",
                           "CIPixellate",
                           "CITwirlDistortion",
                           "CIUnsharpMask",
                           "CIVignette",
                           "CIColorMonochrome",
                           "CIGaussianBlur",
                           "CIBumpDistortion",
                           "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
    
    
    
    
    func prepareImages() async -> [ImageItem] {
        var images = [ImageItem]()
        await withTaskGroup(of: ImageItem?.self, body: { group in
            for i in 0..<filterList.count {
                group.addTask {
                    if let image = await self.setFilterToDefault(index: i) {
                    return ImageItem(image: image, order: i)
                    } else {
                        return nil
                    }
                }
            }
            for await image in group {
                if let image = image {
                    images.append(image)
                }
            }
        })
        return images
    }
    
    func setSelectedFilter(index: Int, image: UIImage, _ intensity: Int = 0) async -> UIImage? {
        self.selectedImage = image
        guard let defaultImage = defaultImage else {
            return nil
        }

        self.selectFilter = CIFilter(name: filterList[index])
        
        guard let filter = self.selectFilter else {return nil }
        let ciImage =  CIImage(image: defaultImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        return try? await applyProcessing(filter: filter, image: image, intensity)
    }
  
    func setFilterToDefault(index: Int) async ->UIImage? {
        guard let defaultImage = defaultImage else {
            return nil
        }
        
        currentFilter = CIFilter(name: filterList[index])
        guard let currentFilter = currentFilter else {
            
            return nil
        }
        
        let ciImage =  CIImage(image: defaultImage)
        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        return try? await applyProcessing(filter: currentFilter, image: defaultImage)
    }
    
    func applyProcessing(filter: CIFilter, image: UIImage, _ baseIntencity: Int = 0) async throws-> UIImage? {
        return await withCheckedContinuation { continuation in
            let inputKeys = filter.inputKeys

             if inputKeys.contains(kCIInputIntensityKey) {
                 let intensity = baseIntencity
                 
                 filter.setValue(intensity, forKey: kCIInputIntensityKey) }
             if inputKeys.contains(kCIInputRadiusKey) {
                 let intensity = baseIntencity * 200
                 filter.setValue(intensity, forKey: kCIInputRadiusKey) }
             if inputKeys.contains(kCIInputScaleKey) {
                 let intensity = baseIntencity * 10
                 filter.setValue(intensity, forKey: kCIInputScaleKey) }
             if inputKeys.contains(kCIInputCenterKey) { filter.setValue(CIVector(x: image.size.width / 2, y: image.size.height / 2), forKey: kCIInputCenterKey) }

            if let resultImage = filter.outputImage, let extent = filter.outputImage?.extent, let cgimg = context.createCGImage(resultImage, from: extent) {
                 let processedImage = UIImage(cgImage: cgimg)
                     continuation.resume(returning: processedImage)
                 } else {
                     continuation.resume(returning: nil)
                 }
            
        }
        }
    
}
