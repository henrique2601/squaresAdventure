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
    
    //TODO criar a possibilidade de inserir labels dentro de botões
    
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
