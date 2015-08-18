//
//  World.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class World: SKNode {
    
    init(physicsWorld:SKPhysicsWorld) {
        super.init()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        switch(contact.bodyA.categoryBitMask) {
        case physicsCategory.player.rawValue:
            (contact.bodyA.node as! Player).didBeginContact(contact.bodyB)
            break
        default:
            println("didBeginContact de \(contact.bodyA.node!.name!) não está sendo processado")
            break
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        switch(contact.bodyA.categoryBitMask) {
        case physicsCategory.player.rawValue:
            (contact.bodyA.node as! Player).didEndContact(contact.bodyB)
            break
        default:
            println("didEndContact de \(contact.bodyA.node!.name!) não está sendo processado")
            break
        }
    }
}

public enum physicsCategory : UInt32 {
    case none   = 0
    case player = 1
    case enemy  = 2
    case bullet = 4
    case ground = 8
    case all    = 4294967295
}