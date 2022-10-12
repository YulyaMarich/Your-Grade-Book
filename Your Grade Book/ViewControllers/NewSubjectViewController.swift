//
// NewSubjectViewController.swift
//  Your Grade Book
//
//  Created by Julia on 04.01.2022.
//

import UIKit

class NewSubjectViewController: UIViewController {
    
    @IBOutlet var newSubjectNameTextField: UITextField!
    @IBOutlet var maxSubjectMarkTextField: UITextField!
    
    @IBOutlet var doneButton: UIBarButtonItem!
    
    var subject: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVC()
        setUpData()
    }
    
    //MARK: - IBActions
    
    @IBAction func pressCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressDoneButton(_ sender: Any) {
        guard let newSubject = newSubjectNameTextField.text, let maxSubjectMark = maxSubjectMarkTextField.text else { return }
        
        if checkMarkTextFieldText() == false {
            return
        }
        
        if let subject = subject {
            StorageManager.shared.changeSubject(subject: subject, name: newSubject, maxPoint: Double(makeStringInTheFormOfDoubleFrom(text: maxSubjectMark)) ?? 0.0)
        } else {
            let subject = Subject()
            subject.name = newSubject
            subject.maxPoint = Double(makeStringInTheFormOfDoubleFrom(text: maxSubjectMark)) ?? 0.0
            
            StorageManager.shared.save(subject: subject)
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - Setting functions
    
    private func setUpData() {
        if let subject = subject {
            newSubjectNameTextField.text = subject.name
            maxSubjectMarkTextField.text = String(subject.maxPoint)
        } else {
            doneButton.isEnabled = false
        }
    }
    
    private func setUpVC() {
        [maxSubjectMarkTextField, newSubjectNameTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
        let newSubjectNameTextFieldDoneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(newSubjectNameTextFieldDoneButtonPressed))
        let maxSubjectMarkDoneButton = UITextField.ToolbarItem(title: "Done", target: self, selector: #selector(maxSubjectMarkDoneButtonPressed))
        
        newSubjectNameTextField.addToolbar(trailing: [newSubjectNameTextFieldDoneButton])
        maxSubjectMarkTextField.addToolbar(trailing: [maxSubjectMarkDoneButton])
    }
    
    private func checkMarkTextFieldText() -> Bool {
        guard let markText = maxSubjectMarkTextField.text else { return false}
        
        if isWrongFormatOf(text: markText) == true {
            showAlert(with: AlertText.wrongFormatOfMark.title, message: AlertText.wrongFormatOfMark.message)
            return false
        } else {
            return true
        }
    }
    
    // MARK: - @objc functions
    
    @objc func newSubjectNameTextFieldDoneButtonPressed() {
        view.endEditing(true)
    }
    
    @objc func maxSubjectMarkDoneButtonPressed() {
        if checkMarkTextFieldText() {
            if maxSubjectMarkTextField.text != "" {
                maxSubjectMarkTextField.text = makeStringInTheFormOfDoubleFrom(text: maxSubjectMarkTextField.text ?? "")
            }
            view.endEditing(true)
        }
    }
    
    @objc func editingChanged() {
        guard let maxSubjectMark = maxSubjectMarkTextField.text, !maxSubjectMark.isEmpty,
              let newSubjectName = newSubjectNameTextField.text, !newSubjectName.isEmpty
        else {
            doneButton.isEnabled = false
            return
        }
        
        doneButton.isEnabled = true
    }
}
