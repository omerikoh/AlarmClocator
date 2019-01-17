//
//  LabelSelectionCell.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 11/12/2018.
//  Copyright © 2018 Omer Hasson. All rights reserved.
//

import UIKit

class LabelSelectionCell: UITableViewCell {

    
    @IBOutlet weak var labelTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
