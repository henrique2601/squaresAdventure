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
    
    static var buttonList = Set<Button>()
    
    var button:SKSpriteNode!
    var buttonPressed:SKSpriteNode!
    
    var pressed:Bool = false
    
    var event:Event<Void>?// = Event()
    
    func addHandler(handler: Void -> ()) {
        if let _ = self.event {
            
        } else {
            self.event = Event()
        }
        self.event!.addHandler(handler)
    }
    
    override init() {
        super.init()
    }
    
    init(textureName:String, text:String = "", x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        self.load(textureName, text:text, x:x, y:y, xAlign:xAlign, yAlign:yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(textureName:String, text:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: textureName)
        self.button = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.button.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(self.button)
        
        if (text != "") {
            let labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
            labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
            labelNode.fontSize = 32/2
            labelNode.fontColor = GameColors.black
            labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            labelNode.position = CGPoint(x: texture.size().width/2, y: -texture.size().height/2)
            self.button.addChild(labelNode)
            labelNode.zPosition = labelNode.zPosition + 1
        }
        
        let texturePressed = SKTexture(imageNamed: "\(textureName)Pressed")
        self.buttonPressed = SKSpriteNode(texture: texturePressed, color: UIColor.whiteColor(), size: texturePressed.size())
        self.buttonPressed.anchorPoint = CGPoint(x: 0, y: 1)
        self.buttonPressed.hidden = true
        self.addChild(self.buttonPressed)
        
        if (text != "") {
            let labelNodePressed = SKLabelNode(fontNamed: "Trebuchet MS")
            labelNodePressed.text = NSLocalizedString(text, tableName: nil, comment:"")
            labelNodePressed.fontSize = 32/2
            labelNodePressed.fontColor = GameColors.white
            labelNodePressed.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            labelNodePressed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            //TODO: deslocamento vindo por parâmetro
            labelNodePressed.position = CGPoint(x: texturePressed.size().width/2, y: -texturePressed.size().height/2 - 2)
            self.buttonPressed.addChild(labelNodePressed)
            labelNodePressed.zPosition = labelNodePressed.zPosition + 1
        }
        
        Button.buttonList.insert(self)
    }
    
    class func resetButtons() {
        for button in Button.buttonList {
            button.resetPosition()
        }
    }
    
    class func update(touches: Set<UITouch>) {
        for button in Button.buttonList {
            
            if let event = button.event {
                for touch in touches {
                    if let parent = button.parent {
                        let location = touch.locationInNode(parent)
                        if button.containsPoint(location) {
                            event.raise()
                        }
                    }
                }
            }
            button.update()
        }
    }
    
    class func update() {
        for button in Button.buttonList {
            button.update()
        }
    }
    
    func update(){
        var i = 0
        for touch in Control.touchesArray {
            if let parent = self.parent {
                let location = touch.locationInNode(parent)
                if self.containsPoint(location) {
                    i++
                }
            }
        }
        if(i > 0){
            self.buttonPresse()
        } else {
            self.buttonRelease()
        }
    }
    
    func buttonPresse() {
        self.pressed = true
        self.button.hidden = true
        self.buttonPressed.hidden = false
    }
    
    func buttonRelease() {
        self.pressed = false
        self.button.hidden = false
        self.buttonPressed.hidden = true
    }
    
    override func removeFromParent() {
        Button.buttonList.remove(self)
        super.removeFromParent()
    }
}
