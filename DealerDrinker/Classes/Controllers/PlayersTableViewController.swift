//
//  PlayersTableViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

class PlayersTableViewController: UITableViewController, UITextFieldDelegate {


    var nbPlayers = Int()
    var indexTable = 0

    @IBOutlet var playersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.playersTable.delegate = self
        self.playersTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("PTVC - numberOfRowsInSection - nbPlayer = \(nbPlayers)")
        return self.nbPlayers
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        NSLog("PTVC - cellForRowAtIndexPath - row = \(indexPath.row)")

        let cellPlayer = tableView.dequeueReusableCellWithIdentifier("player", forIndexPath: indexPath) as? PlayerTableViewCell
        
        // Set attributes
        cellPlayer?.labelPlayer.text = "Player \(indexPath.row + 1)"

        return cellPlayer!
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        NSLog("PTVC - textFieldShouldReturn")
        
        textField.resignFirstResponder()
        
        if indexTable < nbPlayers - 1 {
            let indexPath = NSIndexPath(forRow: self.indexTable + 1, inSection: 0)

            let cellPlayer = tableView.dequeueReusableCellWithIdentifier("player", forIndexPath: indexPath) as? PlayerTableViewCell
            NSLog("PTVC - textFieldShouldReturn - row = \(indexPath.row)")

            cellPlayer?.textFieldPlayer.becomeFirstResponder()
        } else if indexTable == nbPlayers - 1 {
            performSegueWithIdentifier("gameSegue", sender: nil)
        }
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         NSLog("PTVC - didSelectRowAtIndexPath - row = \(indexPath.row)")
        let cellPlayer = tableView.dequeueReusableCellWithIdentifier("player", forIndexPath: indexPath) as? PlayerTableViewCell

        cellPlayer?.textFieldPlayer.delegate = self
        self.indexTable = indexPath.row
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "cancelPlayersSegue") {
            view.endEditing(true)
        } else if (segue.identifier == "gameSegue") {
            
        }
    }
    

}
