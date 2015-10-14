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
    
    init(textureName:String, icon:String = "", text:String = "", fontSize:GameFonts.fontSize = .medium, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up, colorBlendFactor:CGFloat = CGFloat(1), touchArea:CGSize = CGSize.zero,
        top:Int = 0, bottom:Int = 0, left:Int = 0, right:Int = 0) {
        super.init()
        self.load(textureName, icon:icon, text:text, fontSize:fontSize.rawValue, x:x, y:y, xAlign:xAlign, yAlign:yAlign, colorBlendFactor:colorBlendFactor, top:top, bottom:bottom, left:left, right:right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(textureName:String, icon:String, text:String, fontSize:CGFloat,  x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, colorBlendFactor:CGFloat, top:Int, bottom:Int, left:Int, right:Int) {
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: textureName)
        
        let spriteNode = SKSpriteNode(texture: nil, color: UIColor.clearColor(),
            size: CGSize(width: Int(texture.size().width) + left + right, height: Int(texture.size().height) + top + bottom))
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(spriteNode)
        spriteNode.position = CGPoint(x: -left, y: top)
        
        self.button = SKSpriteNode(texture: texture, size: texture.size())
        self.button.color = UIColor(red: 1, green: 1, blue: 1, alpha: colorBlendFactor)
        self.button.colorBlendFactor = 1
        self.button.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(self.button)
        
        if (icon != "") {
            let iconTexture = SKTexture(imageNamed: icon)
            
            let xScale = (self.button.size.width - 10) / iconTexture.size().width
            let yScale = (self.button.size.height - 10) / iconTexture.size().height
            let scale = min(xScale, yScale)
            
            let icon = SKSpriteNode(texture: iconTexture, size: CGSize(width: iconTexture.size().width * scale, height: iconTexture.size().height * scale))
            
            icon.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75 * colorBlendFactor)
            icon.colorBlendFactor = 1
            self.button.addChild(icon)
            icon.position = CGPoint(x: texture.size().width/2, y: -texture.size().height/2)
            icon.zPosition = self.button.zPosition + 1
        }
        
        if (text != "") {
            let labelNode = SKLabelNode(fontNamed: "Trebuchet MS")
            labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
            labelNode.fontSize = fontSize
            labelNode.fontColor = GameColors.black
            labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            labelNode.position = CGPoint(x: texture.size().width/2, y: -texture.size().height/2)
            self.button.addChild(labelNode)
            labelNode.zPosition = labelNode.zPosition + 1
        }
        
        let texturePressed = SKTexture(imageNamed: "\(textureName)Pressed")
        self.buttonPressed = SKSpriteNode(texture: texturePressed, size: texturePressed.size())
        self.buttonPressed.color = UIColor(red: 1, green: 1, blue: 1, alpha: colorBlendFactor)
        self.buttonPressed.colorBlendFactor = 1
        self.buttonPressed.anchorPoint = CGPoint(x: 0, y: 1)
        self.buttonPressed.hidden = true
        self.addChild(self.buttonPressed)
        
        if (icon != "") {
            let iconTexturePressed = SKTexture(imageNamed: icon)
            let xScale = (self.buttonPressed.size.width - 10) / iconTexturePressed.size().width
            let yScale = (self.buttonPressed.size.height - 10) / iconTexturePressed.size().height
            let scale = min(xScale, yScale)
            
            let iconPressed = SKSpriteNode(texture: iconTexturePressed, size: CGSize(width: iconTexturePressed.size().width * scale, height: iconTexturePressed.size().height * scale))
            
            iconPressed.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75 * colorBlendFactor)
            iconPressed.colorBlendFactor = 1
            self.buttonPressed.addChild(iconPressed)
            iconPressed.position = CGPoint(x: texturePressed.size().width/2, y: -texturePressed.size().height/2 - 2)
            iconPressed.zPosition = self.buttonPressed.zPosition + 1
        }
        
        if (text != "") {
            let labelNodePressed = SKLabelNode(fontNamed: "Trebuchet MS")
            labelNodePressed.text = NSLocalizedString(text, tableName: nil, comment:"")
            labelNodePressed.fontSize = fontSize
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
