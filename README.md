# AppUtility
AppUtility is a library which contains small code snippets that we need in almost every project like converting color hex to rgb, checking internet connectivity, etc.

#Installation
Just drag the folder "AppUtility" with the source files into your project.

#Usage
```Swift
//Using direct RGB value no need to divide every time with 255.0
UIColor.init(redValue: 199, greenValue: 165, blueValue: 247)

//Getting color with hex value
UIColor.init(hex: 0xffffff)

//Display alert view
AUAlertMessage().showAlertView("Title", message: "Message", cancelButtonTitle: "Cancel")
```
#License
AppUtility is available under the [MIT License](https://raw.githubusercontent.com/sunilsharma08/AppUtility/master/License).
