//
//  AUImageView.swift
//
//  Created by Apple on 24/10/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageWithURL(urlString: String,withLoadingIndictor enable:Bool = true, completionHandler:((isSuccess: Bool) -> ())?) {
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
        self.addSubview(indicatorView)
        indicatorView.center = CGPointMake(self.bounds.size.width  / 2,
                                           self.bounds.size.height / 2);
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {[weak self] (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                indicatorView.stopAnimating()
                indicatorView.removeFromSuperview()
                if error != nil {
                    completionHandler?(isSuccess: false)
                    return
                }
                let image = UIImage(data: data ?? NSData())
                self?.image = image
                completionHandler?(isSuccess: true)
            })
        }).resume()
    }
}