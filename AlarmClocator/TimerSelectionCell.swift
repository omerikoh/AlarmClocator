//
//  TimerSelectionCell.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 23/12/2018.
//  Copyright © 2018 Omer Hasson. All rights reserved.
//

import UIKit

class TimerSelectionCell: UITableViewCell {
    
    //This function is checking the status of the timer's switch
    @IBAction func didChangeTimerSwitch(_ sender: UISwitch) {
        NotificationCenter.default.post(name: .TimerSwitchChanged, object: nil, userInfo: ["isOn": sender.isOn])
    }
    
    @IBOutlet weak var timerSwitch: UISwitch!
    
    @IBOutlet weak var timerScroller: UIDatePicker!

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
    static let TimerSwitchChanged = NSNotification.Name("TimerSwitchChanged")
}

