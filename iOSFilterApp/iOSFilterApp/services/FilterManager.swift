//
//  FilterManager.swift
//  iOSFilterApp
//
//  Created by Anna Zharkova on 18.05.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class FilterManager {
    static let shared = FilterManager()
    var currentImage: UIImage? = nil
    private var currentFilter: CIFilter? = nil
    private var context: CIContext? = nil
    
    lazy var filterList = ["CISepiaTone", "CIPhotoEffectChrome",
                           "CIPixellate",
                           "CITwirlDistortion",
                           "CIUnsharpMask",
                           "CIVignette",
                           "CIColorMonochrome",
                           "CIGaussianBlur",
                           "CIBumpDistortion",
                           "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
    
  
    
    func prepareImages() async -> [UIImage]  {
        var images = [UIImage]()
            await withTaskGroup(of: UIImage.self) { group in
                for i in 0..<filterList.count {
                    group.addTask {
                        let image = await self.setFilter(index: i)
                        return image ?? UIImage()
                    }
                }
                for await image in group {
                    images.append(image)
                }
            }
        return images
    }
    
    
    func setFilter(index: Int, baseIntencity: Int = 0) async -> UIImage? {
        context = CIContext()
        guard let currentImage = currentImage else {
            return nil
        }

        currentFilter = CIFilter(name: filterList[index])
        guard let currentFilter = currentFilter else {
            return nil
        }

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

       return try? await  applyProcessing(baseIntencity)
    }
    
    func applyProcessing(_ baseIntencity: Int = 0) async throws -> UIImage? {
        return await withCheckedContinuation { continuation in
        guard let currentImage = currentImage else {
            return   continuation.resume(returning: nil)
        }

            guard let inputKeys = currentFilter?.inputKeys else {
                return continuation.resume(returning: nil)
            }

        if inputKeys.contains(kCIInputIntensityKey) {
            let intensity = baseIntencity
            
            currentFilter?.setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            let intensity = baseIntencity * 200
            currentFilter?.setValue(intensity, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            let intensity = baseIntencity * 10
            currentFilter?.setValue(intensity, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter?.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

            if let currentFilter = currentFilter, let outputImage = currentFilter.outputImage, let cgimg = context?.createCGImage(outputImage, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
                continuation.resume(returning: processedImage)
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
}
