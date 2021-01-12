//
//  DatePickerView.swift
//  ToDoList
//
//  Created by flock on 30/12/20.
//

import UIKit

class DatePickerView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var onSelectingDate: DatePickerHandler?
    var view: UIView!
    
    class func instanceFromNib() -> DatePickerView {
        return UINib(nibName: "DatePickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DatePickerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
        
    func setup() {
        self.datePicker.minimumDate     = Date()
        self.datePicker.datePickerMode  = .dateAndTime
        self.doneButton.target          = self
        self.doneButton.action          = #selector(doneButtonAction(_:))
    }
    
    //MARK:- Button Actions
    @IBAction func doneButtonAction(_ sender: Any) {
        self.onSelectingDate?(self.datePicker.date)
    }
}

