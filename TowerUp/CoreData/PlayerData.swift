//
//  PlayerData.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 27/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(PlayerData)

class PlayerData: NSManagedObject {

    @NSManaged var powerUps: NSSet
    @NSManaged var skins: NSSet
    @NSManaged var towers: NSSet

}
