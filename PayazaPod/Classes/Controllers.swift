//
//  Controllers.swift
//  DropDown
//
//  Created by KS on 10/09/2022.
//

import Foundation
import UIKit

class Controllers {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func configureTimer( timerLabel: UILabel){
        
        let startTime: Date = Date()
        // The total amount of time to wait
        let duration: TimeInterval = 200 * 60 // 200 minutes
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropLeading
        formatter.unitsStyle = .short
        // The amount of time which has past since we started
        var runningTime: TimeInterval = 0
        
        // This is just so I can atrificially update the time
        var time: Date = Date()
        let cal: Calendar = Calendar.current
        repeat {
            // Simulate the passing of time, by the minute
            // If this was been called from a timer, then you'd
            // simply use the current time
            time = cal.date(byAdding: .minute, value: 1, to: time)!
            
            // How long have we been running for?
            runningTime = time.timeIntervalSince(startTime)
            // Have we run out of time?
            if runningTime < duration {
                // Print the amount of time remaining
                //                let coloredText = formatter.string(from: duration - runningTime)!
                //                let attrs = [NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#2357D1")]
                //                let attributedString = NSMutableAttributedString(string:coloredText, attributes:attrs)
                //
                //                let firstHalf = "This account is going to expire in "
                //                let secondHalf = " make your payment before it expires"
                //                let firstNormalString = NSMutableAttributedString(string:firstHalf)
                //                let secondNormalString = NSMutableAttributedString(string:secondHalf)
                
                //                firstNormalString.append(attributedString)
                //                firstNormalString.append(secondNormalString)
                //                timerLabel.attributedText = firstNormalString
                print(formatter.string(from: duration - runningTime)!)
                
            }
        } while runningTime < duration
    }
    
    func mapToDevice(identifier: String) -> String {
#if os(iOS)
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
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
        default:                                        return identifier
        }
#elseif os(tvOS)
        switch identifier {
        case "AppleTV5,3": return "Apple TV 4"
        case "AppleTV6,2": return "Apple TV 4K"
        case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
        default: return identifier
        }
#endif
    }
    
    func getDeviceInfo(viewController : UIViewController)  -> DeviceInfo{
        let deviceName = UIDevice.modelName
        let systemVersion = UIDevice.current.systemVersion
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let deviceInfo = DeviceInfo(deviceName: deviceName, deviceId: deviceId, deviceOs: systemVersion)
        return deviceInfo
    }
    
    
    func copyAction(viewContoller: UIViewController, stringToCopy: String) {
        UIPasteboard.general.string = stringToCopy// or use  sender.titleLabel.text
        viewContoller.showToast(message: "Copied", font: .systemFont(ofSize: 13))
    }
    
    func setUpViewBorderAndColor(theView: UIView, theColor: UIColor, borderWidth: CGFloat){
        theView.layer.borderWidth = borderWidth
        theView.layer.borderColor = theColor.cgColor
    }
    
    func configureRequestHeader(baseUrl: String, connectionMethod: String, merchantKey: String) -> URLRequest? {
        var newRequest : URLRequest?
        newRequest = URLRequest(url: URL(string: baseUrl)!)
        newRequest!.httpMethod = connectionMethod
        let codedKey = merchantKey.data(using: .utf8)
        let encodedKey = codedKey?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        newRequest!.addValue("Payaza \(encodedKey!)", forHTTPHeaderField: "Authorization")
        newRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return newRequest
    }
    
    func configureRequestHeaderUnencoded(baseUrl: String, connectionMethod: String, merchantKey: String) -> URLRequest? {
        var newRequest : URLRequest?
        newRequest = URLRequest(url: URL(string: baseUrl)!)
        newRequest!.httpMethod = connectionMethod
        newRequest!.addValue("Payaza \(merchantKey)", forHTTPHeaderField: "Authorization")
        newRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return newRequest
    }
    
    func isFieldValid(editField: UITextField, vc: UIViewController, errorText: String) -> Bool {
        if editField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            vc.showToast(message: errorText, font: .systemFont(ofSize: 14))
            return false
        }
        return true;
    }
    
    func getCcurrentDate() -> String{
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyMMddHHmmss"
        let date = Date()
        let currentDate = formatter3.string(from: date)
        return currentDate
    }
    
    func getCardType(cardNumber: String, cardImageView: UIImageView, vc: UIViewController) {
        if let type = CreditCardValidator(cardNumber).type {
            switch type.name {
            case "Amex":
                setImage(imageName: "amex", imaveView: cardImageView)
            case "Visa":
                setImage(imageName: "visa", imaveView: cardImageView)
            case "MasterCard":
                setImage(imageName: "master.svg.png", imaveView: cardImageView)
            case "Verve":
                setImage(imageName: "verve", imaveView: cardImageView)
            case "Maestro":
                setImage(imageName: "verve", imaveView: cardImageView)
            default:
                setImage(imageName: "", imaveView: cardImageView)
            } // Visa, Mastercard, Amex etc.
        } else {
            setImage(imageName: "", imaveView: cardImageView)
            vc.showToast(message: "Enter a valid Card", font: .systemFont(ofSize: 12))// I Can't detect type of credit card
        }
    }
    
    
    
    func setImage(imageName: String, imaveView: UIImageView){
        let mainBundle = Bundle(for: ParentViewController.self)
        let origImage = UIImage(named: imageName, in: mainBundle, compatibleWith: nil)
        imaveView.image = origImage
    }
}
