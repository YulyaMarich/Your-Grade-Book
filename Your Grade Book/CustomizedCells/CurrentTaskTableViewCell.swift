//
//  CurrentTaskTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit
import Combine

protocol CurrentTaskCellDelegate {
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
    
    let pressOkButtonAction = PassthroughSubject<[String], Never>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeToolBarButton()
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
            pressOkButtonAction.send([AlertText.emptyTextField.title, AlertText.emptyTextField.message])
            return false
        } else if let mark = mark, mark > Double(task.maxPoint) {
            pressOkButtonAction.send([AlertText.markIsHigherThanMaximum.title, AlertText.markIsHigherThanMaximum.message])
            return false
        } else if delegate?.isWrongFormatOf(input: markText) == true {
            pressOkButtonAction.send([AlertText.wrongFormatOfMark.title, AlertText.wrongFormatOfMark.message])
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
    
    func configure(name: String, mark: String) {
        currentTaskLabel.text = name
        markTextField.text = mark
    }
    
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
