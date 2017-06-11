//
//  AUAlertMessage.swift
//  AppUtility
//
//  Created by Sunil Sharma on 22/08/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

/**
 Enum to describe AlertView background.
 */
public enum AUBackgroundOptions {
    case blurEffectExtraLight
    case blurEffectLight
    case blurEffectDark
    case dark
    case gray
    case none
}

/**
 Enum for Alertview button style.
 */
public enum AUAlertActionStyle : Int {
    case `default`
    case cancel
    case destructive
}

/**
 Enum for Alertview presenting animation
 */
public enum AUAlertAnimationType {
    case snapBehaviour
    case popUp
}

open class AUAlertView: UIView {
    
    //Contain alertview title.
    open var title: String?
    
    //Contain alertview message.
    open var message: String?
    
    ///Array of all alertview actions.
    lazy open private(set) var actions: [AUAlertAction] = []
    
    public let backgroundView = UIView()
    
    //Default button height.
    public let buttonHeight:CGFloat = 45.0
    
    //AlertView corner radius.
    public let cornerRadius:CGFloat = 10.0
    
    //Enable/disable alertview dismiss on click of area outside alertview.
    public var dismissOnBackgroundTouch:Bool = true
    
    //Give option to select different alertview background.
    public var backgroundType:AUBackgroundOptions = .gray
    
    public var alertViewAnimationType:AUAlertAnimationType = .snapBehaviour
    
    //Allow to dismiss alertview by flick or not.
    public var shouldDismissAlertViewByFlick = true
    
    //Allow to pan gesture on alertview or not
    public var isPanGestureEnabled = true
    
    //Private properties
    private var animator:UIDynamicAnimator? = nil
    private var attachmentBehaviour:UIAttachmentBehavior? = nil
    private var alertViewDragStartPoint:CGPoint? = nil
    private var alertViewDragOffsetFromActualTranslation:UIOffset? = nil
    private var alertViewDragOffsetFromCenter:UIOffset? = nil
    private var isDraggingAlertView = false
    private let minimumFlickDismissalVelocity:Float = 1000.0
    private var contentEdgeInsets = UIEdgeInsets.init(top: 14, left: 10, bottom: 14, right: 10)
    
    ///Contain title and message label.
    private lazy var headerScrollView = UIScrollView()
    ///Contain all alertview buttons.
    private lazy var buttonScrollView = UIScrollView()
    
