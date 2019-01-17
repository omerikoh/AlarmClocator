//
//  DefaultsManager.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 15/01/2019.
//  Copyright © 2019 Omer Hasson. All rights reserved.
//

import UIKit

extension UserDefaults {
    static func getAlarms() -> [Alarm] {
        if let encoded = UserDefaults.standard.data(forKey: "Alarms") {
            do {
                return try PropertyListDecoder().decode([Alarm].self, from: encoded)
            } catch {
                print("failed to decode")
            }
        }
        
        setAlarms([Alarm]())
        return [Alarm]()
    }
    
    static func setAlarms(_ alarms: [Alarm]) {
        do {
            // Sending the UserDefaults and encoding them
            let encodedData: Data = try PropertyListEncoder().encode(alarms)
            UserDefaults.standard.set(encodedData, forKey: "Alarms")
        } catch {
            print("failed to encode")
        }
    }
}
