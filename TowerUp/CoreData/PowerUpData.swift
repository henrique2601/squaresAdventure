//
//  PowerUpData.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/17/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(PowerUpData)

class PowerUpData: NSManagedObject {

    @NSManaged var available: NSNumber
    @NSManaged var locked: NSNumber
    @NSManaged var playerData: PlayerData

}
