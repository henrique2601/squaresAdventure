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
    
    override func load(name: String, textureName: String, x: Int, y: Int, xAlign: Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.position = CGPoint(x: x/2 + Int(Config.translate.x), y: -y/2 - Int(Config.translate.y))
        self.zPosition = Config.HUDZPosition
        
        let texture0 = SKTexture(imageNamed: "\(textureName)0")
        let switch0 = SKSpriteNode(texture: texture0, color: nil, size: texture0.size())
        switch0.anchorPoint = CGPoint(x: 0, y: 1)
        switch0.name = "\(name)0"
        self.addChild(switch0)
        
        let texture1 = SKTexture(imageNamed: "\(textureName)1")
        let switch1 = SKSpriteNode(texture: texture1, color: nil, size: texture1.size())
        switch1.anchorPoint = CGPoint(x: 0, y: 1)
        switch1.name = "\(name)1"
        switch1.hidden = true
        self.addChild(switch1)
        
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
                let location = touch.locationInNode(switchNode.parent)
                if switchNode.containsPoint(location) {
                    switchNode.switchPressed()
                }
            }
        }
    }
    
    func switchPressed() {
        var switch0:SKNode = self.childNodeWithName("\(self.name!)0")!
        switch0.hidden = !switch0.hidden
        var switch1:SKNode = self.childNodeWithName("\(self.name!)1")!
        switch1.hidden = !switch1.hidden
    }
    
    override func removeFromParent() {
        Switch.switchList.remove(self)
        super.removeFromParent()
    }
}
