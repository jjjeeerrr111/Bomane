//
//  Extensions.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-17.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import Foundation
import UIKit
//import PopUpDialog

extension Int {
    func formattedNumberString() -> String {
        if self < 1000 {
            return "\(self)"
        } else if self >= 1000 && self < 10000 {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            guard let numString = numberFormatter.string(from: NSNumber(value: self)) else {return ""}
            return numString + "k"
        } else if self >= 10000 && self < 1000000 {
            let value = Double(self)/1000.0
            return String(format: "%.1f", value) + "k"
        } else {
            let value = Double(self)/1000000.0
            return String(format: "%.1f", value) + "m"
        }
    }
}

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0,y: 0,width: size.width,height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func compressImage(image: UIImage) -> Data? {
        return self.compressImage(image: image, quality: 0.7, dimensions: 800)
    }
    
    class func compressImage(image: UIImage, quality: CGFloat, dimensions: CGFloat) -> Data? {
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        let maxHeight = dimensions
        let maxWidth = dimensions
        var imgRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            } else if (imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            } else {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        let rect = CGRect(x:0.0,y: 0.0,width: actualWidth,height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, quality)
        UIGraphicsEndImageContext()
        return imageData
    }
    
    class func compressToMaxWidth(image: UIImage, quality: CGFloat, maxWidth: CGFloat) -> Data? {
        let actualHeight = image.size.height
        let actualWidth = image.size.width
        let imgRatio = actualWidth / actualHeight
        let maxHeight: CGFloat = {
            if actualWidth <= maxWidth {
                return actualHeight
            } else {
                return maxWidth / imgRatio
            }
        }()
        let rect = CGRect(x: 0.0,y: 0.0,width: maxWidth,height: maxHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, quality)
        UIGraphicsEndImageContext()
        return imageData
    }
}

extension UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 41
        return sizeThatFits
    }
}

extension UIViewController {
//    func showErrorAlert(title: String, body: String) {
//        let alert = PopupDialog(title: title, message: body)
//        
//        let buttonOne = CancelButton(title: "OK") {
//            
//        }
//        
//        alert.addButtons([buttonOne])
//        alert.transitionStyle = .zoomIn
//        // Present dialog
//        self.present(alert, animated: true, completion: nil)
//    }
}

extension UITextField
{
    func setBottomBorder(color:UIColor)
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func doubleFromCurrency() -> Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = NumberFormatter.Style.currency
        
        let moneyDouble = formatter.number(from: self)?.doubleValue
        
        return moneyDouble!
    }
}

extension Dictionary {
    
    func paramsString() -> String {
        var paramsString = [String]()
        for (key, value) in self {
            guard let stringValue = value as? String, let stringKey = key as? String else {
                return ""
            }
            paramsString += [stringKey + "=" + "\(stringValue)"]
            
        }
        return (paramsString.isEmpty ? "" : paramsString.joined(separator: "&"))
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension UINavigationController {
    
    func popToViewControllerOfType(classForCoder: AnyClass) {
        for controller in viewControllers {
            if controller.classForCoder == classForCoder {
                popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func popViewControllers(controllersToPop: Int, animated: Bool) {
        if viewControllers.count > controllersToPop {
            popToViewController(viewControllers[viewControllers.count - (controllersToPop + 1)], animated: animated)
        } else {
            print("Trying to pop \(controllersToPop) view controllers but navigation controller contains only \(viewControllers.count) controllers in stack")
        }
    }
}
