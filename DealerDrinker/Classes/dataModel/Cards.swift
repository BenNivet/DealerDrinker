//
//  Cards.swift
//  DealerDrinker
//
//  Created by alexandre vey on 12/03/2016.
//  Copyright © 2016 com.Nivet. All rights reserved.
//

import Foundation
import CoreData


@objc(Cards)
class Cards: NSManagedObject {
    @NSManaged var color : String
    @NSManaged var value: String
    @NSManaged var inDeck : Bool
}