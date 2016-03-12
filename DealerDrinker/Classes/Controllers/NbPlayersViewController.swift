//
//  NbPlayersViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

class NbPlayersViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var nbPlayers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelPressed")
        cancelButton.tintColor = UIColor.redColor()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.textField.inputAccessoryView = toolBar
        self.textField.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(0, forKey: "isGaming")
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let isGaming:Int = defaults.integerForKey("isGaming") {
            if isGaming == 1 {
                performSegueWithIdentifier("cancelNbPlayersSegue", sender: nil)
            }
        } else {
            defaults.setInteger(0, forKey: "isGaming")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed(){
        NSLog("NbPVC - donePressed")
        view.endEditing(true)
        nbPlayers =  Int(textField.text!)!
        performSegueWithIdentifier("fillPlayersSegue", sender: nil)
    }
    
    func cancelPressed(){
        NSLog("NbPVC - cancelPressed")
        view.endEditing(true)
        performSegueWithIdentifier("cancelNbPlayersSegue", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fillPlayersSegue") {
            let destinationNavigationController = segue.destinationViewController as? UINavigationController
            let playerController = destinationNavigationController!.topViewController as? PlayersTableViewController
            
            NSLog("NbPlayers = \(nbPlayers)")
            playerController!.nbPlayers = self.nbPlayers
        }
    }
    

}
