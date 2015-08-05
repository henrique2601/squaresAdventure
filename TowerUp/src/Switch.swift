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
    
    override func load(name: String, textureName: String, x: Int, y: Int, xAlign: Control.xAlignments, yAlign:Control.yAlignments) {
        
        if(!name.hasPrefix("switch")) {
            fatalError("Error loading Switch: \(name). Did you mean switch\(name)?")
        }
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
    }
    
    class func resetSwitches(scene: SKScene) {
        scene.enumerateChildNodesWithName("switch*", usingBlock: { (node:SKNode!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            (node as! Switch).resetPosition()
        })
    }
    
    class func update(scene: SKNode, touches: Set<UITouch>) {
        scene.enumerateChildNodesWithName("switch*", usingBlock: { (node:SKNode!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            for touch in touches {
                let location = touch.locationInNode(node.parent)
                if node.containsPoint(location) {
                    (node as! Switch).switchPressed()
                }
            }
        })
    }
    
    func switchPressed() {
        var switch0:SKNode = self.childNodeWithName("\(self.name!)0")!
        switch0.hidden = !switch0.hidden
        var switch1:SKNode = self.childNodeWithName("\(self.name!)1")!
        switch1.hidden = !switch1.hidden
    }
}
