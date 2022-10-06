//
//  SubjectTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit

class SubjectTableViewCell: UITableViewCell {
    
    @IBOutlet var markLabel: UILabel!
    @IBOutlet var taskLabel: UILabel!
    
    var indexPath: IndexPath?
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with task: Task, mark: Double) {
        taskLabel.text = task.name
        markLabel.text = String(mark)
    }
}
