//
//  ToDoTableViewHeaderFooterView.swift
//  ToDoList
//
//  Created by flock on 29/12/20.
//

import UIKit

class ToDoTableViewHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView?.backgroundColor = .black
    }
    
    func populateHeaderFooterView(text: String) {
        self.label.text = text
    }

}
