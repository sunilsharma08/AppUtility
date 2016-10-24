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
        auImageViewExamples()
    }
    
    func auImageViewExamples() {
        let imageview = UIImageView.init(frame: CGRectMake(20, 350, 320, 200))
        imageview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(imageview)
        imageview.imageWithURL("http://www.hdwallpapers.in/download/city_of_arts_and_sciences_valencia_spain-1280x800.jpg", completionHandler: nil)
    }

    func auDateExamples() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString("11/10/2000")
        let currentDate = NSDate()
        let noOfYear = currentDate.yearsFrom(toDate: date!)
        let noOfMonths = currentDate.monthsFrom(toDate: date!)
        let noOfWeeks = currentDate.weeksFrom(toDate: date!)
        let noOfDays = currentDate.daysFrom(toDate: date!)
        let noOfHours = currentDate.hoursFrom(toDate: date!)
        let noOfMin = currentDate.minutesFrom(toDate: date!)
        let noOfSec = currentDate.secondsFrom(toDate: date!)

        let dateOffsets = NSDate().offsetFrom(toDate: date!)

        print("Number of years - \(noOfYear) \nNumber of months - \(noOfMonths) \nNumber of weeks - \(noOfWeeks) \nNumber of days - \(noOfDays) \nNumber of Hours \(noOfHours) \nNumber of Minutes \(noOfMin) \nNumber of Seconds \(noOfSec) \nDate Offsets - \(dateOffsets)")

    }

    func auStringExamples() {

        //Use of email Validation extension
        let emailString = "some@example.com"
        if emailString.isValidEmail() {
            print("Acceptable Email id")
        } else {
            print("Non acceptable Email id")
        }

        if emailString.isValidEmail("[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}") {
            print("Acceptable Email id")
        } else {
            print("Non acceptable Email id")
        }

        if emailString.validateWithRegexString("^[a-zA-Z0-9]+$") {
            print("Acceptable String")
        } else {
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
        let auLabel = AULabel.init(frame:CGRect(x: 20, y: 40, width: 50, height: 30))
        //EdgeInsets to Label
        auLabel.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        auLabel.center.x = self.view.center.x
        auLabel.text = "hello"
        auLabel.numberOfLines = 0
        //Color from hex string
        auLabel.backgroundColor = UIColor.init(hexCode: "0xfff")
        self.view.addSubview(auLabel)
    }

    func auAlertMessageExamples() {
        let showAlertButton = UIButton.init(type: .Custom)
        showAlertButton.frame = CGRect(x: 0, y: 100, width: 150, height: 50)
        showAlertButton.center.x = self.view.center.x
        showAlertButton.setTitle("Show Alert", forState: .Normal)
        showAlertButton.addTarget(self, action: #selector(showAlertButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(showAlertButton)
    }

    func showAlertButtonPressed(sender: UIButton) {
        //Showing AUAlertMessage
        AUAlertMessage().showAlertView("Title", message: "Some Message", cancelButtonTitle: "Cancel")
    }

    func auTextFieldExample() {
        let auTextField = AUTextFiled.init(frame:CGRect(x: 0, y: 220, width: 170, height: 40))
        //EdgeInsets to textfiled
        auTextField.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        auTextField.center.x = self.view.center.x
        //Color from hex value
        auTextField.backgroundColor = UIColor.init(hex: 0xffffff)
        self.view.addSubview(auTextField)

        auTextField.text = "Teexxt with padding"
    }

    func addInternetCheckButton() {
        let netCheckButton = UIButton.init(type: .Custom)
        netCheckButton.frame = CGRect(x: 0, y: 300, width: 200, height: 40)
        netCheckButton.center.x = self.view.center.x
        netCheckButton.setTitle("Check Net Connection", forState: .Normal)
        netCheckButton.addTarget(self, action: #selector(netCheckButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(netCheckButton)
    }

    func netCheckButtonPressed(sender: UIButton) {
        //Checking internet connection
        if AUReachability.sharedInstance.isNetworkReachable() {
            AUAlertMessage().showAlertView(nil, message: "Connected", cancelButtonTitle: "Cancel")
        } else {
            AUAlertMessage().showAlertView(nil, message: "Not Connected", cancelButtonTitle: "Cancel")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
