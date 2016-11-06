//
//  AUDate.swift
//  AppUtilityExample
//
//  Created by Sunil Sharma on 27/09/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

extension NSDate {
    
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: date, options: []).year
    }
    
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: self, toDate: date, options: []).month
    }
    
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: self, toDate: date, options: []).weekOfYear
    }
    
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: date, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: date, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: date, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: self, toDate: date, options: []).second
    }
    
    func offsetFrom(date:NSDate) -> String {
        
        if yearsFrom(date)   > 0 {
            return "\(yearsFrom(date))y"
        }
        else if yearsFrom(date)   < 0 {
            return "\(abs(yearsFrom(date)))y ago"
        }
        if monthsFrom(date)  > 0 {
            return "\(monthsFrom(date))M"
        }
        else if monthsFrom(date)  < 0 {
            return "\(abs(monthsFrom(date)))M ago"
        }
        if weeksFrom(date)   > 0 {
            return "\(weeksFrom(date))w"
        }
        else if weeksFrom(date)   < 0 {
            return "\(abs(weeksFrom(date)))w ago"
        }
        if daysFrom(date)    > 0 {
            return "\(daysFrom(date))d"
        }
        else if daysFrom(date)    < 0 {
            return "\(abs(daysFrom(date)))d ago"
        }
        if hoursFrom(date)   > 0 {
            return "\(hoursFrom(date))h"
        }
        else if hoursFrom(date)   < 0 {
            return "\(abs(hoursFrom(date)))h ago"
        }
        if minutesFrom(date) > 0 {
            return "\(minutesFrom(date))m"
        }
        else if minutesFrom(date) < 0 {
            return "\(abs(minutesFrom(date)))m ago"
        }
        if secondsFrom(date) > 0 {
            return "\(secondsFrom(date))s"
        }
        else if secondsFrom(date) < 0 {
            return "\(abs(secondsFrom(date)))s ago"
        }
        return ""
    }
}

public class AUDate: NSDate {
    

}
