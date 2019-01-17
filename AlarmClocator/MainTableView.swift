//
//  ViewController.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 22/11/2018.
//  Copyright © 2018 Omer Hasson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainTableView: UITableViewController, CLLocationManagerDelegate {
    
    var chosenAlarmIndex: Int? = nil
    
    var alarms: [Alarm] = []
    
    let requestAuthorization = CLLocationManager()
    
    
    @IBAction func unwindToMainTableView(segue: UIStoryboardSegue) {}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization.requestAlwaysAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatus(notification:)), name: .AlarmSwitchChanged, object: nil)
        
        // Creating the edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.action = #selector(toggleEdditing)
        
        tableView.allowsSelectionDuringEditing = true
    }
    
    /// This func controls each alarm state
    @objc func changeStatus(notification: NSNotification) {
        let isOn = notification.userInfo!["isOn"] as! Bool
        let row = notification.userInfo!["row"] as! Int
        
        tableView.beginUpdates()
        
        alarms[row].isOn = isOn
        UserDefaults.setAlarms(alarms)
        
        tableView.endUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alarms = UserDefaults.getAlarms()
        tableView.reloadData()
        }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #Warning Incomplete implementation, return the number of rows
        
        return alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralMainScreenCell", for: indexPath) as? GeneralMainScreenCell else {
            fatalError("Cannot dequeue GeneralMainScreenCell cell")
        }
        let timer = alarms[indexPath.row].countDown
        
        if let intervalDouble = timer {
            var interval = Int(intervalDouble)
            interval /= 60
            cell.alarmTimer.text = "\(interval / 60 < 10 ? "0" : "")\(interval / 60):\(interval % 60 < 10 ? "0" : "")\(interval % 60)"
        } else {
            cell.alarmTimer.text = "None"
        }
        
        // This command changes the label's name
        cell.alarmLabel.text = alarms[indexPath.row].label
        cell.alarmLocation.text = alarms[indexPath.row].locationName
        cell.alarmSwitch.isOn = alarms[indexPath.row].isOn
        cell.alarmSwitch.tag = indexPath.row
        
        
        return cell
    }
    
    /// This func sets the size of each cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
    /// This func is adding the option of removing alarms
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        alarms = UserDefaults.getAlarms()
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            alarms.remove(at: indexPath.row)
            UserDefaults.setAlarms(alarms)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    /// This function creates the option to edit the exsiting alarms
    @objc func toggleEdditing() {
        self.setEditing(!self.isEditing, animated: true) // Set opposite value of current editing status
        for row in 0..<tableView.numberOfRows(inSection: 0){
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? GeneralMainScreenCell {
                cell.alarmSwitch.isHidden = self.isEditing
                cell.alarmTimer.isHidden = self.isEditing
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            self.chosenAlarmIndex = indexPath.row
            performSegue(withIdentifier: "EditAlarm", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Sends the chosen alarm's cell index to the AddScreen
        guard let destinationNavigationController = segue.destination as? UINavigationController, segue.identifier == "EditAlarm" else { return }
        guard let addScreen = destinationNavigationController.topViewController as? AddScreen else { return }
        addScreen.chosenAlarmIndex = self.chosenAlarmIndex
    }
    
    
    
}

