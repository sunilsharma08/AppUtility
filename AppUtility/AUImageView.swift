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
            }
            else {
                disableImageZoom()
            }
        }
    }
    
    private let zoomScrollView = UIScrollView.init()
    private let doubleTapGesture = UITapGestureRecognizer.init()
    
    private func setupGestureRecognizer() {
        //let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTapGesture.addTarget(self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
//        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
//            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
//        } else {
//            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
//        }
        configImageZoom()
    }
    
    private func disableImageZoom(){
        zoomScrollView.delegate = nil
        self.removeGestureRecognizer(doubleTapGesture)
    }
    private func configImageZoom() {
        //let scrollview = UIScrollView.init()
        zoomScrollView.isUserInteractionEnabled = true
        zoomScrollView.delegate = self
        zoomScrollView.frame = UIScreen.main.bounds
        zoomScrollView.backgroundColor = UIColor.black
        zoomScrollView.contentSize = self.bounds.size
        zoomScrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        self.frame.origin.x = 0
        self.frame.origin.y = 0
        //let imageSuperView = self.superview
        //self.removeFromSuperview()
        zoomScrollView.addSubview(self)
        UIApplication.shared.keyWindow?.addSubview(zoomScrollView)
        setZoomScale(scrollView: zoomScrollView)
        
        let closeButton = UIButton.init(type: .custom)
        let buttonWidth:CGFloat = 60.0
        closeButton.frame = CGRect.init(x: zoomScrollView.frame.origin.x + zoomScrollView.frame.size.width - (buttonWidth + 20.0) , y: zoomScrollView.frame.origin.y + 20, width: buttonWidth, height: 40)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeZoomView(sender:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(closeButton)
    }
    
    func closeZoomView(sender:UIButton) {
        zoomScrollView.removeFromSuperview()
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = self.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self
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
