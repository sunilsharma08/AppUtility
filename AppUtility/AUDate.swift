//
//  AUDate.swift
//  AppUtilityExample
//
//  Created by Sunil Sharma on 27/09/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

extension Date {
    
    func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: self, to: date, options: []).year!
    }
    
    func monthsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: self, to: date, options: []).month!
    }
    
    func weeksFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: self, to: date, options: []).weekOfYear!
    }
    
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: self, to: date, options: []).day!
    }
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: self, to: date, options: []).hour!
    }
    func minutesFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: self, to: date, options: []).minute!
    }
    func secondsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: self, to: date, options: []).second!
    }
    
    func offsetFrom(_ date:Date) -> String {
        
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
