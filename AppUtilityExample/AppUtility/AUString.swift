//
//  AUString.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    public func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    public func isValidEmail(_ regexString:String = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])") -> Bool {
        
        return validateWithRegexString(regexString)
    }
    
    public func validateWithRegexString(_ regexString:String) -> Bool {
        let emailTest:NSPredicate = NSPredicate(format:"SELF MATCHES %@", regexString)
        return emailTest.evaluate(with: self)
    }
    
}
