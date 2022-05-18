//
//  UIColor+HSL.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

//Методв для работы с HSL
extension UIColor {
    convenience  init(hue: CGFloat) {
        let correctHue = hue < 0 ? 1 + hue : hue
        self.init(hue: correctHue, saturation: 1, lightness: 0.5)
    }
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1) {
        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        let saturation = lightness > 0 ? 2 * offset / brightness : 0
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0, hue: CGFloat = 0
        guard
            getRed(&red, green: &green, blue: &blue, alpha: &alpha),
            getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            else { return nil }
        let upper = max(red, green, blue)
        let lower = min(red, green, blue)
        let range = upper - lower
        let lightness = (upper + lower) / 2
        let saturation = range == 0 ? 0 : range / (lightness < 0.5 ? lightness * 2 : 2 - lightness * 2)
        return (hue, saturation, lightness, alpha)
    }
    
    func hslColor(hue: CGFloat, sat: CGFloat, lum: CGFloat) -> UIColor {
        
        return UIColor(hue: hue, saturation: sat, lightness: lum, alpha: 1.0)
    }
    
    func hslColor() -> UIColor {
        if  let hsl = hsl {
            return hslColor(hue: hsl.hue, sat: hsl.saturation, lum: hsl.lightness)} else {
            return self
        }
    }
    
    func hslColor(hue: CGFloat) -> UIColor {
        if  let hsl = hsl {
            return hslColor(hue: hue, sat: hsl.saturation, lum: hsl.lightness)} else {
            return self
        }
    }
    
    func hslColor(lum: CGFloat) -> UIColor {
        if  let hsl = hsl {
            return hslColor(hue: hsl.hue, sat: hsl.saturation, lum: lum)} else {
            return self
        }
    }
    
    func hsb() -> (CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return (hue, saturation, brightness)
    }
    
    func hue() -> CGFloat {
        return hsb().0
    }
    
    func saturation() -> CGFloat {
        return hsb().1
    }
    
    func brightness() -> CGFloat {
        return hsb().2
    }
    
   
    func colorWithSat(sat: CGFloat) -> UIColor {
        let hsb = self.hsb()
        return UIColor(hue: hsb.0, saturation: sat, brightness: hsb.2, alpha: 1)
    }
    
    func colorWithLum(lum: CGFloat) -> UIColor {
        return hslColor(lum: lum)
    }
    
}
