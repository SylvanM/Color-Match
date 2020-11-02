//
//  SettingsTableViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    @IBOutlet weak var paintTypeChooser: UISegmentedControl!
    @IBOutlet weak var selectionSizeSliderView: UISlider!
    
    // MARK: - View Controller Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Settings.selectionWindowSize)
        
        // Retrieve saved settings and update the view accordingly
        paintTypeChooser.selectedSegmentIndex = [Settings.PaintType.acrlyic, Settings.PaintType.watercolor].firstIndex(of: Settings.paintType)!
        selectionSizeSliderView.value = Float(Settings.selectionWindowSize)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Interface Actions
    
    // Called when the user toggles the paint type thingy
    @IBAction func userDidChangePaintType(_ sender: Any) {
        Settings.paintType = [.acrlyic, .watercolor][paintTypeChooser.selectedSegmentIndex]
    }
    
    @IBAction func userDidChangeSelectionSize(_ sender: Any) {
        Settings.selectionWindowSize = Int(selectionSizeSliderView.value)
        print(Settings.selectionWindowSize)
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
