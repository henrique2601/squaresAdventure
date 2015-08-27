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

extension PlayerData{
    //Adiciona HardPointData no NSSet hardPoints
    func addPowerUp(value: PowerUpData) {
        var items = self.mutableSetValueForKey("powerUps");
        items.addObject(value)
    }
    
    func addSkin(value: SkinData) {
        var items = self.mutableSetValueForKey("skins");
        items.addObject(value)
    }
    
}