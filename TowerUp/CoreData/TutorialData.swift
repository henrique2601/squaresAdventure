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

    @NSManaged var tutorial0: NSNumber
    @NSManaged var playerData: PlayerData?

}
