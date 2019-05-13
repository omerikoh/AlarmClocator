//
//  GeneralMainScreenCell.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 05/01/2019.
//  Copyright © 2019 Omer Hasson. All rights reserved.
//

import UIKit

class GeneralMainScreenCell: UITableViewCell {
    
    @IBOutlet weak var alarmLabel: UILabel!
    
    @IBOutlet weak var alarmLocation: UILabel!
    
    @IBOutlet weak var alarmTimer: UILabel!
    
    @IBOutlet weak var alarmState: UILabel!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        NotificationCenter.default.post(name: .AlarmSwitchChanged, object: nil, userInfo: ["isOn": sender.isOn, "row": sender.tag])
    }
    
    
    
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
    static let AlarmSwitchChanged = NSNotification.Name("AlarmSwitchChanged")
}
