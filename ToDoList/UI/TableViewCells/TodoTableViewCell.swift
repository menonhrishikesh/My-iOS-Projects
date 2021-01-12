//
//  TodoTableViewCell.swift
//  ToDoList
//
//  Created by flock on 29/12/20.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var importantIcon: UIImageView!
    
    var model: TodoModel?
    var onButtonClick: CompletionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func reset() {
        self.radioButton.isSelected = false
        self.label.text             = ""
        self.importantIcon.isHidden = true
    }
    
    func populateCell(todoModel: TodoModel?, onRadioButtonClick: @escaping CompletionHandler) {
        self.reset()
        self.model          = todoModel
        self.onButtonClick  = onRadioButtonClick
        self.populateUI()
    }
    
    private func populateUI() {
        if let todoModel = self.model {
            self.label.text             = todoModel.name
            self.radioButton.isSelected = todoModel.isCompleted
            self.importantIcon.isHidden = !todoModel.isImportant
        }
    }
    
    @IBAction func onRadioButtonClick(_ sender: Any) {
        if let todoModel = self.model {
            todoModel.isCompleted = !todoModel.isCompleted
        }
        self.populateUI()
        self.onButtonClick?()
    }
    
}
