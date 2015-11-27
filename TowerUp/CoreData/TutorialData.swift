//
//  TutorialData.swift
//  Squares Adventure
//
//  Created by Gabriel Prado Marcolino on 26/11/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(TutorialData)

class TutorialData: NSManagedObject {
    
    @NSManaged var tutorial0: NSNumber?
    @NSManaged var tutorial1: NSNumber?
    @NSManaged var tutorial2: NSNumber?
    @NSManaged var tutorial3: NSNumber?
    @NSManaged var tutorial4: NSNumber?
    @NSManaged var tutorial5: NSNumber?
    @NSManaged var tutorial6: NSNumber?
    @NSManaged var playerData: PlayerData?
    
}
