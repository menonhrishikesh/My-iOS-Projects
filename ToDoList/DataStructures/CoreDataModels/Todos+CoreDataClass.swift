//
//  Todos+CoreDataClass.swift
//  ToDoList
//
//  Created by flock on 30/12/20.
//
//

import Foundation
import CoreData

@objc(Todos)
public class Todos: NSManagedObject {

    //MARK:- Create a New Todo
    class func new(model: TodoModel, onSuccess: CompletionHandler, onFailure: MessageHandler) {
        if let context = AppDelegate.shared?.managedContext, let todo = NSEntityDescription.insertNewObject(forEntityName: "Todos", into: context) as? Todos {
            self.updateTodo(todo, with: model)
            do {
                try context.save()
                onSuccess()
            } catch {
                onFailure(error.localizedDescription)
            }
            return
        }
        onFailure("No Entity Found")
    }
    
    //MARK:- Fetch All Todo Models
    class func fetchTodoModels() -> [TodoModel]? {
        if let context = AppDelegate.shared?.managedContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
            if let results = try? context.fetch(fetchRequest) {
                var todoModels = [TodoModel]()
                results.forEach { (result) in
                    if let todo = result as? Todos {
                        todoModels.append(returnTodoModel(from: todo))
                    }
                }
                return todoModels
            }
        }
        return nil
    }
    
    private class func returnTodoModel(from todo: Todos) -> TodoModel {
        let todoModel           = TodoModel(name: todo.name ?? "")
        self.updateModel(todoModel, with: todo)
        return todoModel
    }
    
    //MARK: Fetch a specific Todo
    class func fetchTodo(for model: TodoModel, context: NSManagedObjectContext) -> Todos? {
        if let id = model.id {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todos")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            if let todo = try? context.fetch(fetchRequest) as? [Todos] {
                return todo.first
            }
        }
        return nil
    }
        
    //MARK:- Save a Todo
    class func saveTodo(model: TodoModel, completion: CompletionHandler? = nil) {
        if let context = AppDelegate.shared?.managedContext, let todo = fetchTodo(for: model, context: context) {
            self.updateTodo(todo, with: model)
            if context.hasChanges {
                try? context.save()
            }
            completion?()
        }
    }
    
    //MARK:- Delete a Todo
    class func deleteTodo(model: TodoModel, completion: CompletionHandler? = nil) {
        if let context = AppDelegate.shared?.managedContext, let todo = fetchTodo(for: model, context: context) {
            context.delete(todo)
            if context.hasChanges {
                try? context.save()
            }
            completion?()
        }
    }
    
    //MARK:- Update Todo/TodoModel
    private class func updateTodo(_ todo: Todos, with model: TodoModel) {
        todo.id         = model.id
        todo.name       = model.name
        todo.completed  = model.isCompleted
        todo.created    = model.createdDate
        todo.remarks    = model.remarks
        todo.reminder   = model.reminderDate
        todo.important  = model.isImportant
        todo.category   = model.category
    }
    
    private class func updateModel(_ model: TodoModel, with todo: Todos) {
        model.id            = todo.id
        model.name          = todo.name ?? ""
        model.isCompleted   = todo.completed
        model.createdDate   = todo.created
        model.reminderDate  = todo.reminder
        model.remarks       = todo.remarks  ?? ""
        model.isImportant   = todo.important
        model.category      = todo.category ?? TodoCategories.none.rawValue
    }
    
}
