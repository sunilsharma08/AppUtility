//
//  AUImage.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    public class func imageWithGradient(_ colors: [CGColor], size: CGSize, verticalGradient:Bool = false) -> UIImage {
        let gradientLayer = CAGradientLayer()
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.frame = rect
        gradientLayer.colors = colors
        if verticalGradient {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: size.height/CGFloat(colors.count))
            gradientLayer.endPoint = CGPoint(x: 1.0, y: size.height/CGFloat(colors.count))
        }
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        }
        
        if ( self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        
        if ( self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        if ( self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                                      bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                                      space: self.cgImage!.colorSpace!,
                                                      bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImageOrientation.left ||
            self.imageOrientation == UIImageOrientation.leftMirrored ||
            self.imageOrientation == UIImageOrientation.right ||
            self.imageOrientation == UIImageOrientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }
    
    public func resizeImage(_ maxSize:CGSize) -> UIImage {
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        
        var actualRatio = actualWidth/actualHeight
        let maxRatio = maxSize.width/maxSize.height
        
        if actualHeight > maxSize.height || actualWidth > maxSize.width {
            if actualRatio < maxRatio {
                actualRatio = maxSize.height / actualHeight
                actualWidth = actualRatio * actualWidth
                actualHeight = maxSize.height
            }
            else if actualRatio < maxRatio {
                actualRatio = maxSize.height / actualHeight
                actualWidth = actualRatio * actualWidth
                actualHeight = maxSize.height
            }
            else{
                actualHeight = maxSize.height
                actualWidth = maxSize.width
            }
        }
        let rect = CGRect(x: 0, y: 0, width: actualWidth , height: actualHeight)
        UIGraphicsBeginImageContext(rect.size);
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    //compression should be between 0 - 1
    public func compressImage(_ compression:CGFloat) -> UIImage? {
        let imageData = UIImageJPEGRepresentation(self, compression);
        let image = UIImage.init(data: imageData ?? Data())
        return image
    }
    
}
