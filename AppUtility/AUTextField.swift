//
//  AUTextField.swift
//  AppUtility
//
//  Created by Apple on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation

public class AUTextFiled: UITextField {
    
    public var edgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    public override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edgeInsets)
    }
    
    public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edgeInsets)
    }
    
    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edgeInsets)
    }
    
}
