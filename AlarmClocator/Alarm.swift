//
//  Alarm.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 07/01/2019.
//  Copyright © 2019 Omer Hasson. All rights reserved.
//

import Foundation
import MapKit
import AVFoundation
import AudioToolbox

struct Alarm: Codable, Equatable {
    var locationLongitude: Double
    var locationLatitude: Double
    var locationName: String
    var soundName: String
    var soundId: SystemSoundID
    var countDown: TimeInterval?
    var label: String
    
    var isOn: Bool
    
    var identifier: String
    
    init(locationLongitude: Double, locationLatitude: Double, locationName: String, soundName: String, soundId: SystemSoundID, countDown: TimeInterval?, label: String, isOn: Bool = true) {
        self.locationLongitude = locationLongitude
        self.locationLatitude = locationLatitude
        self.locationName = locationName
        self.soundName = soundName
        self.soundId = soundId
        self.countDown = countDown
        self.label = label
        self.isOn = isOn
        self.identifier = UUID().uuidString
    }
}
