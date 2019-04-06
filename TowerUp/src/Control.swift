//
//  Control.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Control: SKNode {
    
    static var gameScene:GameScene!
    
    static var touchesArray = Set<UITouch>()
    
    static var controlList = Set<Control>()
    
    enum xAlignments: Int {
        case left = 0
        case center = 1
        case right = 2
    }
    
    enum yAlignments: Int {
        case up = 0
        case center = 1
        case down = 2
    }
    
    var yAlign = yAlignments.up
    var xAlign = xAlignments.left {
        didSet {
            self.resetPosition()
        }
    }
    
    var size:CGSize!
    
    var sketchPosition:CGPoint = CGPoint.zero
    
    static var dx:CGFloat = 0
    static var dy:CGFloat = 0
    
    override init() {
        super.init()
    }
    
    init(name:String = "", textureName:String, size:CGSize = CGSize.zero, x:Int = 0, y:Int = 0, z:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        let spriteNode = SKSpriteNode(imageNamed: textureName)
        self.load(name: name, spriteNode: spriteNode, size:size, x: x, y: y, z:z, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String = "", spriteNode:SKSpriteNode, size:CGSize = CGSize.zero, x:Int = 0, y:Int = 0, z:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        self.load(name: name, spriteNode: spriteNode, size:size, x: x, y: y, z:z, xAlign: xAlign, yAlign: yAlign)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(name:String, spriteNode:SKSpriteNode, size:CGSize, x:Int, y:Int, z:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        
        self.resetPosition()
        
        self.zPosition = (z == 0 ? Config.HUDZPosition/2 : CGFloat(z))
        
        if !(size == CGSize.zero) {
            spriteNode.size = size
        }
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        spriteNode.name = name
        self.addChild(spriteNode)
        
        Control.controlList.insert(self)
    }
    
    class func resetControls() {
        for control in Control.controlList {
            control.resetPosition()
        }
        Button.resetButtons()
        Switch.resetSwitches()
        ScrollNode.resetScrollNodes()
        Textfield.resetTextfields()
    }
    
    func resetPosition() {
        //TODO: QUEBROU AQUI = BAD ACCESS
        self.position = CGPoint(x: Int(sketchPosition.x)/2 + Int(Config.translate.x * CGFloat(xAlign.rawValue)),
            y: -Int(sketchPosition.y)/2 - Int(Config.translate.y * CGFloat(yAlign.rawValue)))
    }
    
    class func touchesBegan(touches: Set<UITouch>) {
        for touch in touches {
            Control.touchesArray.insert(touch)
        }
        Button.update()
        PowerUp.update()
    }
    
    class func touchesMoved() {
        
        for touch in Control.touchesArray {
            let location = touch.location(in: Control.gameScene)
            let previousLocation = touch.previousLocation(in: Control.gameScene)
            
            Control.dx += location.x - previousLocation.x
            Control.dy += location.y - previousLocation.y
        }
        
        Button.update()
        PowerUp.update()
        ScrollNode.updateOnTouchesMoved()
    }
    
    class func touchesEnded(touches: Set<UITouch>) {
        ScrollNode.updateOnTouchesEnded()
        for touch in touches {
            Control.touchesArray.remove(touch)
        }
        Button.update(touches: touches)
        PowerUp.update()
        Switch.update(touches: touches)
    }
    
    override func removeFromParent() {
        Control.controlList.remove(self)
        super.removeFromParent()
    }
}
