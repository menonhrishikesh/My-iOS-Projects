//
//  TodoDetailViewController.swift
//  ToDoList
//
//  Created by flock on 30/12/20.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var isImportantSwitch: UISwitch!
    @IBOutlet weak var categoryButton: UIButton!

    var onBack: CompletionHandler?
    
    var detailViewModel = DetailViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTableView.register(UINib(nibName: "TodoDetailTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TodoDetailTableViewCell")
        self.detailViewModel.setup()
        self.populateUI()
    }
    
    private func populateUI() {
        self.categoryButton.setTitle(self.detailViewModel.getCategoryString(), for: .normal)
        self.isImportantSwitch.setOn(self.detailViewModel.isImportantTodo(), animated: false)
    }
    
    //MARK:- Button Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.onBack?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func importantSwitchAction(_ sender: Any) {
        self.detailViewModel.setImportant(self.isImportantSwitch.isOn)
    }
    
    @IBAction func categoryButtonAction(_ sender: Any) {
        let pickerView = PickerView.instanceFromNib()
        pickerView.populatePickerView(strings: self.detailViewModel.getCategories()) { (category) in
            pickerView.removeFromSuperview()
            self.detailViewModel.updateCategory(selectedString: category)
            self.populateUI()
        }
        pickerView.frame = CGRect(x: 0, y: DeviceUtils.returnDeviceSize().height - 206, width: DeviceUtils.returnDeviceSize().width, height: 206)
        self.view.addSubview(pickerView)
    }
}

extension TodoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.detailViewModel.returnNumberOfSectionsForDetailTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailViewModel.returnNumberOfRowsInSectionForDetailTableView(section: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.detailViewModel.returnEstimatedHeightForRowInIndexPathForDetailTableView(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.detailViewModel.returnHeightForRowInIndexPathForDetailTableView(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.detailViewModel.returnCellForRowInIndexPathForDetailTableView(indexPath: indexPath, tableView: tableView)
    }
}
