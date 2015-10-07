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
    
    var on:Bool = false
    
    init(textureName:String, on:Bool = true, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        self.load(textureName, on:on, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(textureName: String, on:Bool, x: Int, y: Int, xAlign: Control.xAlignments, yAlign:Control.yAlignments) {
        
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture0 = SKTexture(imageNamed: "\(textureName)0")
        self.switch0 = SKSpriteNode(texture: texture0, size: texture0.size())
        self.switch0.anchorPoint = CGPoint(x: 0, y: 1)
        self.switch0.hidden = on
        self.addChild(self.switch0)
        
        let texture1 = SKTexture(imageNamed: "\(textureName)1")
        self.switch1 = SKSpriteNode(texture: texture1, size: texture1.size())
        self.switch1.anchorPoint = CGPoint(x: 0, y: 1)
        self.switch1.hidden = !on
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
    
    private func switchPressed() {
        self.switch0.hidden = !self.switch0.hidden
        self.switch1.hidden = !self.switch1.hidden
        
        self.on = self.switch0.hidden
    }
    
    override func removeFromParent() {
        Switch.switchList.remove(self)
        super.removeFromParent()
    }
}
