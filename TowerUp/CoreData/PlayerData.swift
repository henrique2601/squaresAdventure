//
//  PlayerData.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(PlayerData)

class PlayerData: NSManagedObject {

    @NSManaged var powerUps: NSSet
    @NSManaged var towers: NSSet

}
