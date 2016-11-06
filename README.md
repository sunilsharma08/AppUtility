# AppUtility
AppUtility is a library which contains small code snippets that we need in almost every project like converting color hex to rgb, checking internet connectivity, etc.

# Installation
Just drag the folder "AppUtility" with the source files into your project.

# Usage
## UIColor Utility
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

## NSDate Utility
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

## Alert messages
```Swift
//Display alert view
AUAlertMessage().showAlertView("Title", message: "Message", cancelButtonTitle: "Cancel")
```

#Contribution
Feel free to add code which you think is necessary in almost every project. 

#License
AppUtility is available under the [MIT License](https://raw.githubusercontent.com/sunilsharma08/AppUtility/master/License).
