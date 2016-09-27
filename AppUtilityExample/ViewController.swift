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
        addInternetCheckButton()
        auStringExamples()
        auDateExamples()
    }
    
    func auDateExamples() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString("11/11/1999")
        let noOfYear = NSDate().yearsFrom(date!)
        let noOfMonths = NSDate().monthsFrom(date!)
        let noOfWeeks = NSDate().weeksFrom(date!)
        let noOfDays = NSDate().daysFrom(date!)
        let noOfHours = NSDate().hoursFrom(date!)
        let noOfMin = NSDate().minutesFrom(date!)
        let noOfSec = NSDate().secondsFrom(date!)
        
        let dateOffsets = NSDate().offsetFrom(date!)
        
        print("Number of years - \(noOfYear) \n Number of months - \(noOfMonths) \n Number of weeks - \(noOfWeeks) \n Number of days - \(noOfDays) \n Number of Hours \(noOfHours) \n Number of Minutes \(noOfMin) \n number of Seconds \(noOfSec) \n Date Offsets - \(dateOffsets)")
        
    }
    
    func auStringExamples() {
        
        //Use of email Validation extension
        let emailString = "some@example.com"
        if emailString.isValidEmail() {
            print("Acceptable Email id")
        }
        else{
            print("Non acceptable Email id")
        }
        
        if emailString.isValidEmail("[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}") {
            print("Acceptable Email id")
        }
        else{
            print("Non acceptable Email id")
        }
        
        if emailString.validateWithRegexString("^[a-zA-Z0-9]+$") {
            print("Acceptable String")
        }
        else{
            print("Non acceptable string")
        }
        
        //Getting height of string via extension.
        let someString = "This string will  be used to calculate height of string through extension"
        print("\(someString.heightWithConstrainedWidth(320, font: UIFont.systemFontOfSize(15)))")
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
        //Color from hex value
        auTextField.backgroundColor = UIColor.init(hex: 0xffffff)
        self.view.addSubview(auTextField)
        
        auTextField.text = "Teexxt with padding"
    }
    
    func addInternetCheckButton() {
        let netCheckButton = UIButton.init(type: .Custom)
        netCheckButton.frame = CGRectMake(0, 300, 200, 40)
        netCheckButton.center.x = self.view.center.x
        netCheckButton.setTitle("Check Net Connection", forState: .Normal)
        netCheckButton.addTarget(self, action: #selector(netCheckButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(netCheckButton)
    }
    
    func netCheckButtonPressed(sender:UIButton) {
        //Checking internet connection
        if AUReachability.sharedInstance.isNetworkReachable() {
            AUAlertMessage().showAlertView(nil, message: "Connected", cancelButtonTitle: "Cancel")
        }
        else{
            AUAlertMessage().showAlertView(nil, message: "Not Connected", cancelButtonTitle: "Cancel")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

