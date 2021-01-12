//
//  Todos+CoreDataProperties.swift
//  ToDoList
//
//  Created by flock on 30/12/20.
//
//

import Foundation
import CoreData


extension Todos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todos> {
        return NSFetchRequest<Todos>(entityName: "Todos")
    }

    @NSManaged public var id: String?
    @NSManaged public var completed: Bool
    @NSManaged public var created: Date?
    @NSManaged public var name: String?
    @NSManaged public var reminder: Date?
    @NSManaged public var remarks: String?
    @NSManaged public var important: Bool
    @NSManaged public var category: String?

}

extension Todos : Identifiable {

}
