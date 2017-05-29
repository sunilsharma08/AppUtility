//
//  AUButton.swift
//  AppUtilityExample
//
//  Created by Apple on 29/05/17.
//  Copyright © 2017 Sunil Sharma. All rights reserved.
//

import UIKit

class AUButton: UIButton {

    public typealias DidTapButton = (AUButton) -> ()
    
    open var didTouchUpInside: DidTapButton? {
        didSet {
            if didTouchUpInside != nil {
                addTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            }
            else {
                removeTarget(self, action: #selector(didTouchUpInside(sender:)), for: .touchUpInside)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTouchUpInside(sender: UIButton) {
        if let handler = didTouchUpInside {
            handler(self)
        }
    }

}
