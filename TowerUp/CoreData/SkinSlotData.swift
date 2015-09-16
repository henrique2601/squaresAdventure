//
//  SkinSlot.swift
//  TowerUp
//
//  Created by Pablo Henrique on 15/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(SkinSlotData)

class SkinSlotData: NSManagedObject {

    @NSManaged var playerData: PlayerData
    @NSManaged var skin: SkinData

}
