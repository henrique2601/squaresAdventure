//
//  Square.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/13/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Square: Control {
    
    func loadPhysics() {
        //Physics Config
        self.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 32, height: 32))
        
        self.physicsBody!.angularDamping = 4
        self.physicsBody!.linearDamping = 2
        self.physicsBody!.friction = 2
        //self.physicsBody!.restitution
    }
}
