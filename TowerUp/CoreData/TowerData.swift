//
//  TowerData.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/17/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(TowerData)

class TowerData: NSManagedObject {

    @NSManaged var floors: NSSet
    @NSManaged var playerData: PlayerData

}
