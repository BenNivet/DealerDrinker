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
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("\(__FUNCTION__) BEGIN")
        // Set HMI style
        self.updateHMI()
        
        NSLog("\(__FUNCTION__) END")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateHMI() {
        NSLog("\(__FUNCTION__) BEGIN")
        
        // Set buttons style
        self.startButton.layer.cornerRadius = 15
        self.startButton.layer.borderWidth = 1
        self.startButton.layer.borderColor = UIColor.blackColor().CGColor
        self.startButton.clipsToBounds = true;
        
        self.button2.layer.cornerRadius = 15
        self.button2.layer.borderWidth = 1
        self.button2.layer.borderColor = UIColor.blackColor().CGColor
        self.button2.clipsToBounds = true;
        
        self.settingsButton.layer.cornerRadius = 15
        self.settingsButton.layer.borderWidth = 1
        self.settingsButton.layer.borderColor = UIColor.blackColor().CGColor
        self.settingsButton.clipsToBounds = true
        
        NSLog("\(__FUNCTION__) END")

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segue
    }

}

