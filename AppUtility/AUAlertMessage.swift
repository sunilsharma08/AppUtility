//
//  AUAlertMessage.swift
//  AppUtility
//
//  Created by Apple on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation

public class AUAlertMessage: NSObject {
    
    public func showAlertView(title:String?, message:String?, cancelButtonTitle:String?) {
        let alert = UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        alert.show()
    }
    
}
