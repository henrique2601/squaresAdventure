//
//  PowerUp.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/7/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(PowerUp)

class PowerUp: NSManagedObject {

    @NSManaged var available: NSNumber
    @NSManaged var locked: NSNumber
    @NSManaged var playerData: PlayerData

}
