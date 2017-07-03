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
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(PlayersViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "isGaming")
        
        textFieldPlayer.delegate = self
        
        labelPlayer.text = "Player \(nbPlayer + 1)"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        managedContext = appDelegate.managedObjectContext
        
        emptyPlayersTables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let isGaming : Int = defaults.integer(forKey: "isGaming") {
            if isGaming == 1 {
                performSegue(withIdentifier: "cancelPlayersSegue", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func addPlayer(_ sender: AnyObject) {
        updateData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        updateData()
        return true
    }
    
    func updateData() {
        if textFieldPlayer.text != "" {
            NSLog("PVC - Add player")
            
            let newPlayer: Players = NSEntityDescription.insertNewObject(forEntityName: "Players", into: managedContext) as! Players
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
    
    @IBAction func submitAction(_ sender: AnyObject) {
        NSLog("PVC - Submit player")

        if nbPlayer >= 2 {
            let newNbPlayer: Stats = NSEntityDescription.insertNewObject(forEntityName: "Stats", into: managedContext) as! Stats
            newNbPlayer.nbPlayers = nbPlayer
            
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }

            performSegue(withIdentifier: "gameSegue", sender: nil)
        } else {
            NSLog("Limit min players incorrect")
            // Alert
            self.displayEndGameAlert()
        }
    }
    
    func emptyPlayersTables() {
        let context = self.managedContext
        
        // Empty Players Table
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
        fetchRequest.includesPropertyValues = false
        
        // Get results
        
        do {
            if let fetchResults = try context.fetch(fetchRequest) as? [Players] {
                for result in fetchResults {
                    context.delete(result)
                }
                try context.save()
            }
            
        } catch let error as NSError  {
            NSLog("Could not save \(error)")
        }
        
        // Empty Stats Table
        let fetchRequestStats = NSFetchRequest<NSFetchRequestResult>(entityName: "Stats")
        fetchRequestStats.includesPropertyValues = false
        
        // Get results
        do {
            if let fetchResultsStats = try context.fetch(fetchRequestStats) as? [Stats] {
                for result in fetchResultsStats {
                    context.delete(result)
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
            let alertController = UIAlertController(title: titleAlert, message: descriptionAlert, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: buttonLabel, style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            // TODO
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("PVC - prepareForSegue - segue = \(String(describing: segue.identifier))")
        if segue.identifier == "gameSegue" {
            
        } else if segue.identifier == "cancelPlayersSegue" {
            
        }
    }
    
    
}
