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

## AUDate (Date Utility)
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

//Getting no. of time between two dates e.g- 2s ago, 1M ago, etc.
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
    let alertView = AUAlertView(title: "Alert title", message: "Message")
    let cancelButton = AUAlertAction(title: "Cancel", style: .cancel) { (action) in
        print("Clicked on cancel button")
    }

    let okButton = AUAlertAction(title: "Ok", style: .default) { (action) in
        print("Clicked on OK button")
    }
    alertView.addAction(cancelButton)
    alertView.addAction(okButton)
    alertView.show()
```
##### Customisable property
* ###### Background
```Swift
    //Give option to select different background.
    public var backgroundType:AUBackgroundOptions = .gray
    /**
     Enum to describe AlertView background.
     */
    public enum AUBackgroundOptions {
        case blurEffectExtraLight
        case blurEffectLight
        case blurEffectDark
        case dark
        case gray
        case none
    }
 ```
 * ###### Show alertview with different animation
 ```Swift
    //Animation to show alert.
    public var alertViewAnimationType:AUAlertAnimationType = .snapBehaviour
    /**
     Enum for Alertview presenting animation
     */
    public enum AUAlertAnimationType {
        case snapBehaviour
        case popUp
    }
    
 ```
 * ###### Enable/disable alertview dismiss on click of area outside alertview.
 ```Swift
    public var dismissOnBackgroundTouch:Bool = true
 ```
 * ###### Allow to pan gesture on alertview or not.
 ```Swift
    public var isPanGestureEnabled = true
 ```
 * ###### Allow to dismiss alertview by flick or not. This work only if `isPanGestureEnabled` is enabled.
 ```Swift
    public var shouldDismissAlertViewByFlick = true
```

##### Show alertview with just cancel button
```Swift
    AUAlertView.showAlertView("Alert title", message: "Message", cancelButtonTitle: "OK")
```

## AUImageView (UIImageView Utility)
```Swift
    //AUImageView is subclass of UIImageView. Use this class to enable zoom in image view.
    let imageview = AUImageView(frame: CGRect(x: 20, y: 350, width: self.view.frame.size.width - 40, height: 200))
    self.view.addSubview(imageview)
    
    //To enable zoom
    imageview.isUserInteractionEnabled = true
    imageview.enableImageZoom = true
    
    //UIImageView extension to get image with loading indicator.
    imageview.imageWithURL("http://www.hd-wallpapersdownload.com/download/cute-tiger-pictures-wallpaper-1024x768/",               withLoadingIndictor: true) { (status) in
    //Check status whether it succeeded to get image or not. `status` will be `true` when succeed to get image and `false`         when it fails to get image.
    }
```
##### Customisable property
* ###### Maximum zoom scale
```Swift
    public var maximumZoomScale:CGFloat = 10.0
```
* ###### Minimum zoom scale
```Swift
    public var minimumZoomScale:CGFloat = -1
```
* ###### Zoom scale
```Swift
    public var zoomScale:CGFloat = 1.0
```
* ###### Zoom image background
```Swift
    public var blurZoomBackground:Bool = false
```
* ###### Enable/disable image zoom
```Swift
    public var enableImageZoom = false
```

## AUDispatchQueueExtension (DispatchQueue Utility)
```Swift
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block will be invoked immediately instead of being dispatched.
    DispatchQueue.main.safeAsync {
        //Code..
    }
```

## AULabel (UILabel Utility)
```Swift
  //Label with edge insets
  let auLabel = AULabel.init(frame:CGRect(x: 20, y: 40, width: 50, height: 30))
  //EdgeInsets to Label
  auLabel.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  
  auLabel.text = "hello"
  self.view.addSubview(auLabel)
```

## AUReachability (Network Utility)
Easy way to check internet connection.
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
