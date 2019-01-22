//
//  NotifyOnSelectionCell.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 21/01/2019.
//  Copyright © 2019 Omer Hasson. All rights reserved.
//

import UIKit

class NotifyOnSelectionCell: UITableViewCell {
    
    @IBAction func didChangeState(_ sender: UISegmentedControl) {
        NotificationCenter.default.post(name: .SegmentIndexhChanged, object: nil, userInfo: ["index": sender.selectedSegmentIndex ])
    }
    
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Notification.Name {
    static let SegmentIndexhChanged = NSNotification.Name("SegmentIndexhChanged")
}
