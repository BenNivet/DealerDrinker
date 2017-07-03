//
//  HomeViewController.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 08/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
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
        
        self.button2.layer.cornerRadius = 15
        self.button2.layer.borderWidth = 1
        self.button2.layer.borderColor = UIColor.black.cgColor
        self.button2.clipsToBounds = true;
        
        self.settingsButton.layer.cornerRadius = 15
        self.settingsButton.layer.borderWidth = 1
        self.settingsButton.layer.borderColor = UIColor.black.cgColor
        self.settingsButton.clipsToBounds = true
        
        NSLog("\(#function) END")

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue
    }

}

