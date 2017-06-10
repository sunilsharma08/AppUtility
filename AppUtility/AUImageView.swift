//
//  AUImageView.swift
//
//  Created by Apple on 24/10/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    public func imageWithURL(_ urlString: String, withLoadingIndictor enable:Bool = true, completionHandler:((_ isSuccess: Bool) -> ())?) {
        var indicatorView:UIActivityIndicatorView? = nil
        if enable {
        indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.addSubview(indicatorView!)
        indicatorView?.center = CGPoint(x: self.bounds.size.width  / 2,
                                       y: self.bounds.size.height / 2);
        indicatorView?.startAnimating()
        indicatorView?.hidesWhenStopped = true
            }
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: {[weak self] (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if enable {
                indicatorView?.stopAnimating()
                indicatorView?.removeFromSuperview()
                indicatorView = nil
                }
                if error != nil {
                    completionHandler?(false)
                    return
                }
                let image = UIImage(data: data ?? Data())
                self?.image = image
                completionHandler?(true)
            })
        }).resume()
    }
}

class AUImageView: UIImageView,UIScrollViewDelegate {
    
    var maximumZoomScale:CGFloat = 10.0
    var minimumZoomScale:CGFloat = -1
    var zoomScale:CGFloat = 1.0
    var isZoomBlurBackgroundEnabled:Bool = false {
        didSet {
            if isZoomBlurBackgroundEnabled {
                createVisualEffectView()
            }
            else {
                removeVisualEffectView()
            }
        }
    }
    
    var enableImageZoom = false {
        didSet {
            if enableImageZoom {
                setupGestureRecognizer()
                configImageZoom()
            }
            else {
                disableImageZoom()
            }
        }
    }
    
    private var zoomScrollView:UIScrollView!
    private var doubleTapGesture:UITapGestureRecognizer!
    private var closeButton:UIToolbar!
    private var blurEffectView:UIVisualEffectView!
    
