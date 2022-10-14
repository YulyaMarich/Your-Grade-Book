//
//  SubjectListTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit

class SubjectListTableViewCell: UITableViewCell {
    
    @IBOutlet var subjectNameLabel: UILabel!
    @IBOutlet var subjectMarkLabel: UILabel!
    
    var indexPath: IndexPath?
    
    func configure(with subject: Subject, mark: Double, subjectMaxPoint: Double) {
        subjectNameLabel.text = subject.name
        subjectMarkLabel.text = "\(mark) out of \(subjectMaxPoint)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
