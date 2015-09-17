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
    
    var labelNode:SKLabelNode!
    
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
        
        self.labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
        self.labelNode.text = NSLocalizedString(textureName, tableName: nil, comment:"")
        self.labelNode.fontSize = 25/2
        self.labelNode.fontColor = GameColors.white
        self.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        labelNode.name = name
        self.addChild(self.labelNode)
        
        Control.controlList.insert(self)
    }
    
    func load(name:String, color:UIColor, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        self.labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
        self.labelNode.text = NSLocalizedString(textureName, tableName: nil, comment:"")
        self.labelNode.fontSize = 25/2
        self.labelNode.fontColor = color
        self.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        self.labelNode.name = name
        self.addChild(self.labelNode)
        
        Control.controlList.insert(self)
    }
    
    func getText()->NSString{
        return self.labelNode.text!
    }
    
    func setText(text:String){
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.zPosition = Config.HUDZPosition/2
    }
    
    func setText(text:String, color:UIColor) {
        self.labelNode.fontColor = color
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.zPosition = Config.HUDZPosition/2
    }
}
