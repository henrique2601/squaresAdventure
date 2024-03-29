//
//  Parallax.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/17/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Parallax: SKNode {
    
    var nodeA:SKSpriteNode!
    var nodeB:SKSpriteNode!
    var nodeC:SKSpriteNode!
    
    init(imageNamed:String) {
        super.init()
        self.zPosition = -10000
        self.nodeA = SKSpriteNode(imageNamed: imageNamed)
        self.nodeA.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addChild(self.nodeA)
        
        self.nodeB = SKSpriteNode(imageNamed: imageNamed)
        self.nodeB.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addChild(self.nodeB)
        
        self.nodeC = SKSpriteNode(imageNamed: imageNamed)
        self.nodeC.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addChild(self.nodeC)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(position:CGPoint){
        
        //let test =
        let xa = CGFloat(Double(-position.x/4).truncatingRemainder(dividingBy: Double(self.nodeA.size.width)))
        let ya = (-position.y/8) + (-self.scene!.size.height + self.nodeA.size.height)
        
        self.nodeA.position = CGPoint(x: xa, y: ya)
        
        let xb = xa + self.nodeA.size.width
        self.nodeB.position = CGPoint(x: xb, y: ya)
        
        let xc = xa + self.nodeA.size.width * 2
        self.nodeC!.position = CGPoint(x: xc, y: ya)
    }
}

