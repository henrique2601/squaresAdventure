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
    
    func loadPhysics(texture:SKTexture) {
        //Physics Config
        self.physicsBody = SKPhysicsBody(rectangleOfSize: texture.size())
        self.physicsBody!.angularDamping = 1
        self.physicsBody!.linearDamping = 1
    }
}