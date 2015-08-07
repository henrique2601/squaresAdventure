//
//  Floor.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(Floor)

class Floor: NSManagedObject {

    @NSManaged var progress: NSNumber
    @NSManaged var tower: Tower

}
