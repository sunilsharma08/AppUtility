//
//  AUAlertMessage.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

public class AUAlertMessage: UIView {
    
    public var animationDuration:Double = 0.4
    
    let backgroundView = UIView()
    let alertView = UIView()
    var animator:UIDynamicAnimator? = nil
    
    init() {
        super.init(frame: CGRectZero)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup(){
        self.animator = UIDynamicAnimator.init(referenceView: self)
    }
    
    public func showAlertView(title:String?, message:String?, cancelButtonTitle:String?) {
        let alert = UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        alert.show()
    }
    
    public func setupAlertView() {
        
        let keyWindow = UIApplication.sharedApplication().keyWindow
        backgroundView.frame = keyWindow?.bounds ?? CGRectZero
        
        backgroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        backgroundView.alpha = 0.0
        self.addSubview(backgroundView)
        
        alertView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 100)
        alertView.backgroundColor = UIColor.whiteColor()
        alertView.layer.cornerRadius = 11.0
        alertView.layer.masksToBounds = true
        alertView.tintAdjustmentMode = .Normal
        
        let innerView = UIView.init(frame: alertView.frame)
        innerView.backgroundColor = UIColor.clearColor()
        
        alertView.addSubview(innerView)
        self.addSubview(alertView)
        
    }
    
    func show() {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        
        keyWindow?.addSubview(self)
        
        UIView.animateWithDuration(animationDuration) {
            self.backgroundView.alpha = 1.0
        }
        
        let snapBehaviour = UISnapBehavior.init(item: self.alertView, snapToPoint: (keyWindow?.center)!)
        snapBehaviour.damping = 0.65
        self.animator?.addBehavior(snapBehaviour)
        
    }
    
    func dismiss() {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        self.animator?.removeAllBehaviors()
        
        let gravityBehaviour = UIGravityBehavior.init(items: [self.alertView])
        gravityBehaviour.gravityDirection = CGVectorMake(0, 10)
        self.animator?.addBehavior(gravityBehaviour)

        let itemBehaviour = UIDynamicItemBehavior.init(items: [self.alertView])
        itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), forItem: self.alertView)
        self.animator?.addBehavior(itemBehaviour)
        
        UIView.animateWithDuration(animationDuration, animations: {[weak self] in
            self?.backgroundView.alpha = 0.0
            keyWindow?.tintAdjustmentMode = .Automatic
            keyWindow?.tintColorDidChange()
            }) {[weak self] (finished) in
                self?.removeFromSuperview()
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
