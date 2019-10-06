//
//  AUView.swift
//  AppUtilityExample
//
//  Created by Apple on 01/03/17.
//  Copyright © 2017 Sunil Sharma. All rights reserved.
//

import UIKit

extension UIView
{
    func copyView<T: UIView>() -> T? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? T
    }

  func corner(with radius: CGFloat) {
    self.clipsToBounds = true
    self.layer.cornerRadius = radius
  }
}

/*class AUView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}*/
