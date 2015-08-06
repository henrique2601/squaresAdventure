//
//  Button.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Button: Control {
    var pressed:Bool = false
    
    override init(name:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    override init(name:String, textureName:String, x:Int, y:Int) {
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
    
    override init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String, text:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: name, text:text, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    init(name:String, textureName:String, text:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: textureName, text:text, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    init(name:String, text:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: name, text:text, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, text:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: name, text:text, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String, textureName:String, text:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: textureName, text:text, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    init(name:String, textureName:String, text:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: textureName, text:text, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        if(!name.hasPrefix("button")) {
            fatalError("Error loading Button: \(name). Did you mean button\(name)?")
        }
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: textureName)
        let button = SKSpriteNode(texture: texture, color: nil, size: texture.size())
        button.anchorPoint = CGPoint(x: 0, y: 1)
        button.name = name
        self.addChild(button)
        
        let texturePressed = SKTexture(imageNamed: "\(textureName)Pressed")
        let buttonPressed = SKSpriteNode(texture: texturePressed, color: nil, size: texturePressed.size())
        buttonPressed.name = "\(name)Pressed"
        buttonPressed.anchorPoint = CGPoint(x: 0, y: 1)
        buttonPressed.hidden = true
        self.addChild(buttonPressed)
    }
    
    class func resetButtons(scene: SKScene) {
        NSArray(array: scene.children).enumerateObjectsUsingBlock({ object, index, stop in
            var node = object as! SKNode
            if let name = node.name
            {
                if(name.hasPrefix("button")) {
                    (node as! Button).resetPosition()
                }
            }
        })
    }
    
    func load(name:String, textureName:String, text:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        if(!name.hasPrefix("button")) {
            fatalError("Error loading Button: \(name). Did you mean button\(name)?")
        }
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: textureName)
        let button = SKSpriteNode(texture: texture, color: nil, size: texture.size())
        button.anchorPoint = CGPoint(x: 0, y: 1)
        button.name = name
        self.addChild(button)
        
        let labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
        labelNode.text = text
        labelNode.fontSize = 32/2
        labelNode.fontColor = GameColors.black
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        labelNode.position = CGPoint(x: texture.size().width/2, y: -texture.size().height/2)
        button.addChild(labelNode)
        labelNode.zPosition = labelNode.zPosition + 1
        
        let texturePressed = SKTexture(imageNamed: "\(textureName)Pressed")
        let buttonPressed = SKSpriteNode(texture: texturePressed, color: nil, size: texturePressed.size())
        buttonPressed.name = "\(name)Pressed"
        buttonPressed.anchorPoint = CGPoint(x: 0, y: 1)
        buttonPressed.hidden = true
        self.addChild(buttonPressed)
        
        let labelNodePressed = SKLabelNode(fontNamed: "Trebuchet MS")
        labelNodePressed.text = text
        labelNodePressed.fontSize = 32/2
        labelNodePressed.fontColor = GameColors.white
        labelNodePressed.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        labelNodePressed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        //TODO: deslocamento vindo por parâmetro
        labelNodePressed.position = CGPoint(x: texturePressed.size().width/2, y: -texturePressed.size().height/2 - 2)
        buttonPressed.addChild(labelNodePressed)
        labelNodePressed.zPosition = labelNodePressed.zPosition + 1
    }
    
    class func update(scene: SKNode) {
        NSArray(array: scene.children).enumerateObjectsUsingBlock({ object, index, stop in
            var node = object as! SKNode
            
            if let name = node.name
            {
                if(name.hasPrefix("button")) {
                    
                    var i = 0
                    for touch in Control.touchesArray {
                        let location = touch.locationInNode(node.parent)
                        if node.containsPoint(location) {
                            i++
                        }
                    }
                    if(i > 0){
                        (node as! Button).buttonPressed()
                    } else {
                        (node as! Button).buttonReleased()
                    }
                }
                
            }
        })
    }
    
    private func buttonPressed() {
        self.pressed = true
        self.childNodeWithName(self.name!)!.hidden = true
        self.childNodeWithName("\(self.name!)Pressed")!.hidden = false
    }
    
    private func buttonReleased() {
        self.pressed = false
        self.childNodeWithName(self.name!)!.hidden = false
        self.childNodeWithName("\(self.name!)Pressed")!.hidden = true
    }
}
