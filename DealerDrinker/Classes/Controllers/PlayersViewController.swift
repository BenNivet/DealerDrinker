//
//  PlayersViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit
import CoreData

class PlayersViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var labelPlayer: UILabel!
    @IBOutlet weak var textFieldPlayer: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var submitPlayer: UIButton!
    
    var nbPlayer = 0
    
    var managedContext = NSManagedObjectContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: "isGaming")
        
        textFieldPlayer.delegate = self
        
        labelPlayer.text = "Player \(nbPlayer + 1)"
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
        emptyPlayersTables()
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isGaming: Int = defaults.integerForKey("isGaming") {
            if isGaming == 1 {
                performSegueWithIdentifier("cancelPlayersSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func addPlayer(sender: AnyObject) {
        updateData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        updateData()
        return true
    }
    
    func updateData() {
        if textFieldPlayer.text != "" {
            NSLog("PVC - Add player")
            
            let newPlayer: Players = NSEntityDescription.insertNewObjectForEntityForName("Players", inManagedObjectContext: managedContext) as! Players
            newPlayer.name = textFieldPlayer.text!
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error)")
            }
            
            nbPlayer += 1
            
            // Reset field
            labelPlayer.text = "Player \(nbPlayer + 1)"
            textFieldPlayer.text = ""
        }
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        NSLog("PVC - Submit player")

        if nbPlayer >= 2 {
            let newNbPlayer: Stats = NSEntityDescription.insertNewObjectForEntityForName("Stats", inManagedObjectContext: managedContext) as! Stats
            newNbPlayer.nbPlayers = nbPlayer
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }

            performSegueWithIdentifier("gameSegue", sender: nil)
        } else {
            NSLog("Limit min players incorrect")
            // Alert
            self.displayEndGameAlert()
        }
    }
    
    func emptyPlayersTables() {
        let context = self.managedContext
        
        // Empty Players Table
        let fetchRequest = NSFetchRequest(entityName: "Players")
        fetchRequest.includesPropertyValues = false
        
        // Get results
        
        do {
            if let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Players] {
                for result in fetchResults {
                    context.deleteObject(result)
                }
                try context.save()
            }
            
        } catch let error as NSError  {
            NSLog("Could not save \(error)")
        }
        
        // Empty Stats Table
        let fetchRequestStats = NSFetchRequest(entityName: "Stats")
        fetchRequestStats.includesPropertyValues = false
        
        // Get results
        do {
            if let fetchResultsStats = try context.executeFetchRequest(fetchRequestStats) as? [Stats] {
                for result in fetchResultsStats {
                    context.deleteObject(result)
                }
                try context.save()
            }
            
        } catch let error as NSError  {
            NSLog("Could not save \(error)")
        }
    }
    
    func displayEndGameAlert() {
        let titleAlert = "Error ! "
        let descriptionAlert = "Please add a minimum of two players."
        let buttonLabel = "OK"
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: titleAlert, message: descriptionAlert, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // TODO
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("PVC - prepareForSegue - segue = \(segue.identifier)")
        if segue.identifier == "gameSegue" {
            
        } else if segue.identifier == "cancelPlayersSegue" {
            
        }
    }
    
    
}
