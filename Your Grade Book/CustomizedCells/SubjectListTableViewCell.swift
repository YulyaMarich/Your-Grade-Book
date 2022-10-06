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
    
    func configure(with subject: Subject, mark: Double) {
        subjectNameLabel.text = subject.name
        subjectMarkLabel.text = String(mark)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
