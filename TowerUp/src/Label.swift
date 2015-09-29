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
    
    init(color:UIColor = GameColors.black, text:String, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        self.load(color, text:text, x:x, y:y, xAlign:xAlign, yAlign:yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(color:UIColor, text:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        self.labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.fontSize = 25/2
        self.labelNode.fontColor = color
        self.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        self.addChild(self.labelNode)
        
        Control.controlList.insert(self)
    }
    
    func getText() -> NSString{
        return self.labelNode.text!
    }
    
    func setText(text:String) {
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.zPosition = Config.HUDZPosition/2
    }
    
    func setText(text:String, color:UIColor) {
        self.labelNode.fontColor = color
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.zPosition = Config.HUDZPosition/2
    }
}
