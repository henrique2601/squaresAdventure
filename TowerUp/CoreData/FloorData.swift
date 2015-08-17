//
//  FloorData.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/17/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(FloorData)

class FloorData: NSManagedObject {

    @NSManaged var progress: NSNumber
    @NSManaged var tower: TowerData

}
