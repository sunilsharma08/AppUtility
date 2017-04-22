//
//  ViewController.swift
//  AppUtilityExample
//
//  Created by Sunil Sharma on 05/09/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController,AUAlertMessageDelegate,UIScrollViewDelegate {

//    let imageview = UIImageView(image: UIImage.init(named: "image.jpg"))
//    let scrollView = UIScrollView.init()
    
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
        //enableImageZoom()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        setZoomScale()
//    }
    
    /*public func enableImageZoom() {
        
        scrollView.delegate = self
        scrollView.frame = self.view.bounds
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = imageview.bounds.size
        scrollView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        scrollView.addSubview(imageview)
        self.view.addSubview(scrollView)
        setZoomScale()
    }*/
    
    func auImageViewExamples() {
        let imageview = AUImageView(frame: CGRect(x: 20, y: 350, width: self.view.frame.size.width - 40, height: 200))
        imageview.backgroundColor = UIColor.white
        self.view.addSubview(imageview)
        imageview.isUserInteractionEnabled = true
        imageview.enableImageZoom = true
        imageview.image = UIImage(named: "image.jpg")
        
        //imageview.imageWithURL("http://swmini.hu/wp-content/uploads/2016/11/2WYfLt.jpg", completionHandler:{(isSuccess) in
        //})
        
    }
    
    /*
     func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageview.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageview
    }
    
     func setZoomScale() {
        
//        let imageViewSize = imageview.bounds.size
//        let scrollViewSize = scrollView.bounds.size
//        let widthScale = scrollViewSize.width / imageViewSize.width
//        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
    }
    */

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
        let aumessage = AUAlertMessage.init(title: "Title", message: "Some message", cancelButtonTitle: "Cancel", otherButtonTitles: "Other","Other2")
        aumessage.delegate = self
        aumessage.show()
        
//        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
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
