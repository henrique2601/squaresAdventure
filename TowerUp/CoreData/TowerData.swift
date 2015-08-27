//
//  TowerData.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 27/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(TowerData)

class TowerData: NSManagedObject {

    @NSManaged var floors: NSSet
    @NSManaged var playerData: PlayerData

}
