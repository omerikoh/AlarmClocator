//
//  AddScreen.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 28/11/2018.
//  Copyright © 2018 Omer Hasson. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import AudioToolbox
import CoreLocation

class AddScreen: UITableViewController {
    
    var destination: CLLocationCoordinate2D?
    var destinationName: String?
    
    var shouldExpandTimerCell = false
    
    var soundName: String?
    var soundId: SystemSoundID?
    
    var chosenAlarmIndex: Int? = nil
    
    var text: String?
    
    var sentFromEdit: Bool = false
    
    var alarmOn: Bool = true
    
    var segmentIndex: Int = 0
    
    
    @IBAction func saveAlarm(_ sender: Any) {
        // The next 3 lines get the chosen timer countdown
        let timerSelectionCellIndexPath = IndexPath(row: 4, section: 0)
        let timerCell = self.tableView.cellForRow(at: timerSelectionCellIndexPath) as! TimerSelectionCell
        let countDown = shouldExpandTimerCell ? timerCell.timerScroller.countDownDuration : nil
        
        
        // The next 3 lines get the chosen label
        let labelCellIndexPath = IndexPath(row: 0, section: 0)
        let labelCell = self.tableView.cellForRow(at: labelCellIndexPath) as! LabelSelectionCell
        text = labelCell.labelTextField.hasText ? labelCell.labelTextField.text : labelCell.labelTextField.placeholder
        
        // The next 3 lines get the chosen segment
        let notifyOnCellIndexPath = IndexPath(row: 3, section: 0)
        let notifyOnCell = self.tableView.cellForRow(at: notifyOnCellIndexPath) as! NotifyOnSelectionCell
        segmentIndex = notifyOnCell.segmentController.selectedSegmentIndex
        
        
        // Checking if all fields have information
        if destination != nil && soundName != nil {
            // Getting the existing UserDefaults and decoding them
            
            var alarms = UserDefaults.getAlarms()
            let alarm = Alarm(locationLongitude: destination!.longitude, locationLatitude: destination!.latitude ,locationName: destinationName!, soundName: soundName!, soundId: soundId!, countDown: countDown, label: text!, segmentIndex: segmentIndex, isOn: alarmOn)
            print("latitude: \(alarm.locationLatitude) longitude: \(alarm.locationLongitude)")
            if sentFromEdit {
                alarms[chosenAlarmIndex!] = alarm
                print(alarm)
            } else {
                alarms.append(alarm)
            }
            UserDefaults.setAlarms(alarms)
            let geofenceRegionCenter = CLLocationCoordinate2D(
                latitude: alarm.locationLatitude,
                longitude: alarm.locationLongitude
            )
            
            /* Create a region centered on desired location,
             choose a radius for the region (in meters)
             choose a unique identifier for that region */
            let geofenceRegion = CLCircularRegion(
                center: geofenceRegionCenter,
                radius: 100,
                identifier: alarm.identifier
            )
            //////////////////////////////////////
            /////////////////////////////////////
            geofenceRegion.notifyOnEntry = segmentIndex == 0
            geofenceRegion.notifyOnExit = segmentIndex != 0
            
            CLLocationManager().startMonitoring(for: geofenceRegion)

            dismiss(animated: true, completion: nil) 
        } else {
            let alert = UIAlertController(title: "Alert", message: "Need to fill all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
    
    
    @IBAction func unwindToAddScreen(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStatus(notification:)), name: .TimerSwitchChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeIndex(notification:)), name: .SegmentIndexhChanged, object: nil)
        
        if chosenAlarmIndex != nil {
            let alarms = UserDefaults.getAlarms()
            let alarm = alarms[chosenAlarmIndex!]
            // Placing the edited alarm on AddScreen - label
            self.text = alarm.label
            // Placing the edited alarm on AddScreen - location
            self.destination = CLLocationCoordinate2D(latitude: alarm.locationLatitude, longitude: alarm.locationLongitude)
            self.destinationName = alarm.locationName
            // Placing the edited alarm on AddScreen - sound
            self.soundName = alarm.soundName
            self.soundId = alarm.soundId
            // Placing the edited alarm on AddScreen - segment
            self.segmentIndex = alarm.segmentIndex
            //Placing the edited alarm on AddScreen - timer
            if alarm.countDown != nil {
                self.shouldExpandTimerCell = true
            }
            self.tableView.reloadData()
            self.sentFromEdit = true
            self.alarmOn = alarm.isOn
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // This func controls the TimerCell size
    @objc func changeStatus(notification: NSNotification) {
        shouldExpandTimerCell = notification.userInfo!["isOn"] as! Bool
        
        self.tableView.beginUpdates()
        
        self.tableView.endUpdates()
        
    }
    
    @objc func changeIndex(notification: NSNotification) {
        segmentIndex = notification.userInfo!["index"] as! Int
        
        self.tableView.beginUpdates()
        
        self.tableView.endUpdates()
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LabelSelectionCell", for: indexPath) as? LabelSelectionCell else {
                fatalError("Cannot dequeue LabelSelectionCell cell")
            }
            if chosenAlarmIndex != nil {
                cell.labelTextField.text = self.text
            }
            return cell
        }
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSelectionCell", for: indexPath) as? LocationSelectionCell else {
                fatalError("Cannot dequeue cell")
            }
            cell.destinationLabel.text = self.destinationName
            return cell
        }
        if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundSelectionCell", for: indexPath) as? SoundSelectionCell else {
                fatalError("Cannot dequeue cell")
            }
            cell.toneLabel.text = self.soundName
            return cell
        }
        if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyOnSelectionCell", for: indexPath) as? NotifyOnSelectionCell else {
                fatalError("Cannot dequeue cell")
            }
            cell.segmentController.selectedSegmentIndex = self.segmentIndex
            return cell
        }
        if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimerSelectionCell", for: indexPath) as? TimerSelectionCell else {
                fatalError("Cannot dequeue TimerSelectionCell cell")
            }
            cell.timerSwitch.isOn = self.shouldExpandTimerCell
            return cell
        }
        
        // Configure the cell...
        fatalError("Undefined cell")
        
    }
    
    //this function controlls the cell's size
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 4, section: 0) && self.shouldExpandTimerCell == true {
            return 234
        }
        
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // The chosen location
        //guard let destinationViewController = segue.destination as? MainTableView else {return}
        
        
        /*
        destinationViewController.destinationName = self.locationName
        destinationViewController.destination = self.location
        destinationViewController.tableView.reloadData()
*/
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
