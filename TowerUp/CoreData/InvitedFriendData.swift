//
//  InvitedFriend.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 01/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import Foundation
import CoreData

@objc(InvitedFriendData)

class InvitedFriendData: NSManagedObject {

    @NSManaged var id: String
    
    
    @NSManaged var playerData: PlayerData

}
