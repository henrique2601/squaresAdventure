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
    
    var sketchPosition:CGPoint = CGPointZero
    
    override init() {
        super.init()
        //Este inicializador deve ser sobreescrito nas subclasses
    }
    
    init(name:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    init(name:String, textureName:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, texture:SKTexture, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, texture: texture, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Esta função deve ser sobreescrita nas subclasses
    func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        let texture = SKTexture(imageNamed: textureName)
        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        spriteNode.name = name
        self.addChild(spriteNode)
        
        Control.controlList.insert(self)
    }
    
    func load(name:String, texture:SKTexture, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        spriteNode.name = name
        self.addChild(spriteNode)
        
        Control.controlList.insert(self)
    }
    //
    
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
        Button.update()
        PowerUp.update()
        ScrollNode.update()
    }
    
    class func touchesEnded(touches: Set<UITouch>) {
        for touch in touches {
            Control.touchesArray.remove(touch)
        }
        Button.update(touches)
        PowerUp.update(touches)
        Switch.update(touches)
    }
    
    override func removeFromParent() {
        Control.controlList.remove(self)
        super.removeFromParent()
    }
}
