//
//  Players.swift
//  DealerDrinker
//
//  Created by alexandre vey on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import Foundation
import CoreData

class Players: NSManagedObject {
    @NSManaged var name : String
    @NSManaged var nbCardsFound : Int
    @NSManaged var nbDealer : Int
    @NSManaged var nbGiven : Int
    @NSManaged var nbReceived : Int
}