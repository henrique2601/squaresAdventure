//
//  FloorData.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 27/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(FloorData)

class FloorData: NSManagedObject {

    @NSManaged var stars: NSNumber
    
    @NSManaged var deaths: NSNumber
    @NSManaged var bonus: NSNumber
    @NSManaged var time: NSNumber
    
    @NSManaged var tower: TowerData

}
