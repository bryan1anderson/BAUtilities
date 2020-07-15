//
//  UIColor.swift
//  Training
//
//  Created by Bryan on 9/28/16.
//  Copyright © 2016 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

public extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

public extension UIColor {
    open class var primary: UIColor {
        return UIColor(red:0.05, green:0.67, blue:0.89, alpha:1.0)
    }
}

public extension UIColor {
    var hue: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return hue
    }
    
    var brightness: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return brightness
    }

    var alpha: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return alpha
    }

}

public extension UIColor {
    
    class var emLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .darkText
        }
    }
    class var emSecondaryLabel: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .dvWarmGrey
        }
    }
    
    class var emSecondarySystemFill: UIColor {
        if #available(iOS 13.0, *) {
               return .secondarySystemFill
           } else {
               return .lightGray
           }
    }

    class var lgLightGray: UIColor {
        return UIColor(red:0.8, green:0.8, blue:0.8, alpha:1.0)
    }
    
    class var lgLightUrple: UIColor {
        return UIColor(red: 163.0 / 255.0, green: 122.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    class var lgCoralPink: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 85.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }
    
    class var lgAlgaeGreen: UIColor {
        return UIColor(red: 38.0 / 255.0, green: 196.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    class var lgOrangeish: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 136.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
    }
    
    class var lgDarkSkyBlue: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 136.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    }
    
    class var lgGreyishBrown: UIColor {
        return UIColor(white: 61.0 / 255.0, alpha: 1.0)
    }
    
    class var lgWarmGrey: UIColor {
        return UIColor(white: 154.0 / 255.0, alpha: 1.0)
    }
    
    class var lgDodgerBlue: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 150.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var lgGreen: UIColor {
        return UIColor(red: 31.0 / 255.0, green: 196.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    }
    
    class var lgGrapefruit: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 94.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    
    class var lgOrangeishTwo: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 141.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }
    
    class var lgYellowOrange: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 179.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    class var lgPurple: UIColor {
        return UIColor(red: 163.0 / 255.0, green: 120.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var lgGray: UIColor {
        return UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    }
    
    
    class var lgNotHome: UIColor {
        return UIColor(hexString: "FFB300") ?? .clear
    }
    
    class var lgActive: UIColor {
        return UIColor(hexString: "A37CFC") ?? .clear
    }
    
    class var lgSale: UIColor {
        return UIColor(hexString: "3396FF") ?? .clear
    }
    
    class var lgNotInterested: UIColor {
        return UIColor(hexString: "FF8D36") ?? .clear
    }
    
    class var lgDisqualified: UIColor {
        return UIColor(hexString: "FF5E5E") ?? .clear
    }
    
    class var lgAlreadySolar: UIColor {
        return UIColor(hexString: "1FC435") ?? .clear
    }
    
    class var lgNotes: UIColor {
        return UIColor(hexString: "D8C549") ?? .clear
    }
    
    class var lgAppointments: UIColor {
        return UIColor(hexString: "ED72D7") ?? .clear
    }
    
    class var lgArea: UIColor {
        return UIColor(hexString: "1F5FA4") ?? .clear
    }
    
    class var lgStreet: UIColor {
        return UIColor(hexString: "2877CB") ?? .clear
    }

    class var dvGray: UIColor {
        return UIColor(hexString: "888888") ?? .clear
    }
}


public extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        let hexString = hexString.replacingOccurrences(of: "#", with: "")
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
}

public extension String {
    var hex: Int? {
        return Int(self, radix: 16)
    }
}



public extension UIColor {
    var hexString: String {
        let colorRef = cgColor.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha
        
        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        
        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a)))
        }
        
        return color
    }
}


public extension UIColor {
    
    @nonobjc class var dvLightPurple: UIColor {
        return UIColor(red: 163.0 / 255.0, green: 122.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvCoralPink: UIColor {
        return UIColor(red: 1.0, green: 85.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvAlgaeGreen: UIColor {
        return UIColor(red: 38.0 / 255.0, green: 196.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvOrangeishDarker: UIColor {
        return UIColor(red: 1.0, green: 136.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvDarkSkyBlue: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 136.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvGreyishBrown: UIColor {
        return UIColor(white: 61.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvDodgerBlue: UIColor {
        return UIColor(red: 51.0 / 255.0, green: 150.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var dvGrapefruit: UIColor {
        return UIColor(red: 1.0, green: 94.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvOrangeish: UIColor {
        return UIColor(red: 1.0, green: 141.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvWarmGrey: UIColor {
        return UIColor(white: 153.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvPurple: UIColor {
        return UIColor(red: 163.0 / 255.0, green: 120.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var dvYellowOrange: UIColor {
        return UIColor(red: 1.0, green: 179.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var dvWarmBrown: UIColor {
        return UIColor(red: 148.0 / 255.0, green: 80.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var dvAquaBlue: UIColor {
        return UIColor(red: 0.0, green: 215.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvGolden: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 195.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var dvGreen: UIColor {
        return UIColor(red: 31.0 / 255.0, green: 196.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvDeepRed: UIColor {
        return UIColor(red: 168.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    @nonobjc class var dvOrangeyRed: UIColor {
        return UIColor(red: 1.0, green: 48.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvCandyPink: UIColor {
        return UIColor(red: 1.0, green: 108.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvDarkishBlue: UIColor {
        return UIColor(red: 0.0, green: 70.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvAquamarine: UIColor {
        return UIColor(red: 0.0, green: 209.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvDeepSkyBlue: UIColor {
        return UIColor(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    @nonobjc class var dvDarkIndigo: UIColor {
        return UIColor(red: 24.0 / 255.0, green: 18.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvLightRed: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 65.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvVeryLightPink: UIColor {
        return UIColor(white: 243.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvVeryLightGrey: UIColor {
        return UIColor(white: 216.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dvBrownishGrey: UIColor {
        return UIColor(white: 119.0 / 255.0, alpha: 1.0)
    }
    
//    @nonobjc class var areaColors: [UIColor] {
//        return [.dvDodgerBlue, .dvPurple, .dvCandyPink, .dvOrangeyRed, .dvDeepRed, .dvGreen, .dvGolden, .dvAquaBlue, .dvWarmBrown, .dvOrangeish, dvDarkishBlue]
//    }
    
}
