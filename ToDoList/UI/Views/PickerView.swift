//
//  PickerView.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

class PickerView: UIView {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    var view: UIView!
    var list = [String]()
    var onSelect: MessageHandler?
    
    class func instanceFromNib() -> PickerView {
        return UINib(nibName: "PickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PickerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func populatePickerView(strings: [String], onSelecting: MessageHandler?) {
        self.list       = strings
        self.onSelect   = onSelecting
        self.pickerView.reloadAllComponents()
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let row = self.pickerView.selectedRow(inComponent: 0)
        if row < self.list.count {
            self.onSelect?(self.list[row])
        }
    }
    
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
}
