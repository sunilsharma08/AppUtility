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
    
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont, options: NSStringDrawingOptions = [.UsesLineFragmentOrigin, .UsesFontLeading]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: options, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
}