    ///Calculate alertview max height allowed in iPhone screen.
    private let alertViewMaxHeight = UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.size.height + UITabBarController().tabBar.frame.size.height + UINavigationController().navigationBar.frame.size.height)
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public convenience init(title: String?, message: String?) {
        self.init()
        self.title = title
        self.message = message
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("AUAlertView \(#function) not implemeted")
    }
    
    /**
     Class method to show alertview.
     */
    public class func showAlertView(_ title:String?, message:String?, cancelButtonTitle:String?) {
        let alertview = AUAlertView(title: title, message: message)
        alertview.alertViewAnimationType = .popUp
        
        if let cancelTitle = cancelButtonTitle {
            let cancelButton = AUAlertAction(title: cancelTitle , style: .cancel)
            alertview.addAction(cancelButton)
        }
        alertview.show()
    }
    
    private func setupAlertView() {
        
        let keyWindow = UIApplication.shared.keyWindow
        let keyWindowFrame = keyWindow?.bounds ?? CGRect.zero
        
        backgroundView.frame = keyWindowFrame
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.setBackgroundEffect(view: backgroundView, blurStyle: backgroundType)
        let windowWidth = keyWindowFrame.width > keyWindowFrame.height ? keyWindowFrame.height : keyWindowFrame.width
        
        let alertViewHorizontalPadding:CGFloat = 0.125 * windowWidth
        
        self.frame = CGRect(x: alertViewHorizontalPadding / 2, y: 20, width: windowWidth - alertViewHorizontalPadding, height: 100)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        self.tintAdjustmentMode = .normal
        self.isUserInteractionEnabled  = true
        
        self.headerScrollView.showsHorizontalScrollIndicator = false
        self.buttonScrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setBackgroundEffect(view:UIView, blurStyle:AUBackgroundOptions) {
        switch blurStyle {
        case .dark:
            view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.8).cgColor
        case .blurEffectDark:
            self.setBlurredView(view,blurEffectStyle: .dark)
        case .blurEffectLight:
            self.setBlurredView(view,blurEffectStyle: .light)
        case .blurEffectExtraLight:
            self.setBlurredView(view,blurEffectStyle: .extraLight)
        case .gray:
            view.layer.backgroundColor = UIColor.black.withAlphaComponent(0.35).cgColor
        case .none:
            view.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    private func setBlurredView(_ view:UIView, blurEffectStyle:UIBlurEffectStyle) {
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
    
    private func addAlertViewElements() {
        self.headerScrollView.frame.size.width = self.frame.size.width
        self.headerScrollView.contentSize.width = self.headerScrollView.frame.size.width
        
        if let titleString = title {
            addTitleLabel(title: titleString)
        }
        
        if let messageString = message {
            addMessageLabel(message: messageString)
        }
        
        if self.title != nil || self.message != nil {
            self.headerScrollView.frame.origin = CGPoint.zero
            self.addSubview(headerScrollView)
        }
        if actions.count > 0 {
            self.addActionButtons()
            self.addSubview(buttonScrollView)
        }
        resizeAlertViewHeight()
        
        ///Check whether Title and message are present or not. If present then add separator line for message and buttons.
        if (title != nil || message != nil) && (actions.count != 0) {
            let frame = CGRect(x: 0.0, y: headerScrollView.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5)
            addSublayerLine(frame: frame, onView: headerScrollView)
        }
    }
    
    open func addAction(_ action: AUAlertAction) {
        actions.append(action)
    }
    
    private func addActionButtons() {
        
        /// Padding between two buttons
        let paddingBetweenButton = 2
        
        buttonScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
        
        ///Sorting `actions` array to keep cancel buttons in last.
        let sortedActions = actions.sorted { (action1, action2) in
            if action1.style == .cancel {
                return false
            }
            else {
                return true
            }
        }
        
        var buttonYOffset:CGFloat = 0
        
        /// Is there two buttons in single row. This possible when two buttons text are small enough to fit in single row.
        var isTwoButtonInRow = true
        
        for (index,action) in sortedActions.enumerated() {
            
            let button = AUButton.init(type: .custom)
            
            if sortedActions.count == 2 && isTwoButtonInRow {
                let cancelStringWidth:CGFloat =  sortedActions[0].title?.widthWithConstrainedHeight(buttonHeight, font:button.titleLabel?.font ?? UIFont.systemFont(ofSize: 15)) ?? 0
                
                let otherString = sortedActions[1].title ?? ""
                let otherStringWidth = otherString.widthWithConstrainedHeight(buttonHeight, font:button.titleLabel?.font ?? UIFont.systemFont(ofSize: 15))
                
                let alertHalfWidth = self.buttonScrollView.frame.size.width/2 - 10
                
                if (cancelStringWidth < alertHalfWidth) && (otherStringWidth < alertHalfWidth) {
                    if index == 0 {
                        button.frame = CGRect(x: 0.0, y: buttonYOffset, width: self.buttonScrollView.frame.size.width/2-1, height: buttonHeight)
                        
                        addSublayerLine(frame: CGRect(x: button.frame.origin.x + button.frame.size.width + 1, y: 0, width: 0.5, height: buttonHeight), onView: self.buttonScrollView)
                    }
                    else if index == 1 {
                        button.frame = CGRect(x: self.buttonScrollView.frame.size.width/2, y: buttonYOffset, width: self.buttonScrollView.frame.size.width/2, height: buttonHeight)
                    }
                }
                else{
                    isTwoButtonInRow = false
                }
            }
            else{
                isTwoButtonInRow = false
            }
            
            if !isTwoButtonInRow {
                buttonYOffset = (buttonHeight * CGFloat(index)) +  CGFloat(index * paddingBetweenButton)
                button.frame = CGRect(x: 0.0, y: buttonYOffset, width: self.buttonScrollView.frame.size.width, height: buttonHeight)
                if index != 0 {
                    let frame = CGRect(x: 0.0, y: buttonYOffset - CGFloat(paddingBetweenButton / 2), width: self.frame.size.width, height: 0.5)
                    addSublayerLine(frame: frame, onView: self.buttonScrollView)
                }
            }
            
            /// Check if `isTwoButtonInRow` true and there is any button is of type cancel.
            if isTwoButtonInRow && (sortedActions[0].style == .cancel || sortedActions[1].style == .cancel) {
                let dataIndex = (index + 1) % 2
                let dataAction = sortedActions[dataIndex]
                configActionButtons(button: button, action: dataAction)
            }
            else {
                configActionButtons(button: button, action: action)
            }
            buttonScrollView.addSubview(button)
        }
        
        /// Updating button scrollview content size
        buttonScrollView.contentSize = CGSize(width: buttonScrollView.frame.size.width, height: buttonYOffset + buttonHeight + CGFloat(paddingBetweenButton))
    }
    
    private func configActionButtons(button: AUButton, action:AUAlertAction) {
        switch action.style ?? .default {
        case .default:
            configDefaultButton(button: button, action: action)
        case .cancel:
            configCancelButton(button: button, action: action)
        case .destructive:
            configDestructiveButton(button: button, action: action)
        }
    }
    
    private func configCancelButton(button:AUButton, action:AUAlertAction) {
        configDefaultButton(button: button, action: action)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    private func configDestructiveButton(button:AUButton, action:AUAlertAction) {
        configDefaultButton(button: button, action: action)
        button.setTitleColor(UIColor.red, for: .normal)
    }
    
    private func configDefaultButton(button:AUButton, action:AUAlertAction) {
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.titleLabel?.minimumScaleFactor = 0.8
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(UIColor.init(redValue: 0, greenValue: 122, blueValue: 255), for: .normal)
        button.backgroundColor = UIColor.clear
        button.contentEdgeInsets = UIEdgeInsets(top: button.contentEdgeInsets.top, left: contentEdgeInsets.left, bottom: button.contentEdgeInsets.bottom, right: contentEdgeInsets.right)
        button.didTouchUpInside = {[weak action, weak self] (sender) in
            DispatchQueue.main.safeAsync {
                self?.dismiss()
                action?.handler?(action ?? AUAlertAction())
            }
        }
    }
    
    private func getLastViewFrame(view:UIView) -> CGRect{
        
        var frame:CGRect = CGRect.zero
        let innerSubViews = view.subviews
        if innerSubViews.count > 0 {
            let innerView = innerSubViews[innerSubViews.count - 1]
            frame = innerView.frame
        }
        return frame
    }
    
    private func resizeAlertViewHeight() {
        
        headerScrollView.frame.origin = CGPoint.zero
        
        if (headerScrollView.contentSize.height + buttonScrollView.contentSize.height) > alertViewMaxHeight {
            let tempButtonsSVHeight = actions.count > 1 ? buttonHeight + buttonHeight / 2 : buttonHeight
            if headerScrollView.contentSize.height > (alertViewMaxHeight - tempButtonsSVHeight) {
                headerScrollView.frame.size.height = alertViewMaxHeight - tempButtonsSVHeight
                buttonScrollView.frame.origin.y = headerScrollView.frame.size.height
                buttonScrollView.frame.size.height = tempButtonsSVHeight
            }
            else {
                headerScrollView.frame.size.height = headerScrollView.contentSize.height
                buttonScrollView.frame.origin.y = headerScrollView.frame.size.height
                buttonScrollView.frame.size.height = alertViewMaxHeight - headerScrollView.frame.size.height
            }
            self.frame.size.height = alertViewMaxHeight
        }
        else{
            self.frame.size.height = headerScrollView.contentSize.height + buttonScrollView.contentSize.height
            if self.frame.size.height <= 0 {
                self.frame.size.height = 100
            }
            headerScrollView.frame.size.height = headerScrollView.contentSize.height
            
            buttonScrollView.frame.origin.y = headerScrollView.frame.size.height
            buttonScrollView.frame.size.height = buttonScrollView.contentSize.height
        }
    }
    
    private func addMessageLabel(message: String) {
        let messageLabel = UILabel()
        let topPadding:CGFloat = title == nil ? contentEdgeInsets.top : 0
        let lastViewFrame = getLastViewFrame(view: self.headerScrollView)
        messageLabel.frame = CGRect(x: contentEdgeInsets.left, y: lastViewFrame.origin.y + lastViewFrame.size.height + topPadding , width: self.headerScrollView.frame.size.width - (contentEdgeInsets.left + contentEdgeInsets.right), height: 0)
        messageLabel.text = message
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.textColor = UIColor.black
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textAlignment = .center
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.frame.size.height = ceil(messageLabel.text?.heightWithConstrainedWidth(self.frame.size.width, font: messageLabel.font) ?? 0.0) + 6
        self.headerScrollView.addSubview(messageLabel)
        self.headerScrollView.contentSize.height += topPadding + messageLabel.frame.size.height + contentEdgeInsets.bottom
    }
    
    private func addTitleLabel(title: String) {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: contentEdgeInsets.left, y: contentEdgeInsets.top , width: self.headerScrollView.frame.size.width - (contentEdgeInsets.left + contentEdgeInsets.right), height: 0)
        titleLabel.text = title
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.frame.size.height = ceil(titleLabel.text?.heightWithConstrainedWidth(self.frame.size.width, font: titleLabel.font) ?? 0.0) + 2
        self.headerScrollView.addSubview(titleLabel)
        let bottomPadding = message == nil ? contentEdgeInsets.bottom : 0
        self.headerScrollView.contentSize.height += titleLabel.frame.origin.y + titleLabel.frame.size.height + bottomPadding
    }
    
    private func addSublayerLine(frame:CGRect, onView view:UIView) {
        
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.init(white: 0.0, alpha: 0.29).cgColor
        lineLayer.frame = frame
        view.layer.addSublayer(lineLayer)
    }
    
    //Gestures and Animation
    private func addGesture() {
        let tapGestureRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(dismissOnBackgroundTouch(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.isMultipleTouchEnabled = false
        self.backgroundView.addGestureRecognizer(tapGestureRecogniser)
        
        if isPanGestureEnabled {
        //Pan Gesture
        let panRecogniser = UIPanGestureRecognizer.init(target: self, action: #selector(dismissingPanGestureRecogniserPanned(_:)))
        panRecogniser.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panRecogniser)
        }
    }
    
    @objc private func dismissingPanGestureRecogniserPanned(_ panner:UIPanGestureRecognizer) {
        let translation = panner.translation(in: self.superview)
        let locationInView = panner.location(in: self.superview)
        let velocity = panner.velocity(in: self.superview)
        let vectorDistance = sqrtf(powf(Float(velocity.x), 2) + powf(Float(velocity.y), 2))
        
        if panner.state == .began {
            isDraggingAlertView = self.frame.contains(locationInView)
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
                isDraggingAlertView = self.frame.contains(locationInView)
                if isDraggingAlertView == true {
                    let translationOffset = UIOffset.init(horizontal: -1 * translation.x, vertical: -1 * translation.y)
                    self.startAlerViewDragging(location: locationInView, translationOffset: translationOffset)
                }
            }
        }
        else {
            if (vectorDistance > minimumFlickDismissalVelocity) && shouldDismissAlertViewByFlick {
                if isDraggingAlertView {
                    self.dismissAlertViewWithFlick(velocity)
                }
                else {
                    dismissWithDeleteAnimation(animated: true)
                }
            }
            else {
                self.cancelCurrentAlertviewDrag(true)
            }
        }
    }
    
    private func cancelCurrentAlertviewDrag(_ animated:Bool) {
        self.animator?.removeAllBehaviors()
        self.attachmentBehaviour = nil
        isDraggingAlertView = false
        if animated == false {
            self.transform = .identity
            self.center = UIApplication.shared.keyWindow?.center ?? CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0)
        }
        else{
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                if self.isDraggingAlertView == false {
                    self.transform = .identity
                    self.center = UIApplication.shared.keyWindow?.center ?? CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0)
                }
            }, completion: nil)
        }
    }
    
    private func dismissAlertViewWithFlick(_ velocity:CGPoint) {
        let push = UIPushBehavior.init(items: [self], mode: .instantaneous)
        push.pushDirection = CGVector.init(dx: velocity.x * 0.1, dy: velocity.y * 0.1)
        push.setTargetOffsetFromCenter(self.alertViewDragOffsetFromCenter!, for: self)
        push.action = {
            if self.alertViewIsOffScreen() {
                self.animator?.removeAllBehaviors()
                self.attachmentBehaviour = nil
                self.removeFromSuperview()
                self.dismissWithDeleteAnimation(animated: false)
            }
        }
        self.animator?.removeBehavior(self.attachmentBehaviour!)
        self.animator?.addBehavior(push)
    }
    
    private func alertViewIsOffScreen() -> Bool{
        if let keyWindow = UIApplication.shared.keyWindow {
            return self.animator?.items(in: keyWindow.frame).count == 0
        }
        else {
            return true
        }
    }
    
    private func startAlerViewDragging(location:CGPoint, translationOffset:UIOffset) {
        self.animator?.removeAllBehaviors()
        self.alertViewDragStartPoint = location
        self.alertViewDragOffsetFromActualTranslation = translationOffset
        let anchor = self.alertViewDragStartPoint
        let alertViewCenter = UIApplication.shared.keyWindow?.center ?? CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0)
        
        let offset = UIOffsetMake(location.x - alertViewCenter.x, location.y - alertViewCenter.y)
        self.alertViewDragOffsetFromCenter = offset
        
        self.attachmentBehaviour = UIAttachmentBehavior.init(item: self, offsetFromCenter: offset, attachedToAnchor: anchor ?? CGPoint.zero)
        self.animator?.addBehavior(self.attachmentBehaviour!)
        
        let modifier = UIDynamicItemBehavior.init(items: [self])
        modifier.angularResistance = appropriateAngularResistanceForView(self)
        modifier.density = appropriateDensityForView(self)
        self.animator?.addBehavior(modifier)
    }
    
    private func appropriateAngularResistanceForView(_ view:UIView) -> CGFloat{
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let actualArea = height * width
        let defaultResistance:CGFloat = 4.0
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return defaultResistance
        }
        let referenceArea = keyWindow.bounds.size.width * keyWindow.bounds.size.height
        let factor = referenceArea / actualArea
        
        let screenWidth = keyWindow.bounds.size.width
        let screenHeight = keyWindow.bounds.size.height
        let resistance = defaultResistance * ((320.0 * 480.0) / (screenWidth * screenHeight))
        return resistance * factor
    }
    
    private func appropriateDensityForView(_ view:UIView) -> CGFloat {
        let height = view.bounds.size.height
        let width = view.bounds.size.width
        let actualArea = height * width
        let defaultDensity:CGFloat = 0.5
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return defaultDensity
        }
        let referenceArea = keyWindow.bounds.size.width * keyWindow.bounds.size.height
        let factor = referenceArea / actualArea
        
        let screenWidth = keyWindow.bounds.size.width
        let screenHeight = keyWindow.bounds.size.height
        let appropriateDensity = defaultDensity * ((320.0 * 480.0) / (screenWidth * screenHeight))
        return appropriateDensity * factor
    }
    
    @objc private func dismissOnBackgroundTouch(_ gestureRecognizer:UITapGestureRecognizer){
        
        if dismissOnBackgroundTouch == true {
            guard let senderView = gestureRecognizer.view
                else {
                    return
            }
            
            if gestureRecognizer.state == .ended {
                let location = gestureRecognizer.location(in: senderView.superview)
                let closeSuperView = self.isTappedOutsideRegion(self, withLocation: location)
                if closeSuperView == true {
                    self.dismissWithDeleteAnimation(animated: true)
                }
            }
        }
    }
    
    private func isTappedOutsideRegion(_ view:UIView, withLocation location:CGPoint) -> Bool {
        let endX = view.frame.origin.x + view.frame.size.width
        let endY = view.frame.origin.y + view.frame.size.height
        
        var isValid:Bool = false
        if (location.x < view.frame.origin.x || location.y < view.frame.origin.y) || (location.x > endX || location.y > endY) {
            isValid = true
        }
        return isValid
    }
    
    func addDeviceRotationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func removeDeviceRotationNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func orientationChanged (notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {[weak self] in
            if let keyWindow = UIApplication.shared.keyWindow {
                self?.animator?.removeAllBehaviors()
                self?.center = keyWindow.center
                print(keyWindow.center)
            }
        }, completion: nil)
    }
    
    public func show() {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        setupAlertView()
        addAlertViewElements()
        addDeviceRotationNotification()
        
        keyWindow.addSubview(backgroundView)
        keyWindow.addSubview(self)
        animator?.removeAllBehaviors()
        /// To clear previous instance reference before creating new instance.
        self.animator = nil
        self.animator = UIDynamicAnimator.init(referenceView: keyWindow)
        var snapBehaviour: UISnapBehavior?
        switch alertViewAnimationType {
        case .snapBehaviour:
            snapBehaviour = UISnapBehavior.init(item: self, snapTo: keyWindow.center)
            snapBehaviour?.damping = 0.5
            self.isHidden = true
        case .popUp:
            self.center.y = keyWindow.center.y
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.isHidden = false
            break
        }
        self.center.x = keyWindow.center.x
        self.backgroundView.isHidden = true
        self.alpha = 0.0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {[weak self] in
            self?.backgroundView.isHidden = false
            self?.alpha = 1.0
            self?.isHidden = false
            switch self?.alertViewAnimationType ?? .snapBehaviour {
            case .snapBehaviour:
                self?.animator?.addBehavior(snapBehaviour!)
            case .popUp:
                self?.transform = .identity
                break
            }
        }) {[weak self] (isFinished) in
            self?.addGesture()
        }
    }
    
    public func dismiss() {
        dismissWithDeleteAnimation(animated: true)
    }
    
    private func dismissWithDeleteAnimation(animated:Bool) {
        self.animator?.removeAllBehaviors()
        removeDeviceRotationNotification()
        
        if animated {
            UIView.perform(.delete, on: [self], options: [.curveEaseInOut , .transitionCrossDissolve], animations: {[weak self] in
                self?.backgroundView.alpha = 0.0
                },completion: {[weak self] (finished) in
                    self?.configAfterAlertViewDismiss()
            })
        }
        else {
            
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {[weak self] in
                self?.backgroundView.alpha = 0.0
                self?.alpha = 0.0
                }, completion: {[weak self] (isFinished) in
                    self?.configAfterAlertViewDismiss()
            })
            
        }
    }
    
    private func configAfterAlertViewDismiss() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.tintAdjustmentMode = .automatic
        keyWindow?.tintColorDidChange()
        self.backgroundView.removeFromSuperview()
        self.removeFromSuperview()
    }
}

open class AUAlertAction: NSObject {
    var handler: ((AUAlertAction) -> Swift.Void)? = nil
    open private(set) var title: String?
    open private(set) var style: AUAlertActionStyle?
    
    public convenience init(title: String?, style: AUAlertActionStyle, handler: ((AUAlertAction) -> Swift.Void)? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
    }
}
