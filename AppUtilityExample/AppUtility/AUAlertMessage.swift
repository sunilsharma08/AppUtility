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
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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

open class AUAlertMessage: UIView {
    
    open var animationDuration:Double = 0.4
    
    let backgroundView = UIView()
    let alertView = UIView()
    var animator:UIDynamicAnimator? = nil
    
    init() {
        super.init(frame: CGRect.zero)
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
    
    fileprivate func initialSetup(){
        self.animator = UIDynamicAnimator.init(referenceView: self)
    }
    
    open func showAlertView(_ title:String?, message:String?, cancelButtonTitle:String?) {
        let alert = UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        alert.show()
    }
    
    open func setupAlertView() {
        
        let keyWindow = UIApplication.shared.keyWindow
        backgroundView.frame = keyWindow?.bounds ?? CGRect.zero
        
        backgroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        backgroundView.alpha = 0.0
        self.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 100)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 11.0
        alertView.layer.masksToBounds = true
        alertView.tintAdjustmentMode = .normal
        
        let innerView = UIView.init(frame: alertView.frame)
        innerView.backgroundColor = UIColor.clear
        
        alertView.addSubview(innerView)
        self.addSubview(alertView)
        
    }
    
    func show() {
        let keyWindow = UIApplication.shared.keyWindow
        
        keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.backgroundView.alpha = 1.0
        }) 
        
        let snapBehaviour = UISnapBehavior.init(item: self.alertView, snapTo: (keyWindow?.center)!)
        snapBehaviour.damping = 0.65
        self.animator?.addBehavior(snapBehaviour)
        
    }
    
    func dismiss() {
        let keyWindow = UIApplication.shared.keyWindow
        self.animator?.removeAllBehaviors()
        
        let gravityBehaviour = UIGravityBehavior.init(items: [self.alertView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: 10)
        self.animator?.addBehavior(gravityBehaviour)

        let itemBehaviour = UIDynamicItemBehavior.init(items: [self.alertView])
        itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), for: self.alertView)
        self.animator?.addBehavior(itemBehaviour)
        
        UIView.animate(withDuration: animationDuration, animations: {[weak self] in
            self?.backgroundView.alpha = 0.0
            keyWindow?.tintAdjustmentMode = .automatic
            keyWindow?.tintColorDidChange()
            }, completion: {[weak self] (finished) in
                self?.removeFromSuperview()
        }) 
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
