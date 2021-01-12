//
//  DateUtils.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

class DateUtils: NSObject {
    
    class func returnStringFromDate(_ date: Date?, in format: String) -> String {
        guard date != nil else {
            return ""
        }
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        return dateFormatter.string(from: date!)
    }
    
    
    
}
