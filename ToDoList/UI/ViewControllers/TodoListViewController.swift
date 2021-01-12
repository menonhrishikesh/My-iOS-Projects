//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by flock on 29/12/20.
//

import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var noTodosLabel: UILabel!
    @IBOutlet weak var sortedByLabel: UILabel!
    
    var listViewModel = ListViewModel()
    let detailPageSequeID = "TodoDetailSegue"
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.register(UINib(nibName: "ToDoTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ToDoTableViewHeaderFooterView")
        self.getTodos()
    }
    
    private func getTodos() {
        self.noTodosLabel.isHidden = true
        self.listViewModel.fetchData() {
            if self.listViewModel.todoLists.isEmpty, self.listViewModel.completedLists.isEmpty {
                self.noTodosLabel.isHidden = false
            }
            self.categoryButton.setTitle(self.listViewModel.returnCategoryButtonTitle(), for: .normal)
            self.sortedByLabel.text = self.listViewModel.selectedSort
            self.listTableView.reloadData()
        }
    }
    
    func handlePushNotification(todoModel: TodoModel) {
        self.listViewModel.fetchData {
            if self.listViewModel.shouldHandlePushNotification(reminderModel: todoModel) {
                self.navigateToDetailView()
            }
        }
    }
    
    private func navigateToDetailView() {
        self.performSegue(withIdentifier: self.detailPageSequeID, sender: nil)
    }
        
    //MARK:- Button Actions
    @IBAction func addTodoButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder   = "Type Here"
            textField.font          = UIFont.systemFont(ofSize: 14)
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(field:)), for: UIControl.Event.editingChanged)
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                self.listViewModel.addTodo(text: text) {
                    self.navigateToDetailView()
                }
            }
        })
        addAction.isEnabled = false
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(field: UITextField) {
        let alertController:UIAlertController = self.presentedViewController as! UIAlertController
        let addAction           = alertController.actions.first
        if let text = field.text {
            addAction?.isEnabled = !text.isEmpty
        }
    }
    
    @IBAction func categoryButtonAction(_ sender: Any) {
        showPickerView(with: listViewModel.getCategories()) { category in
            self.listViewModel.selectedCategory = category
            self.getTodos()
        }
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        showPickerView(with: listViewModel.getSortParams()) { sort in
            self.listViewModel.selectedSort = sort
            self.getTodos()
        }
    }
    
    //MARK:- Picker View
    func showPickerView(with texts: [String], onSelect: @escaping MessageHandler) {
        let pickerView = PickerView.instanceFromNib()
        pickerView.populatePickerView(strings: texts) { (category) in
            onSelect(category)
            pickerView.removeFromSuperview()
        }
        pickerView.frame = CGRect(x: 0, y: DeviceUtils.returnDeviceSize().height - 206, width: DeviceUtils.returnDeviceSize().width, height: 206)
        self.view.addSubview(pickerView)
    }
    
    //MARK:- Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailPageSequeID {
            if let todoDetailController                         = segue.destination as? TodoDetailViewController {
                todoDetailController.detailViewModel.todoModel  = self.listViewModel.selectedTodoForDetailView
                todoDetailController.onBack                     = { self.getTodos() }
            }
        }
    }

}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listViewModel.returnNumberOfSectionsForListTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel.returnNumberOfRowsInSectionForListTableView(section: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.listViewModel.returnEstimatedHeightForHeaderInSectionForListTableView(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.listViewModel.returnHeightForHeaderInSectionForListTableView(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.listViewModel.returnViewForHeaderInSectionForListTableView(section: section, tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listViewModel.returnEstimatedHeightForRowInIndexPathForListTableView(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listViewModel.returnEstimatedHeightForRowInIndexPathForListTableView(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.listViewModel.returnCellForRowInIndexPathForListTableView(indexPath: indexPath, tableView: tableView) {
            self.listTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listViewModel.didSelectRowAtIndexPathForListTableView(indexPath: indexPath) {
            self.navigateToDetailView()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.listViewModel.returnCanEditRowInIndexPathForListTableView()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return self.listViewModel.returnEditingStyleForRowInIndexPathForListTableView()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.listViewModel.didCommitEditingAtIndexPathForListViewTableView(indexPath: indexPath, editingStyle: editingStyle, controller: self) {
            self.getTodos()
        }
    }
    
    
}