    private func setupGestureRecognizer() {
        if doubleTapGesture == nil {
            doubleTapGesture = UITapGestureRecognizer.init()
        }
        doubleTapGesture.addTarget(self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    private func createVisualEffectView() {
        if blurEffectView == nil {
            let blurEffect = UIBlurEffect(style:.light)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func removeVisualEffectView() {
        blurEffectView = nil
    }
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        showZoomView()
    }
    
    private func disableImageZoom(){
        zoomScrollView.delegate = nil
        self.removeGestureRecognizer(doubleTapGesture)
        zoomScrollView = nil
        doubleTapGesture = nil
        closeButton = nil
        removeVisualEffectView()
    }
    
    private func configImageZoom() {
        
        if zoomScrollView == nil {
            zoomScrollView = UIScrollView.init()
        }
        
        if closeButton == nil {
            closeButton = UIToolbar(frame: CGRect.zero)
        }
        
        zoomScrollView.isUserInteractionEnabled = true
        zoomScrollView.delegate = self
        zoomScrollView.backgroundColor = UIColor.black
        zoomScrollView.contentSize = self.bounds.size
        zoomScrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        zoomScrollView.clipsToBounds = true
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .stop , target: self, action: #selector(closeZoomView(sender:)))
        barButton.tintColor  = UIColor.white
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        closeButton.setItems([flexibleSpace,barButton,flexibleSpace], animated: false)
        closeButton.barStyle = .black
        closeButton.isTranslucent = true
        closeButton.backgroundColor = UIColor.clear
        closeButton.setBackgroundImage(UIImage(),
                                       forToolbarPosition: .any,
                                       barMetrics: .default)
        closeButton.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        createVisualEffectView()
    }
    
    func updateStatusBarToPreviousState() {
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
    }
    
    func hideStatusBar() {
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
    }
    
    func showZoomView() {
        hideStatusBar()
        guard (self.image != nil) else {
            return
        }
        let copyImageview = UIImageView(image: self.image)
        copyImageview.frame = self.frame
        
        copyImageview.tag = 10204
        copyImageview.frame.origin.x = 0
        copyImageview.frame.origin.y = 0
        zoomScrollView.addSubview(copyImageview)
        
        zoomScrollView.frame = self.frame
        
        if isZoomBlurBackgroundEnabled && blurEffectView != nil {
            zoomScrollView.backgroundColor = UIColor.clear
            blurEffectView.frame = zoomScrollView.frame
            UIApplication.shared.keyWindow?.addSubview(blurEffectView)
        }
        else {
            zoomScrollView.backgroundColor = UIColor.black
        }
        UIApplication.shared.keyWindow?.addSubview(zoomScrollView)
        self.setZoomScale(scrollView: self.zoomScrollView)
        
        presentAnimation(copyImageview)
    }
    
    func addDeviceRotationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func removeDeviceRotationNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func orientationChanged (notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {[weak self] in
            self?.zoomScrollView.frame = UIScreen.main.bounds
            if let scrollView = self?.zoomScrollView {
                self?.setZoomScale(scrollView: scrollView)
            }
        }, completion: nil)
    }
    
    func presentAnimation(_ imageView:UIImageView, completion: ((Void) -> Void)? = nil) {
        addDeviceRotationNotification()
        imageView.isHidden = true
        imageView.alpha = 0.0
        self.zoomScrollView.alpha = 0.0
        
        let zoomScrollViewFrame = UIScreen.main.bounds
        zoomScrollView.frame = self.frame
        zoomScrollView.layer.cornerRadius = self.layer.cornerRadius
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping:0.75,
            initialSpringVelocity:0,
            options:[.curveEaseInOut, .beginFromCurrentState],
            animations: {
                self.zoomScrollView.layer.cornerRadius = 0
                self.zoomScrollView.alpha = 1.0
                self.zoomScrollView.frame = zoomScrollViewFrame
                self.setZoomScale(scrollView: self.zoomScrollView)
                imageView.isHidden = false
                imageView.alpha = 1.0
                if self.blurEffectView != nil {
                    self.blurEffectView.isHidden = false
                    self.blurEffectView.layer.cornerRadius = 0
                    self.blurEffectView.frame = zoomScrollViewFrame
                }
        },
            completion: { (Bool) -> Void in
                
                self.setZoomScale(scrollView: self.zoomScrollView)
                let buttonWidth:CGFloat = 40.0
                self.closeButton.frame = CGRect.init(x: self.zoomScrollView.frame.origin.x + self.self.zoomScrollView.frame.size.width - (buttonWidth + 8.0) , y: self.zoomScrollView.frame.origin.y + 8, width: buttonWidth, height: buttonWidth)
                self.closeButton.autoresizingMask = .flexibleLeftMargin
                UIApplication.shared.keyWindow?.addSubview(self.closeButton)
                self.closeButton.alpha = 1.0
        })
    }
    
    func dismissAnimation(completion: ((Void) -> Void)? = nil) {
        updateStatusBarToPreviousState()
        removeDeviceRotationNotification()
        let imageView = self.zoomScrollView.viewWithTag(10204)
        UIView.animate(
            withDuration: 0.4,
            delay:0,
            usingSpringWithDamping:0.82,
            initialSpringVelocity:0,
            options:[.curveEaseInOut, .beginFromCurrentState] ,
            animations: {
                self.closeButton.alpha = 0.0
                self.zoomScrollView.frame = self.frame
                self.zoomScrollView.layer.cornerRadius = self.layer.cornerRadius
                imageView?.layer.cornerRadius = self.layer.cornerRadius
                self.setZoomScale(scrollView: self.zoomScrollView)
                if self.blurEffectView != nil {
                    self.blurEffectView.frame = self.frame
                    self.blurEffectView.layer.cornerRadius = self.layer.cornerRadius
                }
        }) { (finished) in
            self.zoomScrollView.layer.cornerRadius = 0
            imageView?.removeFromSuperview()
            self.zoomScrollView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            if self.blurEffectView != nil {
                self.blurEffectView.removeFromSuperview()
            }
        }
    }
    
    func closeZoomView(sender:UIButton) {
        dismissAnimation(completion: nil)
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = scrollView.viewWithTag(10204)!.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(10204)
    }
    
    private func setZoomScale(scrollView:UIScrollView) {
        
        let imageViewSize = self.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = minimumZoomScale == -1 ? min(widthScale, heightScale) : minimumZoomScale
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.zoomScale = zoomScale
    }
}
