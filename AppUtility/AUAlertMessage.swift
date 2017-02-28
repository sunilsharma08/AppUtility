//
//  AUAlertMessage.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

enum AUBackgroundOptions {
    case BlurEffectExtraLight
    case BlurEffectLight
    case BlurEffectDark
    case Dark
    case None
}

@objc protocol AUAlertMessageDelegate {
    @objc func auAlertMessageClickedOn(button:UIButton, index:Int, title:String)
}

class AUAlertMessage: UIView {
    
    let alertView = UIView()
    let backgroundView = UIView()
    private let innerView:UIView = UIView()
    public let buttonHeight:CGFloat = 45.0
    public let cornerRadius:CGFloat = 10.0
    public var dismissOnBackgroundTouch:Bool = true
    public var backgroundType:AUBackgroundOptions = .BlurEffectLight
    
    weak var delegate:AUAlertMessageDelegate? = nil
    
    private var animator:UIDynamicAnimator? = nil
    private var attachmentBehaviour:UIAttachmentBehavior? = nil
    private var alertViewDragStartPoint:CGPoint? = nil
    private var alertViewDragOffsetFromActualTranslation:UIOffset? = nil
    private var alertViewDragOffsetFromCenter:UIOffset? = nil
    private var alertViewIsFlickingAwayForDismissal = false
    private var isDraggingAlertView = false
    
    let minimumFlickDismissalVelocity:Float = 1400.0
    private var animationDuration:Double = 0.4
    public var contentEdgeInsets = UIEdgeInsets.init(top: 12, left: 0, bottom: 0, right: 0)
    
    public let titleLabel:UILabel = UILabel()
    public let messageLabel:UILabel = UILabel()
    public let cancelButton:UIButton = UIButton(type: .custom)
    private(set) var buttonTitlesArray:[String]? = [String]()
    
    private init() {
        super.init(frame: CGRect.zero)
        initialSetup()
    }
    
    public convenience init(title: String?, message: String?, cancelButtonTitle: String?) {
        self.init()
        addInnerViews(title: title, message: message, cancelButtonTitle: cancelButtonTitle,firstButtonTitle: nil, otherButtonTitles: nil)
    }
    
    public convenience init(title:String?, message:String?, cancelButtonTitle:String?, otherButtonTitles firstButtonTitle: String, _ moreButtonTitles:String...) {
        self.init()
        addInnerViews(title: title, message: message, cancelButtonTitle: cancelButtonTitle,firstButtonTitle: firstButtonTitle, otherButtonTitles: moreButtonTitles)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //super.init(coder: aDecoder)
    }
    
    private func initialSetup(){
        self.backgroundColor = UIColor.clear
        self.animator = UIDynamicAnimator.init(referenceView: self)
        self.isUserInteractionEnabled = true
        
        //InnerView
        innerView.backgroundColor = UIColor.clear
        innerView.clipsToBounds = true
        innerView.layer.cornerRadius = self.cornerRadius
        
        self.cancelButton.tag = -1
        
        setupAlertView()
    }
    
