//
//  SoundTableViewController.swift
//  AlarmClocator
//
//  Created by Omer Hasson on 01/01/2019.
//  Copyright © 2019 Omer Hasson. All rights reserved.
//

import UIKit
import AudioToolbox

// This struct contains the sound's attributes 
struct SystemSounds {
    var name: String
    var id: SystemSoundID
}


class SoundTableViewController: UITableViewController {

    let sounds = [SystemSounds(name: "Anticipate", id: 1020), SystemSounds(name: "Bloom", id: 1021), SystemSounds(name: "Calypso", id: 1022), SystemSounds(name: "Choo Choo", id: 1023), SystemSounds(name: "Descent", id: 1024), SystemSounds(name: "Fanfare", id: 1025), SystemSounds(name: "Ladder", id: 1026), SystemSounds(name: "Minuet", id: 1027), SystemSounds(name: "News Flash", id: 1028), SystemSounds(name: "Noir", id: 1029), SystemSounds(name: "Sherwood Forest", id: 1030), SystemSounds(name: "Spell", id: 1031), SystemSounds(name: "Suspense", id: 1032), SystemSounds(name: "Telegraph", id: 1033), SystemSounds(name: "Tiptoes", id: 1034), SystemSounds(name: "Typewriters", id: 1035), SystemSounds(name: "Update", id: 1036)]


    var chosenCellsIndex: Int = 0
    
    var toneName: String?
    var toneId: SystemSoundID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #Warning Incomplete implementation, return the number of rows
        
        return sounds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSoundCell", for: indexPath) as? GeneralSoundCell else {
            fatalError("Cannot dequeue GeneralSoundCell cell")
        }
        // This command changes the label's name(gets the sounds name by the cell's index)
        cell.soundName.text = sounds[indexPath.row].name
        
        return cell
    }
    
    // This function gives to the user examples of the sounds
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.chosenCellsIndex = indexPath.row

        // Gets the chosen sound number in order to play it(by cell's index)
        AudioServicesPlaySystemSound(sounds[indexPath.row].id)
        // Optional: AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Changes the V location
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Sends the chosen tone to the AddScreen
        guard let destinationViewController = segue.destination as? AddScreen else {return}
        self.toneName = sounds[chosenCellsIndex].name
        self.toneId = sounds[chosenCellsIndex].id
        // If the user didn't choose any sound' the default will be the first sound
        if self.toneName == nil {
            self.toneName = sounds[1].name
            self.toneId = sounds[1].id
        }
        destinationViewController.soundName = self.toneName
        destinationViewController.soundId = self.toneId
        destinationViewController.tableView.reloadData()
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
