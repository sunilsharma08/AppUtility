//
//  AUImageView.swift
//
//  Created by Apple on 24/10/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageWithURL(_ urlString: String,withLoadingIndictor enable:Bool = true, completionHandler:((_ isSuccess: Bool) -> ())?) {
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
