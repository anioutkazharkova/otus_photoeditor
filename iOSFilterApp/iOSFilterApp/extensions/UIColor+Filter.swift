//
//  UIColor+Filter.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func createColorSet() -> [CGColor] {
        let hsb = self.hsb()        
        return createColorSet(lum: hsb.2)
    }
    
    func normalizeHue(shift: CGFloat) -> CGFloat {
        let currentHue = self.hue() + shift
        let normalizedHue = currentHue < 0 ? currentHue + 1.0 : currentHue > 1 ? (currentHue - 1.0) : currentHue
        return normalizedHue
    }
    
    func createColorSet(lum: CGFloat) -> [CGColor] {
        
        let hsb = self.hsb()
        var colors=[CGColor]()
        let step = 30
        for var _ch in -90..<90 {
            let currentHue = CGFloat(_ch)/360.0
            let normalizedHue = normalizeHue(shift: currentHue)
            
            let color = UIColor(hue: normalizedHue, saturation: hsb.1, brightness: lum, alpha: 1)
            colors.append(color.cgColor)
            _ch += step
        }
        return colors
    }
    
    func createLumSet() -> [CGColor] {
        return [self.colorWithLum(lum: 0.3).cgColor,
                self.colorWithLum(lum: 0.5).cgColor,
                self.colorWithLum(lum: 0.7).cgColor]
    }
    
}
