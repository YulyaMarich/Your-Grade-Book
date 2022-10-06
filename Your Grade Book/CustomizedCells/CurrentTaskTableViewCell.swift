//
//  CurrentTaskTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit

protocol CurrentTaskCellDelegate {
    func showAlert(with title: String, message: String)
}

class CurrentTaskTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var currentTaskLabel: UILabel!
    @IBOutlet var markTextField: UITextField!
    @IBOutlet var viewCell: UIView!
    
    var delegate: CurrentTaskCellDelegate?
    var task: Task?
    var currentTask: CurrentTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        makeToolBarButton()
    }
    
    func configure(name: String, mark: String) {
        currentTaskLabel.text = name
        markTextField.text = mark
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateNumber() {
        guard let currentTask = currentTask, let number = Double(markTextField.text ?? "0.0") else { return }
        
        StorageManager.shared.changeCurrentTask(currentTask: currentTask, with: number)
    }
    
    
    func checkMarkTextFieldText() -> Bool {
        guard let markText = markTextField.text, !markText.isEmpty, let task = task else { return false }
        let mark = Double(markText)
        if mark == nil {
            delegate?.showAlert(with: "Incorrect data format", message: "Please check your mark for extra characters.")
            return false
        } else if let mark2 = mark, mark2 > Double(task.maxPoint) {
            delegate?.showAlert(with: "Your mark is higher than the maximum", message: "Please change your mark or maximum mark.")
            return false
        } else {
            return true
        }
    }
    
    func changePoint() {
        let result = checkMarkTextFieldText()
        
        if result == true {
            updateNumber()
        } else {
            markTextField.text = "0.0"
            updateNumber()
        }
    }
    
    func makeToolBarButton() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(pressToolBarDoneButton))
        
        toolBar.items = [flexibleSpace, doneButton]
        markTextField.inputAccessoryView = toolBar
    }
    
    @objc func pressToolBarDoneButton() {
        self.endEditing(true)
        changePoint()
    }
}
