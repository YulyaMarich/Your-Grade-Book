//
//  SubjectListTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit

class SubjectListTableViewCell: UITableViewCell {

    @IBOutlet var subjectNameLabel: UIView!
    @IBOutlet var subjectMarkLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
