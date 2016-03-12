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
        NSLog("\(__FUNCTION__) BEGIN")
        
        if let controller = sourceViewController as? UIViewController {
            NSLog("SEG - perform : (DismissSegue) Trying to display destination by dismissing sending controller")
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
        NSLog("\(__FUNCTION__) END")
    }
    
    
}
