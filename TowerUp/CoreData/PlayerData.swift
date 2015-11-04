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
    @NSManaged var gems: NSNumber
    @NSManaged var configControls: NSNumber
    @NSManaged var lastPlayedTower: NSNumber
    @NSManaged var musicEnabled: NSNumber
    @NSManaged var name: String
    @NSManaged var powerUpSlots: NSOrderedSet
    @NSManaged var skinSlot: SkinSlotData
    @NSManaged var powerUps: NSSet
    @NSManaged var skins: NSOrderedSet
    @NSManaged var towers: NSOrderedSet
    @NSManaged var invitedFriends: NSSet
    @NSManaged var soundEnabled: NSNumber
}

extension PlayerData{
    //Adiciona HardPointData no NSSet hardPoints
    func addPowerUp(value: PowerUpData) {
        let items = self.mutableSetValueForKey("powerUps");
        items.addObject(value)
    }
    
    func addSkin(value: SkinData) {
        let items = self.mutableOrderedSetValueForKey("skins");
        items.addObject(value)
    }
    
    func addTower(value: TowerData) {
        let items = self.mutableOrderedSetValueForKey("towers");
        items.addObject(value)
    }
    
    func addInvitedFriend(value: InvitedFriendData) {
        let items = self.mutableSetValueForKey("invitedFriends");
        items.addObject(value)
    }
}


