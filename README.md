# AppUtility
AppUtility is collection of useful code snippets that we need in almost every project like getting UIColor from hex code, checking internet connectivity, etc. extensions of Standard struct and classes and subclass of standard classes like UIImageView,String,etc.
#### Little Theory
What I found is that several time we have to repeat same steps in every project sometime even in same project and at the end increase development time. So why not we can reduce boilerplate code and make develement little easier by keeping most used methods and some common features that we expect from standard classes. These common methods we need in almost every project like converting color hex to RGB, String height, Image zoom, Internet connection check, etc. 

Some code snippets are taken from  Stackoverflow, Github and some are added by me.

# Installation
Just drag the folder "AppUtility" with the source files into your project.

# Usage
## AUColor (UIColor Utility)
#### UIColor Extensions
```Swift
//Using direct RGB value no need to divide every time with 255.0
UIColor.init(redValue: 199, greenValue: 165, blueValue: 247)

//Getting color with hex value, default alpha value is 1.0
UIColor.init(hex: 0xffffff)

//Getting color with hex and alpha value
UIColor.init(hex:0xff0000, alpha:0.8)

//Getting color with hex string
//Hex with alpha
UIColor.init(hexCode: "#ff0000ff")

//Hex with no alpha (alpha will be 1.0)
UIColor.init(hexCode: "#ff0000")

//Hex string in short form
UIColor.init(hexCode: "#f00")
```

## AUDate (NSDate Utility)
#### Date Extensions
```Swift
//Getting no. of years between two dates
let noOfYear = NSDate().yearsFrom(NSDate.init(timeIntervalSince1970: 3000000000))

//Getting no. of months between two dates
let noOfMonths = NSDate().monthsFrom(NSDate.init(timeIntervalSince1970: 3000000000))

//Getting no. of weeks between two dates
let noOfWeeks = NSDate().weeksFrom(NSDate.init(timeIntervalSince1970: 3000000000))

//Getting no. of days between two dates
let noOfDays = NSDate().daysFrom(NSDate.init(timeIntervalSince1970: 3000000000))

//Getting no. of hours between two dates
let noOfHours = NSDate().hoursFrom(NSDate.init(timeIntervalSince1970: 3000000000))

//Getting no. of minutes between two dates
let noOfMin = NSDate().minutesFrom(NSDate.init(timeIntervalSince1970: 3000000000))

//Getting no. of seconds between two dates
let noOfSec = NSDate().secondsFrom(NSDate.init(timeIntervalSince1970: 3000000000))

Getting no. of time between two dates e.g- 2s ago, 1M ago, etc.
let dateOffsets = NSDate().offsetFrom(NSDate.init(timeIntervalSince1970: 3000000000))
```

## AUImage (UIImage Utility)
#### UIImage Extensions
```Swift
//Create a image of specified color and size
let image = UIImage.imageWithColor(UIColor.redColor(), size: CGSizeMake(100, 100))

//Create horizontal gradient color image
let image = UIImage.imageWithGradient([UIColor.redColor().CGColor,UIColor.yellowColor().CGColor], size: CGSizeMake(560, 400))

//Create vertical gradient color image
let image = UIImage.imageWithGradient([UIColor.redColor().CGColor,UIColor.yellowColor().CGColor], size: CGSizeMake(560, 400), verticalGradient: true)

//Resizing image while maintaing aspect ratio
let resizedImage:UIImage = image?.resizeImage(CGSizeMake(200, 200))

//Compress image size(compression should be between 0.0 - 1.0)
let compressedImage:UIImage = image?.compressImage(0.5)

//Fix for rotating image when using imagePicker
let fixImage:UIImage = image?.fixOrientation()
```
## AUAlertView (Alert message Utility)
```Swift
//Display alert view
let alllert = AUAlertView(title: "Title", message: "Message description")
let button = AUAlertAction(title: "Cancel", style: .cancel){ (action) in
    print("Clicked on button \(action.title ?? "title is nil")")
}
let button1 = AUAlertAction(title: "Ok", style: .default) { (action) in
    print("Clicked on button \(action.title ?? "title is nil")")
}

alllert.addAction(button)
alllert.addAction(button1)
alllert.show()
```

## AUImageView (UIImageView Utility)
```Swift
    let imageview = AUImageView(frame: CGRect(x: 20, y: 350, width: self.view.frame.size.width - 40, height: 200))
    imageview.backgroundColor = UIColor.white
    self.view.addSubview(imageview)
    imageview.isUserInteractionEnabled = true
    imageview.enableImageZoom = true
    imageview.blurZoomBackground = false
    imageview.clipsToBounds = true
    //imageview.layer.cornerRadius = 100
    //imageview.image = UIImage(named: "image.jpg")
    //http://www.hdwallpapers.in/download/city_of_arts_and_sciences_valencia_spain-1280x800.jpg
    //http://swmini.hu/wp-content/uploads/2016/11/2WYfLt.jpg
    imageview.imageWithURL("http://www.hdwallpapers.in/download/city_of_arts_and_sciences_valencia_spain-1280x800.jpg", withLoadingIndictor: true) { (status) in

    }
```

## AUButton (UIButton Utility)

## AUDispatchQueueExtension (DispatchQueue Utility)

## AULabel (UILabel Utility)
```Swift
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
```

## AUReachability (Network Utility)
```Swift
    if AUReachability.sharedInstance.isNetworkReachable() {
        AUAlertView.showAlertView(nil, message: "Connected", cancelButtonTitle: "Cancel")
    }
    else {
        AUAlertView.showAlertView(nil, message: "Not Connected", cancelButtonTitle: "Cancel")
    }
```

# Contribution
Feel free to add code which you think is necessary in almost every project.

# Sources
* [Stackoverflow](http://stackoverflow.com/)
* [Github Gist](https://gist.github.com/discover)
* Other websites

# License
AppUtility is available under the [MIT License](https://raw.githubusercontent.com/sunilsharma08/AppUtility/master/License).
