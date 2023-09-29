//
//  Extensions.swift
//  PayAzaSDK
//
//  Created by KS on 10/09/2022.
//

import Foundation
import UIKit



extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}



extension UIViewController {
    
    

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-95, width: 270, height: 35))
    toastLabel.backgroundColor = Controllers().hexStringToUIColor(hex: "#676E7E").withAlphaComponent(1.0)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
}

extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
      return Controllers().mapToDevice(identifier: identifier)
    }()
    
}

extension UIImage {
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
            guard let bundleURL =  Bundle(for: ParentViewController.self)
                .url(forResource: name, withExtension: "gif") else {
                    print("SwiftGif: This image named \"\(name)\" does not exist")
                    return nil
            }
            guard let imageData = try? Data(contentsOf: bundleURL) else {
                print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
                return nil
            }
            
            return gifImageWithData(imageData)
        }
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                    print("image doesn't exist")
                    return nil
                }
                
                return UIImage.animatedImageWithSource(source)
            }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
            var delay = 0.1
            
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
            let gifProperties: CFDictionary = unsafeBitCast(
                CFDictionaryGetValue(cfProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
                to: CFDictionary.self)
            
            var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                to: AnyObject.self)
            if delayObject.doubleValue == 0 {
                delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }
            
            delay = delayObject as! Double
            
            if delay < 0.1 {
                delay = 0.1
            }
            
            return delay
        }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
           var a = a
           var b = b
           if b == nil || a == nil {
               if b != nil {
                   return b!
               } else if a != nil {
                   return a!
               } else {
                   return 0
               }
           }
           
           if a! < b! {
               let c = a
               a = b
               b = c
           }
           
           var rest: Int
           while true {
               rest = a! % b!
               
               if rest == 0 {
                   return b!
               } else {
                   a = b
                   b = rest
               }
           }
       }
        
    class func gcdForArray(_ array: Array<Int>) -> Int {
            if array.isEmpty {
                return 1
            }
            
            var gcd = array[0]
            
            for val in array {
                gcd = UIImage.gcdForPair(val, gcd)
            }
            
            return gcd
        }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}

