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
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NbPlayersViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(NbPlayersViewController.cancelPressed))
        cancelButton.tintColor = UIColor.red
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.textField.inputAccessoryView = toolBar
        self.textField.delegate = self
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "isGaming")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let isGaming:Int = defaults.integer(forKey: "isGaming") {
            if isGaming == 1 {
                performSegue(withIdentifier: "cancelNbPlayersSegue", sender: nil)
            }
        } else {
            defaults.set(0, forKey: "isGaming")
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
        performSegue(withIdentifier: "fillPlayersSegue", sender: nil)
    }
    
    func cancelPressed(){
        NSLog("NbPVC - cancelPressed")
        view.endEditing(true)
        performSegue(withIdentifier: "cancelNbPlayersSegue", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fillPlayersSegue") {
            let destinationNavigationController = segue.destination as? UINavigationController
            let playerController = destinationNavigationController!.topViewController as? PlayersTableViewController
            
            NSLog("NbPlayers = \(nbPlayers)")
            playerController!.nbPlayers = self.nbPlayers
        }
    }
    

}
