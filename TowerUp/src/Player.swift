//
//  Player.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/13/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Player: Square {
    
    init(x:Int, y:Int, loadPhysics:Bool) {
        super.init()
        self.loadNewPlayer("player", x: x, y: y, loadPhysics: loadPhysics)
    }
    
    func loadNewPlayer(name:String, x:Int, y:Int, loadPhysics:Bool) {
        self.name = name
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: "player")//TODO SKIN!!!
        let spriteNode = SKSpriteNode(texture: texture, color: nil, size: texture.size())
        spriteNode.name = name
        
        if(loadPhysics){
            self.position = CGPoint(x: x, y: y)
            self.loadPhysics(texture)
        } else {
            self.sketchPosition = CGPoint(x: x, y: y)
            self.yAlign = .center
            self.xAlign = .center
            Control.locations.addObject(name)
        }
        
        self.addChild(spriteNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentTime:NSTimeInterval) {
        if((self.childNodeWithName("//buttonJump") as! Button).pressed){
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            (self.childNodeWithName("//buttonJump") as! Button).pressed = false
            
        }
        if((self.parent?.childNodeWithName("//buttonLeft") as! Button).pressed){
            self.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))
        }
        if((self.parent?.childNodeWithName("//buttonRight") as! Button).pressed){
            self.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
        }
    }
}
