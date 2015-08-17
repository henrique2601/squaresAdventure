//
//  SkinData.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/17/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(SkinData)

class SkinData: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var playerData: PlayerData

}
