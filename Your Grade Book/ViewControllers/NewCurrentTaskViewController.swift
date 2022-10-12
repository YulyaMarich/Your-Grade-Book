//
//  NewCurrentTaskViewController.swift
//  Your Grade Book
//
//  Created by Julia on 04.01.2022.
//

import UIKit

class NewCurrentTaskViewController: UIViewController {
    
    @IBOutlet var newTaskTextField: UITextField!
    @IBOutlet var maxTaskMarkTextField: UITextField!
    
    @IBOutlet var systemButton: UIButton!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var coefficientStack: UIStackView!
    @IBOutlet var coefficientTextField: UITextField!
    
    var subject: Subject!
    var currentTask: Task?
    
    private var currentSystem: System?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
    }
    
    // MARK: - IBAction
    
    @IBAction func pressCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressDone(_ sender: Any) {
        guard let newTask = newTaskTextField.text, let maxTaskMark = maxTaskMarkTextField.text, let coefficient = coefficientTextField.text else { return }
        
        if checkForLetters(text: maxTaskMark) == false {
            showAlert(with: AlertText.wrongFormatOfMark.title, message: AlertText.wrongFormatOfMark.message)
            return
        }
        
        if systemButton.currentTitle == "Accumulation" {
            currentSystem = System.accumulativeSystem
        } else {
            if checkForLetters(text: coefficient) == false {
                showAlert(with: AlertText.wrongFormatOfCoefficient.title, message: AlertText.wrongFormatOfCoefficient.message)
                return
            }
            currentSystem = System.gpa
        }
        
        if let currentTask = currentTask {
            StorageManager.shared.changeCurrentTask(currentTask: currentTask, name: newTask, maxPoint: Double(makeStringInTheFormOfDoubleFrom(text: maxTaskMark)) ?? 0.0, systemType: currentSystem ?? .accumulativeSystem, coefficient: Double(makeStringInTheFormOfDoubleFrom(text: coefficient)) ?? 1)
        } else {
            let task = Task()
            task.name = newTask
            task.maxPoint = Double(makeStringInTheFormOfDoubleFrom(text: maxTaskMark)) ?? 0.0
            task.systemType = currentSystem ?? .accumulativeSystem
            task.coefficient = Double(makeStringInTheFormOfDoubleFrom(text: coefficient)) ?? 1
            
            StorageManager.shared.save(task: task, into: subject)
            
        }
        dismiss(animated: true)
    }
    
    // MARK: - Setting functions
    
    private func setUpVC() {
        setUpPupUpButton()
        setUpData()
        
        [newTaskTextField, maxTaskMarkTextField, coefficientTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
        let newTaskTextFieldDoneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(pressDoneNewTaskTextFieldDoneButton))
        let maxTaskMarkTextFieldDoneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(pressDoneMaxTaskMarkTextFieldDoneButton))
        let coefficientTextFieldDoneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(pressDoneCoefficientTextFieldDoneButton))
        
        newTaskTextField.addToolbar(trailing: [newTaskTextFieldDoneButton])
        maxTaskMarkTextField.addToolbar(trailing: [maxTaskMarkTextFieldDoneButton])
        coefficientTextField.addToolbar(trailing: [coefficientTextFieldDoneButton])
    }
    
    private func setUpPupUpButton() {
        var config = UIButton.Configuration.filled()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "System", size: 14)
            return outgoing
        }
        systemButton.titleLabel?.textAlignment = .center
        systemButton.configuration = config
        
        let gpaItem = UIAction(title: System.gpa.rawValue) { (action) in
            self.currentSystem = .gpa
            self.coefficientStack.isHidden = false
        }
        
        let accumulativeItem = UIAction(title: System.accumulativeSystem.rawValue) { (action) in
            self.currentSystem = .accumulativeSystem
            self.coefficientStack.isHidden = true
            
        }
        let menu = UIMenu(title: "", options: .displayInline, children: [gpaItem, accumulativeItem])
        
        systemButton.menu = menu
        systemButton.showsMenuAsPrimaryAction = true
    }
    
    private func setUpData() {
        if let currentTask = currentTask {
            newTaskTextField.text = currentTask.name
            maxTaskMarkTextField.text = String(currentTask.maxPoint)
            systemButton.menu?.children.forEach({ action in
                guard let action = action as? UIAction else { return }
                
                switch currentTask.systemType {
                case .gpa:
                    if action.title == System.gpa.rawValue{
                        action.state = .on
                        coefficientTextField.text = String(currentTask.coefficient)
                    }
                    
                case .accumulativeSystem:
                    if action.title == System.accumulativeSystem.rawValue {
                        action.state = .on
                        coefficientStack.isHidden = true
                    }
                }
            })
        } else {
            doneButton.isEnabled = false
        }
    }
    
    private func checkForLetters(text: String) -> Bool {
        if text.isNumber {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - @objc functions
    
    @objc func editingChanged() {
        guard
            let newTaskText = newTaskTextField.text, !newTaskText.isEmpty,
            let maxTaskMarkText = maxTaskMarkTextField.text, !maxTaskMarkText.isEmpty
        else {
            doneButton.isEnabled = false
            return
        }
        if systemButton.currentTitle == "Grade point average" {
            guard
                let coefficient = coefficientTextField.text, !coefficient.isEmpty
            else {
                doneButton.isEnabled = false
                return
            }
        }
        
        doneButton.isEnabled = true
    }
    
    @objc func pressDoneNewTaskTextFieldDoneButton() {
        view.endEditing(true)
    }
    
    @objc func pressDoneMaxTaskMarkTextFieldDoneButton() {
        if checkForLetters(text: maxTaskMarkTextField.text ?? "") {
            if maxTaskMarkTextField.text != "" {
                maxTaskMarkTextField.text = makeStringInTheFormOfDoubleFrom(text: maxTaskMarkTextField.text ?? "")
            }
            view.endEditing(true)
        } else {
            showAlert(with: AlertText.wrongFormatOfMark.title, message: AlertText.wrongFormatOfMark.message)
        }
    }
    
    @objc func pressDoneCoefficientTextFieldDoneButton() {
        if checkForLetters(text: coefficientTextField.text ?? "") {
            if coefficientTextField.text != "" {
                coefficientTextField.text = makeStringInTheFormOfDoubleFrom(text: coefficientTextField.text ?? "")
            }
            view.endEditing(true)
        } else {
            showAlert(with: AlertText.wrongFormatOfCoefficient.title, message: AlertText.wrongFormatOfCoefficient.message)
        }
    }
}