    //Temporary
    public func showAlertView(_ title:String?, message:String?, cancelButtonTitle:String?) {
        let alert = UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle)
        alert.show()
    }
    
    private func setupAlertView() {
        
        let keyWindow = UIApplication.shared.keyWindow
        self.frame = keyWindow?.bounds ?? CGRect.zero
        
        backgroundView.frame = keyWindow?.bounds ?? CGRect.zero
        self.setBackgroundEffect(view: backgroundView, blurStyle: backgroundType)
        //        backgroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        backgroundView.alpha = 0.0
        self.addSubview(backgroundView)
        
        let alertViewHorizontalPadding:CGFloat = 40
        alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - alertViewHorizontalPadding, height: 100)
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = self.cornerRadius
        alertView.layer.masksToBounds = true
        alertView.tintAdjustmentMode = .normal
        alertView.isUserInteractionEnabled  = true
        
        self.innerView.frame = CGRect(x: contentEdgeInsets.left, y: contentEdgeInsets.top, width: alertView.frame.size.width - (contentEdgeInsets.left + contentEdgeInsets.right), height: alertView.frame.size.height - (contentEdgeInsets.top + contentEdgeInsets.bottom))
        alertView.addSubview(innerView)
        self.addSubview(alertView)
    }
    
    func setBackgroundEffect(view:UIView, blurStyle:AUBackgroundOptions) {
        switch blurStyle {
        case .Dark:
            view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        case .BlurEffectDark:
            self.setBlurredView(view,blurEffectStyle: .dark)
        case .BlurEffectLight:
            self.setBlurredView(view,blurEffectStyle: .light)
        case .BlurEffectExtraLight:
            self.setBlurredView(view,blurEffectStyle: .extraLight)
        case .None:
            view.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func setBlurredView(_ view:UIView, blurEffectStyle:UIBlurEffectStyle) {
        if !UIAccessibilityIsReduceMotionEnabled() {
            let blurEffect = UIBlurEffect(style: blurEffectStyle)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = (view.bounds)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
        }
        else {
            view.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    
    func addInnerViews(title:String?, message:String?, cancelButtonTitle:String?,firstButtonTitle: String?, otherButtonTitles: [String]?) {
        
        if let titleString = title {
            titleLabel.text = title
            configTitleLabel(title: titleString)
        }
        
        if let messageString = message {
            messageLabel.text = message
            configMessageLabel(message: messageString)
        }
        
        if let cancelString = cancelButtonTitle {
            self.cancelButton.setTitle(cancelString, for: .normal)
            buttonTitlesArray?.insert(cancelString, at: 0)
        }
        
        if let firstButtonTitleString = firstButtonTitle {
            buttonTitlesArray?.append(firstButtonTitleString)
        }
        
        for title in otherButtonTitles ?? [] {
            buttonTitlesArray?.append(title)
        }
        
        self.addOtherButtons(buttonTitles: buttonTitlesArray!)
        
        /*
         let button = UIButton(type: .custom)
         let cancelStringWidth =  cancelButtonTitle?.widthWithConstrainedHeight(buttonHeight, font:button.titleLabel?.font ?? UIFont.systemFont(ofSize: 15))
         
         if let firstTitleString = firstButtonTitle {
         addOtherButtons(buttonTitles: [firstTitleString])
         }
         addOtherButtons(buttonTitles: otherButtonTitles!)
         if let cancelTitleString = cancelButtonTitle {
         configCancelButton(title: cancelTitleString)
         }
         */
        resizeAlertViewHeight()
    }
    
    private func addOtherButtons(buttonTitles:[String]) {
        
        let lastViewFrame = getLastViewFrame(view: self.innerView)
        let paddingBetweenMsgAndBtn:CGFloat = 15
        let paddingBetweenButton = 2
        let messageLabelEndY = lastViewFrame.origin.y + lastViewFrame.size.height  + paddingBetweenMsgAndBtn
        
        if (titleLabel.text != nil || messageLabel.text != nil) && (buttonTitles.count != 0) {
            let frame = CGRect(x: 0.0, y: self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + paddingBetweenMsgAndBtn, width: self.innerView.frame.size.width, height: 0.5)
            addSublayerLine(frame: frame)
        }
        
        for (index,title) in buttonTitles.enumerated() {
            
            let button = UIButton.init(type: .custom)
            var buttonYOffset = messageLabelEndY + (buttonHeight * CGFloat(index)) +  CGFloat(index * paddingBetweenButton)
            
            if buttonTitles.count == 2 {
                let cancelStringWidth =  buttonTitles[0].widthWithConstrainedHeight(buttonHeight, font:button.titleLabel?.font ?? UIFont.systemFont(ofSize: 15))
                let otherString = buttonTitles[1]
                let otherStringWidth = otherString.widthWithConstrainedHeight(buttonHeight, font:button.titleLabel?.font ?? UIFont.systemFont(ofSize: 15))
                let alertHalfWidth = self.innerView.frame.size.width/2 - 10
                
                if (cancelStringWidth < alertHalfWidth) && (otherStringWidth < alertHalfWidth) {
                    if index == 0 {
                        button.frame = CGRect(x: 0.0, y: buttonYOffset, width: self.innerView.frame.size.width/2-1, height: buttonHeight)
                        addSublayerLine(frame: CGRect(x: button.frame.origin.x + button.frame.size.width + 1, y: messageLabelEndY, width: 0.5, height: buttonHeight))
                    }
                    else if index == 1 {
                        button.frame = CGRect(x: self.innerView.frame.size.width/2, y: buttonYOffset - buttonHeight - CGFloat(paddingBetweenButton), width: self.innerView.frame.size.width/2, height: buttonHeight)
                    }
                }
            }
            
            button.tag = index
            
            if index != 0 {
                let frame = CGRect(x: 0.0, y: buttonYOffset, width: self.innerView.frame.size.width, height: 0.5)
                addSublayerLine(frame: frame)
            }
            
            if index == 0 && self.cancelButton.titleLabel?.text != nil {
                //self.cancelButton.frame = button.frame
                configCancelButton(title: title)
                self.cancelButton.tag = button.tag
            }
            else {
                button.layer.cornerRadius = 2
                button.clipsToBounds = true
                button.titleLabel?.minimumScaleFactor = 0.8
                button.titleLabel?.adjustsFontSizeToFitWidth = true
                button.setTitle(title, for: .normal)
                button.setTitleColor(UIColor.init(redValue: 0, greenValue: 122, blueValue: 255), for: .normal)
                button.backgroundColor = UIColor.clear
                button.addTarget(self, action: #selector(clickedOnButton(button:)), for: .touchUpInside)
                innerView.addSubview(button)
            }
            
            if button.frame == CGRect.zero {
                
                if cancelButton.titleLabel?.text != nil && index != 0{
                    
                    buttonYOffset = messageLabelEndY + (buttonHeight * CGFloat(index - 1)) +  CGFloat((index - 1) * paddingBetweenButton)
                    button.frame = CGRect(x: 0.0, y: buttonYOffset, width: self.innerView.frame.size.width, height: buttonHeight)
                    if index == buttonTitles.count - 1 {
                        buttonYOffset = messageLabelEndY + (buttonHeight * CGFloat(index)) +  CGFloat(index * paddingBetweenButton)
                        cancelButton.frame = CGRect(x: 0.0, y: buttonYOffset, width: self.innerView.frame.size.width, height: buttonHeight)
                        self.innerView.addSubview(cancelButton)
                    }
                }
                else if cancelButton.titleLabel?.text == nil{
                    button.frame = CGRect(x: 0.0, y: buttonYOffset, width: self.innerView.frame.size.width, height: buttonHeight)
                }
            }
        }
    }
    
    func getLastViewFrame(view:UIView) -> CGRect{
        
        var frame:CGRect = CGRect.zero
        let innerSubViews = self.innerView.subviews
        if innerSubViews.count > 0 {
            let view = innerSubViews[innerSubViews.count - 1]
            frame = view.frame
        }
        return frame
    }
    
    func cancelButtonIndex() -> Int {
        if let cancelString = self.cancelButton.titleLabel?.text {
            return (buttonTitlesArray?.index(of: cancelString)) ?? -1
        }
        else {
            return -1
        }
    }
    
    func addButtonTitle(_ title:String) {
        buttonTitlesArray?.append(title)
    }
    
    func configCancelButton(title: String) {
        //let lastViewFrame = getLastViewFrame(view: self.innerView)
        //cancelButton.frame = CGRect(x: 0.0, y: lastViewFrame.origin.y + lastViewFrame.size.height + 6, width:lastViewFrame.size.width, height: buttonHeight)
        cancelButton.layer.cornerRadius = 2
        cancelButton.clipsToBounds = true
        cancelButton.titleLabel?.minimumScaleFactor = 0.8
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.setTitle(title, for: .normal)
        cancelButton.setTitleColor(UIColor.init(redValue: 0, greenValue: 122, blueValue: 255) , for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(clickedOnButton(button:)), for: .touchUpInside)
        //innerView.addSubview(cancelButton)
    }
    
    func resizeAlertViewHeight() {
        
        let lastViewFrame = getLastViewFrame(view: self.innerView)
        alertView.frame.size.height = lastViewFrame.origin.y + lastViewFrame.size.height + contentEdgeInsets.top + contentEdgeInsets.bottom
        innerView.frame.size.height = alertView.frame.size.height - (contentEdgeInsets.top + contentEdgeInsets.bottom)
    }
    
    func configMessageLabel(message: String) {
        let lastViewFrame = getLastViewFrame(view: self.innerView)
        self.messageLabel.frame = CGRect(x: 0.0, y: lastViewFrame.origin.y + lastViewFrame.size.height + 4 , width: self.innerView.frame.size.width, height: 0)
        self.messageLabel.text = message
        self.messageLabel.backgroundColor = UIColor.clear
        self.messageLabel.textColor = UIColor.black
        self.messageLabel.font = UIFont.systemFont(ofSize: 14)
        self.messageLabel.textAlignment = .center
        self.messageLabel.lineBreakMode = .byWordWrapping
        self.messageLabel.numberOfLines = 0
        self.messageLabel.frame.size.height = (self.messageLabel.text?.heightWithConstrainedWidth(self.innerView.frame.size.width, font: messageLabel.font) ?? 0.0) + 2
        self.innerView.addSubview(self.messageLabel)
    }
    
    func configTitleLabel(title: String) {
        self.titleLabel.frame = CGRect(x: 0.0, y: 0.0, width: self.innerView.frame.size.width, height: 0)
        titleLabel.text = title
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.frame.size.height = (titleLabel.text?.heightWithConstrainedWidth(self.innerView.frame.size.width, font: titleLabel.font) ?? 0.0) + 2
        self.innerView.addSubview(self.titleLabel)
    }
    
    func clickedOnButton(button:UIButton) {
        self.delegate?.auAlertMessageClickedOn(button: button, index: button.tag, title: button.titleLabel?.text ?? "")
        dismiss()
    }
    
    //Gestures and Animation
    func addGesture() {
        print("\(#function)")
        let tapGestureRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(dismissOnBackgroundTouch(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.isMultipleTouchEnabled = false
        self.backgroundView.addGestureRecognizer(tapGestureRecogniser)
        
        //Pan Gesture
        let panRecogniser = UIPanGestureRecognizer.init(target: self, action: #selector(dismissingPanGestureRecogniserPanned(_:)))
        panRecogniser.maximumNumberOfTouches = 1
        self.alertView.addGestureRecognizer(panRecogniser)
    }
    
    func dismissingPanGestureRecogniserPanned(_ panner:UIPanGestureRecognizer) {
        
        let translation = panner.translation(in: self)
        let locationInView = panner.location(in: self)
        let velocity = panner.velocity(in: self)
        let vectorDistance = sqrtf(powf(Float(velocity.x), 2) + powf(Float(velocity.y), 2))
        
        isDraggingAlertView = self.alertView.frame.contains(locationInView)
        
        if panner.state == .began {
            if isDraggingAlertView == true {
                self.startAlerViewDragging(location: locationInView, translationOffset: UIOffset.zero)
            }
        }
        else if panner.state == .changed {
            if isDraggingAlertView == true {
                var newAnchor = alertViewDragStartPoint
                newAnchor?.x += translation.x + (alertViewDragOffsetFromActualTranslation?.horizontal ?? 0)
                newAnchor?.y += translation.y + (alertViewDragOffsetFromActualTranslation?.vertical ?? 0)
                self.attachmentBehaviour?.anchorPoint = newAnchor ?? CGPoint.zero
            }
            else {
                isDraggingAlertView = self.alertView.frame.contains(locationInView)
                if isDraggingAlertView == true {
                    let translationOffset = UIOffset.init(horizontal: -1 * translation.x, vertical: -1 * translation.y)
                    self.startAlerViewDragging(location: locationInView, translationOffset: translationOffset)
                }
            }
        }
        else {
            if (vectorDistance > minimumFlickDismissalVelocity){
                if isDraggingAlertView {
                    self.dismissAlertViewWithFlick(velocity)
                }
                else {
                    dismiss()
                }
            }
            else {
                self.cancelCurrentAlertviewDrag(true)
            }
        }
    }
    
    func cancelCurrentAlertviewDrag(_ animated:Bool) {
        print(#function)
        self.animator?.removeAllBehaviors()
        self.attachmentBehaviour = nil
        isDraggingAlertView = false
        if animated == false {
            self.alertView.transform = .identity
            self.alertView.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2)
        }
        else{
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                if self.isDraggingAlertView == false {
                    self.alertView.transform = .identity
                    self.alertView.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
                }
            }, completion: nil)
        }
    }
    
    func dismissAlertViewWithFlick(_ velocity:CGPoint) {
        print(#function)
        self.alertViewIsFlickingAwayForDismissal = true
        let push = UIPushBehavior.init(items: [self.alertView], mode: .instantaneous)
        push.pushDirection = CGVector.init(dx: velocity.x * 0.1, dy: velocity.y * 0.1)
        push.setTargetOffsetFromCenter(self.alertViewDragOffsetFromCenter!, for: self.alertView)
        push.action = {
            if self.alertViewIsOffScreen() {
                self.animator?.removeAllBehaviors()
                self.attachmentBehaviour = nil
                self.dismiss()
            }
        }
        self.animator?.removeBehavior(self.attachmentBehaviour!)
        self.animator?.addBehavior(push)
    }
    
    func alertViewIsOffScreen() -> Bool{
        return self.animator?.items(in: self.frame).count == 0
    }
    
    func startAlerViewDragging(location:CGPoint, translationOffset:UIOffset) {
        print(#function)
        self.animator?.removeAllBehaviors()
        self.alertViewDragStartPoint = location
        self.alertViewDragOffsetFromActualTranslation = translationOffset
        let anchor = self.alertViewDragStartPoint
        let alertViewCenter = self.alertView.center
        
        let offset = UIOffsetMake(location.x - alertViewCenter.x, location.y - alertViewCenter.y)
        self.alertViewDragOffsetFromCenter = offset
        
        self.attachmentBehaviour = UIAttachmentBehavior.init(item: self.alertView, offsetFromCenter: offset, attachedToAnchor: anchor ?? CGPoint.zero)
        self.animator?.addBehavior(self.attachmentBehaviour!)
        
        let modifier = UIDynamicItemBehavior.init(items: [self.alertView])
        modifier.angularResistance = appropriateAngularResistanceForView(self.alertView)
        modifier.density = appropriateDensityForView(self.alertView)
        self.animator?.addBehavior(modifier)
    }
    
    func appropriateAngularResistanceForView(_ view:UIView) -> CGFloat{
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        
        let actualArea = height * width
        let referenceArea = self.bounds.size.width * self.bounds.size.height
        let factor = referenceArea / actualArea
        let defaultDensity:CGFloat = 4.0
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let resistance = defaultDensity * (referenceArea / (screenWidth * screenHeight))
        return resistance * factor
    }
    
    func appropriateDensityForView(_ view:UIView) -> CGFloat {
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let actualArea = height * width
        let referenceArea = self.bounds.size.width * self.bounds.size.height
        let factor = referenceArea / actualArea
        let defaultDensity:CGFloat = 0.5
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let appropriateDensity = defaultDensity * (referenceArea / (screenWidth * screenHeight))
        return appropriateDensity * factor
    }
    
    func addSublayerLine(frame:CGRect) {
        
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.init(white: 0.0, alpha: 0.29).cgColor
        lineLayer.frame = frame
        self.innerView.layer.addSublayer(lineLayer)
    }
    
    func show() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        
        let snapBehaviour = UISnapBehavior.init(item: self.alertView, snapTo: (keyWindow?.center)!)
        snapBehaviour.damping = 0.51
        self.animator?.addBehavior(snapBehaviour)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 1.0
        }, completion: { (finished) in
            self.addGesture()
        })
    }
    
    func dismissOnBackgroundTouch(_ gestureRecognizer:UITapGestureRecognizer){
        
        if dismissOnBackgroundTouch == true {
            guard let senderView = gestureRecognizer.view
                else {
                    return
            }
            
            if gestureRecognizer.state == .ended {
                let location = gestureRecognizer.location(in: senderView.superview)
                let closeSuperView = self.isTappedOutsideRegion(self.alertView, withLocation: location)
                if closeSuperView == true {
                    self.dismiss()
                }
            }
        }
    }
    
    func isTappedOutsideRegion(_ view:UIView, withLocation location:CGPoint) -> Bool {
        let endX = view.frame.origin.x + view.frame.size.width
        let endY = view.frame.origin.y + view.frame.size.height
        
        var isValid:Bool = false
        if (location.x < view.frame.origin.x || location.y < view.frame.origin.y) || (location.x > endX || location.y > endY) {
            isValid = true
        }
        return isValid
    }
    
    func dismiss() {
        let keyWindow = UIApplication.shared.keyWindow
        self.animator?.removeAllBehaviors()
        
        /*let gravityBehaviour = UIGravityBehavior.init(items: [self.alertView])
         gravityBehaviour.gravityDirection = CGVector(dx: 0, dy: 10)
         self.animator?.addBehavior(gravityBehaviour)
         
         let itemBehaviour = UIDynamicItemBehavior.init(items: [self.alertView])
         itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), for: self.alertView)
         self.animator?.addBehavior(itemBehaviour)*/
        
        UIView.perform(.delete, on: [self.alertView], options: .curveEaseInOut, animations: {[weak self] in
            self?.backgroundView.alpha = 0.0
            keyWindow?.tintAdjustmentMode = .automatic
            keyWindow?.tintColorDidChange()
            },completion: {[weak self] (finished) in
                self?.removeFromSuperview()
        })
        
        /*UIView.animate(withDuration: animationDuration, animations: {[weak self] in
         self?.backgroundView.alpha = 0.0
         keyWindow?.tintAdjustmentMode = .automatic
         keyWindow?.tintColorDidChange()
         }, completion: {[weak self] (finished) in
         self?.removeFromSuperview()
         })*/
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
