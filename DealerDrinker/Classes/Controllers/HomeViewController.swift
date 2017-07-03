//
//  HomeViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 08/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set HMI style
        self.updateHMI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateHMI() {
        NSLog("\(#function) BEGIN")
        
        // Set buttons style
        self.startButton.layer.cornerRadius = 15
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.black.cgColor
        self.startButton.clipsToBounds = true;
        
        NSLog("\(#function) END")        
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        performSegue(withIdentifier: goToGameSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segues
        if segue.identifier == goToGameSegue {
            if segue.destination is GameViewController{
                // ???
            }
        }
    }

}

