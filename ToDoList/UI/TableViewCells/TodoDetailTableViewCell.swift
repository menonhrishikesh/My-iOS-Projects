//
//  TodoDetailTableViewCell.swift
//  ToDoList
//
//  Created by flock on 30/12/20.
//

import UIKit

class TodoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var clearButton: UIButton!
    
    var detailType: TodoDetails?
    var todoModel: TodoModel?
    
    var placeholderText = ""
    
    static let horizontalConstantSpace: CGFloat = 136
    
    class func returnHeightForTodoDetailCell(todoModel: TodoModel?, detailType: TodoDetails) -> CGFloat {
        if detailType == .remarks, let text = todoModel?.remarks {
            return text.height(with: DeviceUtils.returnDeviceSize().width - horizontalConstantSpace)
        }
        return UITableView.automaticDimension
    }
    
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    deinit {
        self.reset()
    }
    
    private func reset() {
        self.todoModel              = nil
        
        self.placeholderText        = ""
        
        self.textView.text          = ""
        self.textView.inputView     = nil
        
        self.clearButton.isHidden   = true
        self.radioButton.isSelected = false
        self.radioButton.setImage(nil, for: .normal)
        self.radioButton.setImage(nil, for: .selected)
    }
    
    func populateTodoDetailCell(detailType: TodoDetails, todoModel: TodoModel?) {
        self.reset()
        self.detailType     = detailType
        if let model = todoModel {
            self.todoModel  = model
            switch detailType {
            case .todo:
                self.placeholderText        = "To-do"
                self.populateTextView(text: model.name)
                self.radioButton.isSelected = model.isCompleted
                self.radioButton.setImage(UIImage(named: "radio_off"), for: .normal)
                self.radioButton.setImage(UIImage(named: "radio_on"), for: .selected)
                break
            case .reminder:
                self.placeholderText        = "Add reminder"
                self.populateTextView(text: model.returnReminderString())
                self.clearButton.isHidden   = model.returnReminderString().isEmpty
                self.radioButton.setImage(UIImage(named: "notification_bell"), for: .normal)
                self.addDatePickerAsInputView(model: model)
                break
            case .remarks:
                self.placeholderText    = "Remarks"
                self.populateTextView(text: model.remarks)
                self.radioButton.setImage(UIImage(named: "remark_notes"), for: .normal)
                break
            }
        }
    }
    
    private func populateTextView(text: String) {
        if text.isEmpty {
            self.textView.text  = self.placeholderText
        } else {
            self.textView.text  = text
        }
    }
    
    func addDatePickerAsInputView(model: TodoModel) {
        let datePicker = DatePickerView.instanceFromNib()
        datePicker.onSelectingDate = { selectedDate in
            self.textView.resignFirstResponder()
            model.reminderDate  = selectedDate
            self.populateTextView(text: model.returnReminderString())
            self.clearButton.isHidden   = model.returnReminderString().isEmpty
            self.updateModel(text: nil, date: selectedDate, completed: nil)
            NotificationUtils.scheduleNotification(title: "Todo:", subtitle: model.name, body: model.remarks, date: selectedDate, notificationID: model.id)
        }
        self.textView.inputView = datePicker
    }
    
    func updateModel(text: String?, date: Date?, completed: Bool?) {
        if let type = self.detailType {
            switch type {
            case .todo:
                if let todoName = text {
                    self.todoModel?.name        = todoName
                }
                break
            case .reminder:
                self.todoModel?.reminderDate    = date
                break
            case .remarks:
                if let remarks = text {
                    self.todoModel?.remarks     = remarks
                }
                break
            }
        }
        
        if completed != nil {
            self.todoModel?.isCompleted = completed!
        }
        if let model = self.todoModel {
            Todos.saveTodo(model: model)
        }
    }

    //MARK:- Button Actions
    @IBAction func radioButtonClicked(_ sender: Any) {
        self.radioButton.isSelected = !self.radioButton.isSelected
        self.updateModel(text: nil, date: nil, completed: self.radioButton.isSelected)
    }
    
    @IBAction func clearButtonClicked(_ sender: Any) {
        self.textView.text          = self.placeholderText
        self.clearButton.isHidden   = true
        NotificationUtils.cancelLocalNotification(with: self.todoModel?.id)
        self.updateModel(text: nil, date: nil, completed: nil)
    }
}

extension TodoDetailTableViewCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.placeholderText {
            self.textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = self.placeholderText
            self.updateModel(text: "", date: nil, completed: nil)
        } else {
            self.updateModel(text: textView.text, date: nil, completed: nil)
        }
        return true
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            
//            self.updateModel(text: text, date: nil, completed: nil)
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
}
