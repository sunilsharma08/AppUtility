//
//  AULabel.swift
//  AppUtility
//
//  Created by Apple on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation

public class AULabel: UILabel {
    public var edgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    
    override public func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
}
