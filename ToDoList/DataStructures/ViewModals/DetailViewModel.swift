//
//  DetailViewModel.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

class DetailViewModel: NSObject {

    var todoModel: TodoModel?
    var details = [TodoDetails]()
    var categories = TodoCategories.returnCategories()
    
    func setup() {
        self.details    = [TodoDetails.todo, TodoDetails.reminder, TodoDetails.remarks]
    }
    
    //MARK:- Get Methods
    func getCategories() -> [String] {
        return self.categories
    }
    
    func isImportantTodo() -> Bool {
        return todoModel?.isImportant ?? false
    }
    
    func getCategoryString() -> String {
        return todoModel?.category ?? TodoCategories.none.rawValue
    }
    
    //MARK:- Updates
    func setImportant(_ important: Bool) {
        if let model = self.todoModel {
            model.isImportant   = important
            Todos.saveTodo(model: model)
        }
    }
    
    func updateCategory(selectedString: String) {
        if let model = self.todoModel {
            model.category = selectedString
            Todos.saveTodo(model: model)
        }
    }
    
    //MARK:- TableViewHelpers
    func returnNumberOfSectionsForDetailTableView() -> Int {
        return 1
    }
    
    func returnNumberOfRowsInSectionForDetailTableView(section: Int) -> Int {
        return self.details.count
    }
    
    func returnEstimatedHeightForRowInIndexPathForDetailTableView(indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func returnHeightForRowInIndexPathForDetailTableView(indexPath: IndexPath) -> CGFloat {
        return TodoDetailTableViewCell.returnHeightForTodoDetailCell(todoModel: self.todoModel, detailType: self.details[indexPath.row])
    }
    
    func returnCellForRowInIndexPathForDetailTableView(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoDetailTableViewCell") as! TodoDetailTableViewCell
        cell.populateTodoDetailCell(detailType: self.details[indexPath.row], todoModel: self.todoModel)
        return cell
    }
    
}
