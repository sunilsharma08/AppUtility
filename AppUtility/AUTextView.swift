//
//  AUTextView.swift
//  AppUtilityExample
//
//  Created by Vlad Shmatok on 10/18/19.
//  Copyright © 2019 Sunil Sharma. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UITextView {

    /// SwifterSwift: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// SwifterSwift: Scroll to the bottom of text view
    func scrollToBottom() {
        // swiftlint:disable:next legacy_constructor
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }

    /// SwifterSwift: Scroll to the top of text view
    func scrollToTop() {
        // swiftlint:disable:next legacy_constructor
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }

    /// SwifterSwift: Wrap to the content (Text / Attributed Text).
    func wrapToContent() {
        contentInset = UIEdgeInsets.zero
        scrollIndicatorInsets = UIEdgeInsets.zero
        contentOffset = CGPoint.zero
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }

}

#endif
