//
//  Label.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Label: Control {
    
    override init(name:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up)
    }
override     
    init(name:String, textureName:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    override init(name:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    override init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    override init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    override init(name:String, texture:SKTexture, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, texture: texture, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    override init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String, color:UIColor, x:Int, y:Int) {
        super.init()
        self.load(name, color:color, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    init(name:String, color:UIColor, textureName:String, x:Int, y:Int) {
        super.init()
        self.load(name, color:color, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    init(name:String, color:UIColor, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, color:color, textureName: name, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, color:UIColor, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, color:color, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String, color:UIColor, textureName:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, color:color, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, color:UIColor, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, color:color, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        let labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
        labelNode.text = textureName
        labelNode.fontSize = 25/2
        labelNode.fontColor = GameColors.white
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        labelNode.name = name
        self.addChild(labelNode)
        
        Control.controlList.insert(self)
    }
    
    func load(name:String, color:UIColor, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        let labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
        labelNode.text = textureName
        labelNode.fontSize = 25/2
        labelNode.fontColor = color
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        labelNode.name = name
        self.addChild(labelNode)
        
        Control.controlList.insert(self)
    }
    
    func getText()->NSString{
        let label = self.childNodeWithName(self.name!) as! SKLabelNode
        return label.text
    }
    
    func setText(text:String){
        let label = self.childNodeWithName(self.name!) as! SKLabelNode
        label.text = text
        label.zPosition = Config.HUDZPosition/2
    }
    
    func setText(text:String, color:UIColor){
        let label = self.childNodeWithName(self.name!) as! SKLabelNode
        label.fontColor = color
        label.text = text
        label.zPosition = Config.HUDZPosition/2
    }
}
