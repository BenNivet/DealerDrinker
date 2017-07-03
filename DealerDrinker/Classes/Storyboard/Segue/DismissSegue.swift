//
//  DismissSegue.swift
//  DealerDrinker
//
//  Created by Benjamin CANTE on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import UIKit

// Principal Segue to use when returning to an already displayed view : actions like Back, Cancel, ...
@objc(DismissSegue) class DismissSegue: UIStoryboardSegue {
   
    override func perform() {
        NSLog("\(#function) BEGIN")
        
        if let controller = source as? UIViewController {
            NSLog("SEG - perform : (DismissSegue) Trying to display destination by dismissing sending controller")
            controller.dismiss(animated: true, completion: nil)
        }
        
        NSLog("\(#function) END")
    }
    
    
}
