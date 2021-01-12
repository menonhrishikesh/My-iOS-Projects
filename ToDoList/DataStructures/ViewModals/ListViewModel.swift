//
//  ListViewModel.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

class ListViewModel: NSObject {

    var todoLists = [TodoModel]()
    var completedLists = [TodoModel]()
    var selectedTodoForDetailView: TodoModel?
    var categories = TodoCategories.returnCategories()
    var selectedCategory: String = TodoCategories.none.rawValue
    var sortParams = [SortParams.dateWise.rawValue, SortParams.important.rawValue]
    var selectedSort: String = SortParams.dateWise.rawValue
    
    //MARK:- Fetch Todos
    func fetchData(completion: CompletionHandler) {
        self.todoLists.removeAll()
        self.completedLists.removeAll()
        if let todoModels = Todos.fetchTodoModels() {
            for model in todoModels {
                if model.isCompleted {
                    self.completedLists.append(model)
                } else {
                    self.todoLists.append(model)
                }
                if self.selectedCategory != TodoCategories.none.rawValue {
                    self.todoLists      = self.todoLists.filter({ $0.category == selectedCategory })
                    self.completedLists = self.completedLists.filter({$0.category == selectedCategory })
                }
            }
            self.sortTodos()
        }
        completion()
    }
    
    private func sortTodos() {
        if selectedSort == SortParams.dateWise.rawValue {
            self.todoLists.sort(by: { $0.returnReminderDate() < $1.returnReminderDate() })
            self.completedLists.sort(by: { $0.returnReminderDate() < $1.returnReminderDate() })
        } else {
            self.todoLists.sort(by: { $0.isImportant && !$1.isImportant })
            self.completedLists.sort(by: {$0.isImportant && !$1.isImportant })
        }
    }
    
    //MARK:- Get Methods
    private func returnTodoModel(for indexPath: IndexPath) -> TodoModel? {
        var todoModel: TodoModel?
        if indexPath.section == 0, !self.completedLists.isEmpty {
            todoModel   = self.completedLists[indexPath.row]
        } else {
            todoModel   = self.todoLists[indexPath.row]
        }
        return todoModel
    }
    
    func getCategories() -> [String] {
        return self.categories
    }
    
    func getSortParams() -> [String] {
        return self.sortParams
    }
    
    func returnCategoryButtonTitle() -> String {
        if self.selectedCategory == TodoCategories.none.rawValue {
            return "All To-dos"
        }
        return self.selectedCategory
    }
    
    func shouldHandlePushNotification(reminderModel: TodoModel?) -> Bool {
        if let todoModel = reminderModel {
            if let model = self.todoLists.first(where: { $0.id == todoModel.id }) {
                self.selectedTodoForDetailView = model
                return true
            } else if let model = self.completedLists.first(where: { $0.id == todoModel.id }) {
                self.selectedTodoForDetailView = model
                return true
            }
        }
        return false
    }
    
    //MARK:- Add or Update
    func addTodo(text: String, completion: CompletionHandler) {
        let todoModel = TodoModel(name: text)
        Todos.new(model: todoModel, onSuccess: {
            self.selectedTodoForDetailView = todoModel
            completion()
        }) { (message) in
            print(message)
        }
    }
    
    func updateList(model: TodoModel, completion: CompletionHandler) {
        if model.isCompleted {
            if !self.completedLists.contains(model) {
                self.completedLists.append(model)
                self.completedLists.sort(by: { $0.createdDate ?? Date() < $1.createdDate ?? Date() })
                self.todoLists.removeAll(where: { $0 == model })
            }
        } else {
            if !self.todoLists.contains(model) {
                self.todoLists.append(model)
                self.todoLists.sort(by: { $0.createdDate ?? Date() < $1.createdDate ?? Date() })
                self.completedLists.removeAll(where: { $0 == model })
            }
        }
        completion()
    }
                        
    //MARK:- TableViewHelpers
    func returnNumberOfSectionsForListTableView() -> Int {
        if self.completedLists.isEmpty, self.todoLists.isEmpty {
            return 0
        }
        if self.completedLists.isEmpty || self.todoLists.isEmpty {
            return 1
        }
        return 2
    }
    
    func returnNumberOfRowsInSectionForListTableView(section: Int) -> Int {
        if !self.completedLists.isEmpty, section == 0 {
            return self.completedLists.count
        }
        return self.todoLists.count
    }
    
    func returnEstimatedHeightForHeaderInSectionForListTableView(section: Int) -> CGFloat {
        return 50
    }
    
    func returnHeightForHeaderInSectionForListTableView(section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func returnViewForHeaderInSectionForListTableView(section: Int, tableView: UITableView) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ToDoTableViewHeaderFooterView") as! ToDoTableViewHeaderFooterView
        var headerText = "To-dos"
        if section == 0, !self.completedLists.isEmpty {
            headerText = "Completed"
        }
        headerView.populateHeaderFooterView(text: headerText)
        return headerView
    }
    
    func returnEstimatedHeightForRowInIndexPathForListTableView(indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func returnHeightForRowInIndexPathForListTableView(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func returnCellForRowInIndexPathForListTableView(indexPath: IndexPath, tableView: UITableView, reloadTable: @escaping CompletionHandler) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell") as! TodoTableViewCell
        let todoModel = self.returnTodoModel(for: indexPath)
        cell.populateCell(todoModel: todoModel) {
            if let model = todoModel {
                Todos.saveTodo(model: model)
                self.updateList(model: model, completion: reloadTable)
            }
            
        }
        return cell
    }
    
    func didSelectRowAtIndexPathForListTableView(indexPath: IndexPath, completion: CompletionHandler) {
        var todosArray = self.todoLists
        if indexPath.section == 0, !self.completedLists.isEmpty {
            todosArray = self.completedLists
        }
        if todosArray.count > indexPath.row {
            self.selectedTodoForDetailView = todosArray[indexPath.row]
            completion()
        }
    }
    
    //MARK: Swipe to Delete
    func returnCanEditRowInIndexPathForListTableView() -> Bool {
        return true
    }
    
    func returnEditingStyleForRowInIndexPathForListTableView() -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func didCommitEditingAtIndexPathForListViewTableView(indexPath: IndexPath, editingStyle: UITableViewCell.EditingStyle, controller: UIViewController, completion: @escaping CompletionHandler) {
        if editingStyle == .delete {
            AlertUtils.showAlert(title: "Delete this Todo", message: nil, leftButtonTitle: "No", leftButtonStyle: .cancel, leftButtonAction: nil, rightButtonTitle: "Yes", rightButtonStyle: .destructive,rightButtonAction: {
                if let todoModel = self.returnTodoModel(for: indexPath) {
                    NotificationUtils.cancelLocalNotification(with: todoModel.id)
                    Todos.deleteTodo(model: todoModel, completion: completion)
                }
            }, controller: controller)
            
        }
    }
}
