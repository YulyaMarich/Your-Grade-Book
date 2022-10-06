//
// NewSubjectViewController.swift
//  Your Grade Book
//
//  Created by Julia on 04.01.2022.
//

import UIKit

class NewSubjectViewController: UIViewController {
    
    @IBOutlet var newSubjectNameTextField: UITextField!
    @IBOutlet var maxSubjectMark: UITextField!
    
    var subject: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    //MARK: - IBActions
    @IBAction func pressCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressDoneButton(_ sender: Any) {
        guard let newSubject = newSubjectNameTextField.text, let maxSubjectMark = maxSubjectMark.text else { return }
        guard !newSubject.isEmpty, !maxSubjectMark.isEmpty else { return }
        
        if let subject = subject {
            StorageManager.shared.changeSubject(subject: subject, name: newSubject, maxPoint: Int(maxSubjectMark) ?? 0)
        } else {
            let subject = Subject()
            subject.name = newSubject
            subject.maxPoint = Int(maxSubjectMark) ?? 0
            
            StorageManager.shared.save(subject: subject)
        }
        dismiss(animated: true)
    }
    
    // MARK: - Setting function
    func setUpData() {
        if let subject = subject {
            newSubjectNameTextField.text = subject.name
            maxSubjectMark.text = String(subject.maxPoint)
        }
    }
}
