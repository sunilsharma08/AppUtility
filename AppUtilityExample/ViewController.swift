//
//  ViewController.swift
//  AppUtilityExample
//
//  Created by Sunil Sharma on 05/09/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController,AUAlertMessageDelegate {

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
        
        /*let someView = UIView.init(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        someView.center = self.view.center
        self.view.addSubview(someView)
        someView.isUserInteractionEnabled = true
        someView.backgroundColor = UIColor.yellow
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dismissPanTouch(_:)))
        someView.addGestureRecognizer(panGesture)*/
        
        /*let tapGestureRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(dismissOnBackgroundTouch(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        //self.backgroundView.isMultipleTouchEnabled = false
        self.view.addGestureRecognizer(tapGestureRecogniser)*/
        //printFonts()
    }
    
    /*func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    func dismissPanTouch(_ gestureRecognizer:UIPanGestureRecognizer){
        print("\(#function)")
        let translate = gestureRecognizer.translation(in: self.view)
        gestureRecognizer.view?.center = CGPoint(x:gestureRecognizer.view!.center.x + translate.x,y:gestureRecognizer.view!.center.y + translate.y)
        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func dismissOnBackgroundTouch(_ gestureRecognizer:UITapGestureRecognizer){
        print("\(#function)")
    }
 */
    
    func auImageViewExamples() {
        let imageview = UIImageView.init(frame: CGRect(x: 20, y: 350, width: self.view.frame.size.width - 40, height: 200))
        imageview.backgroundColor = UIColor.white
        self.view.addSubview(imageview)
        imageview.imageWithURL("http://www.hdwallpapers.in/download/city_of_arts_and_sciences_valencia_spain-1280x800.jpg", completionHandler: nil)
    }

    func auDateExamples() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "11/10/2020")
        let currentDate = Date()
        let noOfYear = currentDate.yearsFrom(Date.init(timeIntervalSince1970: 3000000000))
        let noOfMonths = currentDate.monthsFrom(date!)
        let noOfWeeks = currentDate.weeksFrom(date!)
        let noOfDays = currentDate.daysFrom(date!)
        let noOfHours = currentDate.hoursFrom(date!)
        let noOfMin = currentDate.minutesFrom(date!)
        let noOfSec = currentDate.secondsFrom(date!)

        let dateOffsets = Date().offsetFrom(date!)

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
        print("string height \(someString.heightWithConstrainedWidth(320, font: UIFont.systemFont(ofSize: 15)))")
        print("string width \(someString.widthWithConstrainedHeight(45, font: UIFont.systemFont(ofSize: 15)))")
    }

    func auColorExamples() {
        //Use Color RGB Value
        self.view.backgroundColor = UIColor.init(redValue: 199, greenValue: 165, blueValue: 247)
        //self.view.backgroundColor = UIColor.init(hex:0xff0000, alpha:0.8)
        //self.view.backgroundColor = UIColor.init(hexCode: "#ff0000")
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
        let showAlertButton = UIButton.init(type: .custom)
        showAlertButton.frame = CGRect(x: 0, y: 100, width: 150, height: 50)
        showAlertButton.center.x = self.view.center.x
        showAlertButton.setTitle("Show Alert", for: UIControlState())
        showAlertButton.addTarget(self, action: #selector(showAlertButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(showAlertButton)
    }

    func showAlertButtonPressed(_ sender: UIButton) {
        //Showing AUAlertMessage
        //AUAlertMessage().showAlertView("Title", message: "Some Message", cancelButtonTitle: "Cancel")
        //DispatchQueue.main.async {
        //AUAlertMessage.c
        let aumessage = AUAlertMessage.init(title: "Title", message: "Some message", cancelButtonTitle: "Cancel", otherButtonTitles: "Other","Cancel2")
        //let aumessage = AUAlertMessage.init(title: "Title", message: "Message", cancelButtonTitle: nil)
        //aumessage.addButtonTitle("some")
            //aumessage.setupAlertView()
        aumessage.delegate = self
            aumessage.show()
        //}
        //print("cancel button index = \(aumessage.cancelButtonIndex())")
        
        //UIAlertView.init(title: "Title", message: "Message", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "Other", "More..").show()
        
        //let alert = UIAlertView.init(title: "Title", message: "Message", delegate: nil, cancelButtonTitle: "Cancel", otherButtonTitles: "ok","1","2")
        //alert.show()
//        print("cancel \(alert.cancelButtonIndex)")
        
//        var arr = ["ddell"]
//        arr.insert("large", at: 1)
//        print("arr = \(arr)")
//        let alert = UIAlertView.init(title: "Title", message: "Message", delegate: nil, cancelButtonTitle: "Cancel").show()
        
    }
    
    func auAlertMessageClickedOn(button: UIButton, index: Int, title: String) {
        print("\(index) \(title)")
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
    
    func addNumber(a:Int,multiply b:Int) {
        
    }

    func addInternetCheckButton() {
        let netCheckButton = UIButton.init(type: .custom)
        netCheckButton.frame = CGRect(x: 0, y: 300, width: 200, height: 40)
        netCheckButton.center.x = self.view.center.x
        netCheckButton.setTitle("Check Net Connection", for: UIControlState())
        netCheckButton.addTarget(self, action: #selector(netCheckButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(netCheckButton)
    }

    func netCheckButtonPressed(_ sender: UIButton) {
        //Checking internet connection
        if AUReachability.sharedInstance.isNetworkReachable() {
            AUAlertMessage().showAlertView(nil, message: "Connected", cancelButtonTitle: "Cancel")
        }
        else {
            AUAlertMessage().showAlertView(nil, message: "Not Connected", cancelButtonTitle: "Cancel")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
