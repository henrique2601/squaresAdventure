//
//  Skin.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/7/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(Skin)

class Skin: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var playerData: PlayerData

}
