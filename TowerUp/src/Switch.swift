//
//  Switch.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Switch: Control {
    
    static var switchList = Set<Switch>()
    
    var switch0:SKSpriteNode!
    var switch1:SKSpriteNode!
    
    func load(textureName: String, x: Int, y: Int, xAlign: Control.xAlignments, yAlign:Control.yAlignments) {
        self.position = CGPoint(x: x/2 + Int(Config.translate.x), y: -y/2 - Int(Config.translate.y))
        self.zPosition = Config.HUDZPosition
        
        let texture0 = SKTexture(imageNamed: "\(textureName)0")
        self.switch0 = SKSpriteNode(texture: texture0, size: texture0.size())
        self.switch0.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(self.switch0)
        
        let texture1 = SKTexture(imageNamed: "\(textureName)1")
        self.switch1 = SKSpriteNode(texture: texture1, size: texture1.size())
        self.switch1.anchorPoint = CGPoint(x: 0, y: 1)
        self.switch1.hidden = true
        self.addChild(self.switch1)
        
        Switch.switchList.insert(self)
    }
    
    class func resetSwitches() {
        for switchNode in Switch.switchList {
            switchNode.resetPosition()
        }
    }
    
    class func update(touches: Set<UITouch>) {
        for switchNode in Switch.switchList {
            for touch in touches {
                if let parent = switchNode.parent {
                    let location = touch.locationInNode(parent)
                    if switchNode.containsPoint(location) {
                        switchNode.switchPressed()
                    }
                }
            }
        }
    }
    
    func switchPressed() {
        self.switch0.hidden = self.switch0.hidden
        self.switch1.hidden = self.switch1.hidden
    }
    
    override func removeFromParent() {
        Switch.switchList.remove(self)
        super.removeFromParent()
    }
}
