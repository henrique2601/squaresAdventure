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
    
    var bodyA: SKPhysicsBody!
    var bodyB: SKPhysicsBody!
    
    init(physicsWorld:SKPhysicsWorld) {
        super.init()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            self.bodyA = contact.bodyA
            self.bodyB = contact.bodyB
        } else {
            self.bodyA = contact.bodyB
            self.bodyB = contact.bodyA
        }
        
        switch(self.bodyA.categoryBitMask) {
        case physicsCategory.player.rawValue:
            (self.bodyA.node as! Player).didBeginContact(self.bodyB)
            break
        default:
            print("didBeginContact de \(self.bodyA.node?.name) não está sendo processado")
            break
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            self.bodyA = contact.bodyA
            self.bodyB = contact.bodyB
        } else {
            self.bodyA = contact.bodyB
            self.bodyB = contact.bodyA
        }
        
        switch(self.bodyA.categoryBitMask) {
        case physicsCategory.player.rawValue:
            (self.bodyA.node as! Player).didEndContact(self.bodyB)
            break
        default:
            print("didEndContact de \(self.bodyA.node?.name) não está sendo processado")
            break
        }
    }
}

struct physicsCategory : OptionSetType {
    typealias RawValue = UInt32
    private var value: UInt32 = 0
    init(_ value: UInt32) { self.value = value }
    init(rawValue value: UInt32) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: physicsCategory { return self.init(0) }
    static func fromMask(raw: UInt32) -> physicsCategory { return self.init(raw) }
    var rawValue: UInt32 { return self.value }
    
    static var none: physicsCategory { return self.init(0) }
    static var player: physicsCategory { return physicsCategory(1 << 0) }
    static var enemy: physicsCategory { return physicsCategory(1 << 1) }
    static var bullet: physicsCategory { return physicsCategory(1 << 2) }
    static var ground: physicsCategory { return physicsCategory(1 << 3) }
    static var winTile: physicsCategory { return physicsCategory(1 << 4) }
    static var coin: physicsCategory { return physicsCategory(1 << 5) }
    static var spike: physicsCategory { return physicsCategory(1 << 6) }
    static var doorTile: physicsCategory { return physicsCategory(1 << 7) }
}