//
//  CurrentTaskTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit

protocol CurrentTaskCellDelegate {
    func showSomeAlert(with title: String, message: String)
    func isWrongFormatOf(input: String) -> Bool
    func getDoubleFrom(text: String) -> String
}

class CurrentTaskTableViewCell: UITableViewCell {
    
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
    
    //MARK: - Point processing functions
    
    private func updateNumber() {
        guard let currentTask = currentTask, let currentMarkText = markTextField.text, let number = Double(delegate?.getDoubleFrom(text: currentMarkText) ?? "") else { return }
        
        StorageManager.shared.changeCurrentTask(currentTask: currentTask, with: number)
    }
    
    private func checkMarkTextFieldText() -> Bool {
        guard let markText = markTextField.text, let task = task else { return false }
        let mark = Double(markText)
        if markText.isEmpty {
            delegate?.showSomeAlert(with: AlertText.emptyTextField.title, message: AlertText.emptyTextField.message)
            return false
        } else if let mark = mark, mark > Double(task.maxPoint) {
            delegate?.showSomeAlert(with: AlertText.markIsHigherThanMaximum.title, message: AlertText.markIsHigherThanMaximum.message)
            return false
        } else if delegate?.isWrongFormatOf(input: markText) == true {
            delegate?.showSomeAlert(with: AlertText.wrongFormatOfMark.title, message: AlertText.wrongFormatOfMark.message)
            return false
        } else {
            return true
        }
    }
    
    private func changePoint() {
        let result = checkMarkTextFieldText()
        
        if result == true {
            markTextField.text = delegate?.getDoubleFrom(text: markTextField.text ?? "")
            updateNumber()
        } else {
            markTextField.text = "0.0"
            updateNumber()
        }
    }
    
    //MARK: - Setting functions
    
    private func makeToolBarButton() {
        let doneButton = UITextField.ToolbarItem(title: "Done",
                                                 target: self,
                                                 selector: #selector(pressToolBarDoneButton))
        markTextField.addToolbar(trailing: [doneButton])
    }
    
    @objc func pressToolBarDoneButton() {
        self.endEditing(true)
        changePoint()
    }
}
