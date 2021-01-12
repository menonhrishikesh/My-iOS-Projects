//
//  TodoModel.swift
//  ToDoList
//
//  Created by flock on 29/12/20.
//

import UIKit

class TodoModel: NSObject {

    var id: String?
    var name: String = ""
    var isCompleted: Bool = false
    var createdDate: Date?
    var reminderDate: Date?
    var remarks: String = ""
    var isImportant: Bool = false
    var category: String = TodoCategories.none.rawValue
        
    init(name: String) {
        super.init()
        self.populateTodoModel(name: name)
    }
    
    func populateTodoModel(name: String) {
        self.id             = UUID().uuidString
        self.name           = name
        self.isCompleted    = false
        self.createdDate           = Date()
    }
    
    func returnReminderString() -> String {
        if let reminder = self.reminderDate {
            return DateUtils.returnStringFromDate(reminder, in: "dd MMM yyy, hh:mm a")
        }
        return ""
    }
    
    func returnCreatedDate() -> Date {
        return self.createdDate ?? Date()
    }
    
    func returnReminderDate() -> Date {
        return self.reminderDate ?? Date()
    }
}
