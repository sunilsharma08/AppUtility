//
//  AUAlertMessage.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

open class AUAlertMessage: UIView {
    
    open func showAlertView(_ title:String?, message:String?, cancelButtonTitle:String?) {
        let alert = UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        alert.show()
    }
    
}
