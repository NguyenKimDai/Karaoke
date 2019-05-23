//
//  TypeExtension.swift
//  MyKaraoke
//
//  Created by cuonghx on 12/1/18.
//  Copyright © 2018 cuonghx. All rights reserved.
//

import UIKit

let key = "AIzaSyCl4s5Y82fBqXiFCvImCoMPSv6v98YHsnk"
let option = "part=snippet,id&fields=nextPageToken,items(id/videoId,snippet/title,snippet/description,snippet/thumbnails/high/url)&page=10&type=video&maxResults=50"
extension String{
    
    func parseVideoDurationOfYoutubeAPI(videoDuration: String?) -> String {
        
        var videoDurationString = videoDuration! as NSString
        
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        let timeRange = videoDurationString.range(of: "T")
        
        videoDurationString = videoDurationString.substring(from: timeRange.location) as NSString
        while videoDurationString.length > 1 {
            
            videoDurationString = videoDurationString.substring(from: 1) as NSString
            
            let scanner = Scanner(string: videoDurationString as String) as Scanner
            var part: NSString?
            
            scanner.scanCharacters(from: NSCharacterSet.decimalDigits, into: &part)
            
            let partRange: NSRange = videoDurationString.range(of: part! as String)
            
            videoDurationString = videoDurationString.substring(from: partRange.location + partRange.length) as NSString
            let timeUnit: String = videoDurationString.substring(to: 1)
            
            
            if (timeUnit == "H") {
                hours = Int(part as! String)!
            }
            else if (timeUnit == "M") {
                minutes = Int(part as! String)!
            }
            else if (timeUnit == "S") {
                seconds   = Int(part! as String)!
            }
            else{
            }
            
        }
        if hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
extension UIView {
    func addConstrainsWithFormat(_ format : String, _ views : UIView...) {
        var viewsDictionary = [String : Any]()
        for (index , view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.characters.count > length {
            return String(self.characters.prefix(length)) + trailing
        } else {
            return self
        }
    }
    func makeString(length : Int , trailing : String = "…") -> String{
        if self.characters.count > length {
            let offset = self.characters.count - length
            return trailing + self.substring(from: self.index(self.startIndex, offsetBy: offset))
        } else {
            return self
        }
    }
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

enum stateOfVC {
    case minimized
    case fullScreen
    case hidden
}
enum Direction {
    case up
    case left
    case none
}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
