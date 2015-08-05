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
    static var touchesArray:NSMutableArray = NSMutableArray()
    
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
    
    var sketchPosition:CGPoint = CGPointZero
    
    static var locations:NSMutableArray = NSMutableArray()
    
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
        Control.locations.addObject(name)
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        let texture = SKTexture(imageNamed: textureName)
        let spriteNode = SKSpriteNode(texture: texture, color: nil, size: texture.size())
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        spriteNode.name = name
        self.addChild(spriteNode)
    }
    
    class func resetControls(scene: SKScene) {
        for name in Control.locations {
            ((scene.childNodeWithName("//" + (name as! String))) as! Control).resetPosition()
        }
        Button.resetButtons(scene)
        Switch.resetSwitches(scene)
        Label.resetLabels(scene)
    }
    
    func resetPosition() {
        self.position = CGPoint(x: Int(sketchPosition.x)/2 + Int(Config.translate.x * CGFloat(xAlign.rawValue)),
            y: -Int(sketchPosition.y)/2 - Int(Config.translate.y * CGFloat(yAlign.rawValue)))
    }
    
    class func touchesBegan(scene: SKNode, touches: Set<UITouch>) {
        for touch in touches {
            Control.touchesArray.addObject(touch)
        }
        Button.update(scene)
    }
    
    class func touchesMoved(scene: SKNode) {
        Button.update(scene)
    }
    
    class func touchesEnded(scene: SKNode, touches: Set<UITouch>) {
        for touch in touches {
            Control.touchesArray.removeObject(touch)
        }
        Button.update(scene)
        Switch.update(scene, touches: touches)
    }
}
