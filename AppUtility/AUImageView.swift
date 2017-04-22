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
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.addSubview(indicatorView)
        indicatorView.center = CGPoint(x: self.bounds.size.width  / 2,
                                           y: self.bounds.size.height / 2);
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: {[weak self] (data, response, error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                indicatorView.stopAnimating()
                indicatorView.removeFromSuperview()
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
    var enableImageZoom = true {
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
    
    private let zoomScrollView = UIScrollView.init()
    private let doubleTapGesture = UITapGestureRecognizer.init()
    private let closeButton = UIButton.init(type: .custom)
    
    private func setupGestureRecognizer() {
        doubleTapGesture.addTarget(self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        /*
         if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
         */
        showZoomView()
    }
    
    private func disableImageZoom(){
        zoomScrollView.delegate = nil
        self.removeGestureRecognizer(doubleTapGesture)
    }
    
    private func configImageZoom() {
        
        zoomScrollView.isUserInteractionEnabled = true
        zoomScrollView.delegate = self
//        zoomScrollView.frame = UIScreen.main.bounds
//        zoomScrollView.frame.origin.y = UIApplication.shared.statusBarFrame.height
//        zoomScrollView.frame.size.height = zoomScrollView.frame.size.height - UIApplication.shared.statusBarFrame.height
        zoomScrollView.backgroundColor = UIColor.black
        zoomScrollView.contentSize = self.bounds.size
        zoomScrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        closeButton.addTarget(self, action: #selector(closeZoomView(sender:)), for: .touchUpInside)
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func showZoomView() {
        
        var copyImageview = self.copyView() as? UIImageView
        if copyImageview == nil {
            copyImageview = UIImageView.init()
        }
        copyImageview?.image = self.image
        copyImageview?.tag = 10204
        copyImageview?.frame.origin.x = 0
        copyImageview?.frame.origin.y = 0
        zoomScrollView.addSubview(copyImageview!)
        
        UIApplication.shared.keyWindow?.addSubview(zoomScrollView)
        
        var zoomScrollViewFrame = UIScreen.main.bounds
        zoomScrollViewFrame.origin.y = UIApplication.shared.statusBarFrame.height
        zoomScrollViewFrame.size.height = zoomScrollViewFrame.size.height - UIApplication.shared.statusBarFrame.height
        zoomScrollView.frame = self.frame
        
        self.setZoomScale(scrollView: self.zoomScrollView)
        
        presentAnimation(copyImageview!)
        
        /*UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {[weak self] in
            self?.zoomScrollView.frame = zoomScrollViewFrame
            
        }, completion:{ (finished) in
            self.setZoomScale(scrollView: self.zoomScrollView)
            let buttonWidth:CGFloat = 50.0
            self.closeButton.frame = CGRect.init(x: self.zoomScrollView.frame.origin.x + self.self.zoomScrollView.frame.size.width - (buttonWidth + 15.0) , y: self.zoomScrollView.frame.origin.y + 20, width: buttonWidth, height: 30)
            UIApplication.shared.keyWindow?.addSubview(self.closeButton)
        })*/
    }
    
    
    func presentAnimation(_ imageView:UIImageView, completion: ((Void) -> Void)? = nil) {
        imageView.isHidden = true
        imageView.alpha = 0.0
        self.zoomScrollView.alpha = 0.0
        
        var zoomScrollViewFrame = UIScreen.main.bounds
        zoomScrollViewFrame.origin.y = UIApplication.shared.statusBarFrame.height
        zoomScrollViewFrame.size.height = zoomScrollViewFrame.size.height - UIApplication.shared.statusBarFrame.height
        zoomScrollView.frame = self.frame
        
            UIView.animate(
                withDuration: 0.6,
                delay: 0,
                usingSpringWithDamping:0.8,
                initialSpringVelocity:0,
                options:[.curveEaseInOut],
                animations: {
                    self.zoomScrollView.alpha = 1.0
                    self.zoomScrollView.frame = zoomScrollViewFrame
                    self.setZoomScale(scrollView: self.zoomScrollView)
                    imageView.isHidden = false
                    imageView.alpha = 1.0
            },
                completion: { (Bool) -> Void in
                    
                    self.setZoomScale(scrollView: self.zoomScrollView)
                    let buttonWidth:CGFloat = 50.0
                    self.closeButton.frame = CGRect.init(x: self.zoomScrollView.frame.origin.x + self.self.zoomScrollView.frame.size.width - (buttonWidth + 15.0) , y: self.zoomScrollView.frame.origin.y + 20, width: buttonWidth, height: 30)
                    UIApplication.shared.keyWindow?.addSubview(self.closeButton)
            })
        }
        
        func dismissAnimation(completion: ((Void) -> Void)? = nil) {
            
            UIView.animate(
                withDuration: 0.4,
                delay:0,
                usingSpringWithDamping:0.8,
                initialSpringVelocity:0,
                options:[.curveEaseInOut] ,
                animations: {
                self.zoomScrollView.frame = self.frame
                self.zoomScrollView.layer.opacity = 0.9
                self.setZoomScale(scrollView: self.zoomScrollView)
            }) { (finished) in
                let imageView = self.zoomScrollView.viewWithTag(10204)
                imageView?.removeFromSuperview()
                self.zoomScrollView.removeFromSuperview()
                self.closeButton.removeFromSuperview()
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
