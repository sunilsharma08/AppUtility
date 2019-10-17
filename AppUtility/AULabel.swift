//
//  AULabel.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

open class AULabel: UILabel {
    open var edgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    
    override open func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}

// MARK: - Methods
public extension UILabel {

    /// SwifterSwift: Initialize a UILabel with text
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// SwifterSwift: Initialize a UILabel with a text and font style.
    ///
    /// - Parameters:
    ///   - text: the label's text.
    ///   - style: the text style of the label, used to determine which font should be used.
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }

    /// SwifterSwift: Required height for a label
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }

}

#endif
