//
//  PowerUpSlot.swift
//  TowerUp
//
//  Created by Pablo Henrique on 15/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(PowerUpSlotData)

class PowerUpSlotData: NSManagedObject {

    @NSManaged var playerData: PlayerData
    @NSManaged var powerUp: PowerUpData?

}
