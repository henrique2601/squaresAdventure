//
//  friendCell.swift
//  Squares Adventure
//
//  Created by Paulo Henrique dos Santos on 19/11/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//


import UIKit
import SpriteKit

class FriendCell: SKNode {
    

    
    init(friends:Array<SKSpriteNode>) {
        super.init()
        
    
        for (var i=0; i < friends.count; i++){
            let friend = friends[i]
            let x = 41 + 131  * i
            friend.position = CGPoint(x: x/2, y: -41/2)
            self.addChild(friend)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

