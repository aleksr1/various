//
//  TimeDate.swift
//  QEMobile
//
//  Created by Justin Owens on 3/16/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import Foundation

extension NSDate {
    func ToDateMediumString() -> String? {
    
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter.stringFromDate(self)
    }
    
    func ToTimeShortString() -> String? {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(self)
    }
}