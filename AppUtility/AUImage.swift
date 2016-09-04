//
//  AUImage.swift
//  AppUtility
//
//  Created by Apple on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation

extension UIImage {
    
    public class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.Up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransformIdentity
        
        if ( self.imageOrientation == UIImageOrientation.Down || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Left || self.imageOrientation == UIImageOrientation.LeftMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Right || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if ( self.imageOrientation == UIImageOrientation.UpMirrored || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.LeftMirrored || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                                      CGImageGetBitsPerComponent(self.CGImage), 0,
                                                      CGImageGetColorSpace(self.CGImage),
                                                      CGImageGetBitmapInfo(self.CGImage).rawValue)!;
        
        CGContextConcatCTM(ctx, transform)
        
        if ( self.imageOrientation == UIImageOrientation.Left ||
            self.imageOrientation == UIImageOrientation.LeftMirrored ||
            self.imageOrientation == UIImageOrientation.Right ||
            self.imageOrientation == UIImageOrientation.RightMirrored ) {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(CGImage: CGBitmapContextCreateImage(ctx)!)
    }
    
    public func resizeImage(maxSize:CGSize) -> UIImage {
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
        let rect = CGRectMake(0, 0, actualWidth , actualHeight)
        UIGraphicsBeginImageContext(rect.size);
        self.drawInRect(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    //compression should be between 0 - 1
    public func compressImage(compression:CGFloat) -> UIImage? {
        let imageData = UIImageJPEGRepresentation(self, compression);
        let image = UIImage.init(data: imageData ?? NSData())
        return image
    }
    
}
