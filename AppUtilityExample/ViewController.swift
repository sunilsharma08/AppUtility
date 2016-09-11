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
        auAlertMessageExamples()
        auTextFieldExample()
    }
    
    func auColorExamples() {
        //Use Color RGB Value
        self.view.backgroundColor = UIColor.init(redValue: 199, greenValue: 165, blueValue: 247)
    }
    
    func auLabelExamples() {
        //Label with edge insets
        let auLabel = AULabel.init(frame:CGRectMake(20, 40, 50, 30))
        //EdgeInsets to Label
        auLabel.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        auLabel.center.x = self.view.center.x
        auLabel.text = "hello"
        auLabel.numberOfLines = 0
        //Color from hex string
        auLabel.backgroundColor = UIColor.init(hexCode: "0xfff")
        self.view.addSubview(auLabel)
    }
    
    func auAlertMessageExamples() {
        let showAlertButton = UIButton.init(type: .Custom)
        showAlertButton.frame = CGRectMake(0, 100, 150, 50)
        showAlertButton.center.x = self.view.center.x
        showAlertButton.setTitle("Show Alert", forState: .Normal)
        showAlertButton.addTarget(self, action: #selector(showAlertButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(showAlertButton)
    }

    func showAlertButtonPressed(sender:UIButton) {
        //Showing AUAlertMessage
        AUAlertMessage().showAlertView("Title", message: "Some Message", cancelButtonTitle: "Cancel")
    }
    
    func auTextFieldExample() {
        let auTextField = AUTextFiled.init(frame:CGRectMake(0,220 ,170 , 40))
        //EdgeInsets to textfiled
        auTextField.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        auTextField.center.x = self.view.center.x
        auTextField.backgroundColor = UIColor.init(hex: 0xffffff)
        self.view.addSubview(auTextField)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

