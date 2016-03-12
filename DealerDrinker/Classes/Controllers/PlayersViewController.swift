//
//  PlayersViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var labelPlayer: UILabel!
    @IBOutlet weak var textFieldPlayer: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var submitPlayer: UIButton!
    
    var nbPlayer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldPlayer.delegate = self
        
        labelPlayer.text = "Player \(nbPlayer + 1)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            // TODO Add Player to DB
            
            nbPlayer += 1
            
            // Reset field
            labelPlayer.text = "Player \(nbPlayer + 1)"
            textFieldPlayer.text = ""        }
    }

    @IBAction func submitAction(sender: AnyObject) {
        NSLog("PVC - Submit player")
        // TODO Add nbPlayer to DB
        performSegueWithIdentifier("gameSegue", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
