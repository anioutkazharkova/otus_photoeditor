//
//  Colors.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

enum Colors: CGFloat {
    case red, orange, yellow, green, aqua, blue, purple, magenta
}

extension Colors {
    var hue: CGFloat {
        get {
            return self.getColor().hue()
        }
    }
    
    func getColor() -> UIColor {
        switch (self) {
        case .red:
            return ColorUtility.red
        case .orange:
            return ColorUtility.orange
        case .yellow:
            return ColorUtility.yellow
        case .green:
            return ColorUtility.green
        case .aqua:
            return ColorUtility.aqua
        case .blue:
            return ColorUtility.blue
        case .purple:
            return ColorUtility.purple
        case .magenta:
            return ColorUtility.magenta
        }
    }
}
