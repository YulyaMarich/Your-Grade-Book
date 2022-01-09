//
//  CurrentTaskTableViewCell.swift
//  Your Grade Book
//
//  Created by Julia on 05.01.2022.
//

import UIKit

class CurrentTaskTableViewCell: UITableViewCell {

    @IBOutlet var currentTaskLabel: UILabel!
    @IBOutlet var markTextField: UITextField!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
