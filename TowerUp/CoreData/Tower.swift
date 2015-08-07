//
//  Tower.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(Tower)

class Tower: NSManagedObject {

    @NSManaged var floors: Floor

}
