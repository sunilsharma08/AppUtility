//
//  ViewController.swift
//  AppUtilityExample
//
//  Created by Sunil Sharma on 05/09/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        auColorExamples()
        auLabelExamples()
    }
    
    func auColorExamples() {
        //Use Color RGB Value
        self.view.backgroundColor = UIColor.init(redValue: 240, greenValue: 0, blueValue: 60)
    }
    
    func auLabelExamples() {
        //Label with edge insets
        let auLabel = AULabel.init(frame:CGRectMake(20, 40, 50, 30))
        auLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        auLabel.text = "hello"
        auLabel.numberOfLines = 0
        auLabel.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(auLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

