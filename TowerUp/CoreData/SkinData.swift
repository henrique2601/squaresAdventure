//
//  SkinData.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 27/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(SkinData)

class SkinData: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var available: NSNumber
    @NSManaged var locked: NSNumber
    @NSManaged var playerData: PlayerData

}
