//
//  TowerData.swift
//  TowerUp
//
//  Created by Pablo Henrique on 03/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(TowerData)

class TowerData: NSManagedObject {

    @NSManaged var floors: NSSet
    @NSManaged var playerData: PlayerData

}

extension TowerData {
    func addFloor(value: FloorData) {
        let items = self.mutableSetValueForKey("floors");
        items.addObject(value)
    }
}
