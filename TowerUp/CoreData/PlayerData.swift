//
//  PlayerData.swift
//  TowerUp
//
//  Created by Pablo Henrique on 15/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(PlayerData)

class PlayerData: NSManagedObject {
    
    @NSManaged var coins: NSNumber
    @NSManaged var configControls: NSNumber
    @NSManaged var name: String
    @NSManaged var powerUpSlots: NSOrderedSet
    @NSManaged var skinSlot: SkinSlotData
    @NSManaged var powerUps: NSSet
    @NSManaged var skins: NSSet
    @NSManaged var towers: NSOrderedSet
}

extension PlayerData{
    //Adiciona HardPointData no NSSet hardPoints
    func addPowerUp(value: PowerUpData) {
        let items = self.mutableSetValueForKey("powerUps");
        items.addObject(value)
    }
    
    func addSkin(value: SkinData) {
        let items = self.mutableSetValueForKey("skins");
        items.addObject(value)
    }
    
    func addTower(value: TowerData) {
        let items = self.mutableOrderedSetValueForKey("towers");
        items.addObject(value)
    }
}


