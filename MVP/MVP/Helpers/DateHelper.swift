//
//  DateHelper.swift
//  MVP
//
//  Created by Theo Vora on 5/12/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

extension Date {
    
    /// stringTimeAgo returns a string of how long ago self happened from now
    /// - Returns: Ex: "1 day ago", "3 months ago"
    func stringTimeAgo() -> String {
        let units = Array<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(Set(units), from: self, to: Date())
        
        for unit in units
        {
            guard let value = components.value(for: unit) else {
                continue
            }
            
            if value == 1 {
                return "\(value) \(unit) ago"
            } else if value > 1 {
                return "\(value) \(unit)s ago"
            }
        }
        
        return self.stringShort() // in case all the above fail
    }
    
    /// stringShort returns a date and time in "short" format.
    /// - Returns: String. Ex: "1/1/20 3:06 PM"
    func stringShort() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
}
