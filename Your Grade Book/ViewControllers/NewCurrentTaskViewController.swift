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
    
    @IBOutlet var coefficientStack: UIStackView!
    @IBOutlet var coefficientTextField: UITextField!
    
    var currentSystem: System?
    var currentTask: Task?
    
    var subject: Subject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSystem = currentTask?.systemType
        
        setUpPupUpButton()
        setUpData()
    }
    
    // MARK: - IBAction
    @IBAction func pressCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressDone(_ sender: Any) {
        guard let newTask = newTaskTextField.text, let maxTaskMark = maxTaskMarkTextField.text, let coefficient = coefficientTextField.text else { return }
        
        if systemButton.currentTitle == "Накопичення" {
            currentSystem = System.accumulativeSystem
        } else {
            currentSystem = System.gpa
        }
        
        guard !newTask.isEmpty, !maxTaskMark.isEmpty else { return }
        
        if let currentTask = currentTask {
            StorageManager.shared.changeCurrentTask(currentTask: currentTask, name: newTask, maxPoint: Int(maxTaskMark) ?? 0, systemType: currentSystem ?? .accumulativeSystem, coefficient: Double(coefficient) ?? 1)
        } else {
            let task = Task()
            task.name = newTask
            task.maxPoint = Int(maxTaskMark) ?? 0
            task.coefficient = Double(coefficient) ?? 1
            
            StorageManager.shared.save(task: task, into: subject)
            
        }
        dismiss(animated: true)
    }
    
    
    // MARK: - Setting functions
    func setUpPupUpButton() {
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
    
    func setUpData() {
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
        }
    }
}
