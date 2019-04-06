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
    

    
    init(friends:Array<Control>) {
        super.init()
        
    
        for i in 0 ..< friends.count {
            let friend = friends[i]
            let x =  131 * i
            friend.sketchPosition = CGPoint(x: x, y: 0)
            friend.resetPosition()
            self.addChild(friend)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

