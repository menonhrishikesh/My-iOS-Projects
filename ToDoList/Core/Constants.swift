//
//  Constants.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

typealias CompletionHandler = () -> ()
typealias MessageHandler = (_ message: String) -> ()
typealias DatePickerHandler = (_ date: Date) -> ()

enum TodoDetails {
    case todo
    case reminder
    case remarks
}

enum TodoCategories: String {
    case work       = "Work"
    case personal   = "Personal"
    case none       = "No Category"
    
    static func returnCategories() -> [String] {
        return [TodoCategories.none.rawValue, TodoCategories.personal.rawValue, TodoCategories.work.rawValue]
    }
}

enum NotificationTypes: String {
    case reminderNotification = "Reminder Notification"
}

enum SortParams: String {
    case dateWise   = "Date"
    case important  = "Important"
}
    

