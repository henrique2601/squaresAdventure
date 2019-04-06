//
//  MessageBox.swift
//  TowerUp
//
//  Created by Pablo Henrique on 14/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MessageBox: Control {
    
    var touchesEndedAtButtonCancel:Event<Void> = Event()
    var touchesEndedAtButtonOK:Event<Void> = Event()
    
    var buttonCancel:Button!
    var buttonOK:Button!
    
    enum messageType {
        case OKCancel
        case OK
    }
    
    static var messageBoxCount = 0
    
    init(text:String, textureName:String, type:MessageBox.messageType) {
        
        let texture = SKTexture(imageNamed: "messegeBox")
        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: texture.size())
        
        let position = CGPoint(x: 1334/2 - texture.size().width,
            y: 750/2  - texture.size().height)
        super.init(spriteNode: spriteNode, x: Int(position.x), y: Int(position.y), xAlign:.center, yAlign:.center)
        
        MessageBox.messageBoxCount += 1
        self.zPosition = Config.HUDZPosition * CGFloat(3 + MessageBox.messageBoxCount)
        
        self.addChild(Label(text:text, x:255, y:46))
        
        switch (type) {
        case messageType.OK:
            self.buttonOK = Button(textureName: "buttonSandSmall", text: "Ok", x:139, y:162)
            self.addChild(self.buttonOK)
            break
        case messageType.OKCancel:
            self.buttonOK = Button(textureName: "buttonSandSmall", text: "Ok", x:262, y:162)
            self.addChild(self.buttonOK)
            self.buttonCancel = Button(textureName: "buttonRedSmall", text: "Cancel", x:14, y:162)
            self.addChild(self.buttonCancel)
            break
        }
        
        self.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Button.touchesEnded(touches: touches )
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if let _ = self.buttonCancel {
                if (self.buttonCancel.contains(location) == true) {
                    self.isHidden = true
                    self.touchesEndedAtButtonCancel.raise(data: Void)
                    self.removeFromParent()
                    return
                }
            }
            
            if let _ = self.buttonOK {
                if (self.buttonOK.contains(location) == true) {
                    self.isHidden = true
                     self.touchesEndedAtButtonOK.raise(data: Void)
                    self.removeFromParent()
                    return
                }
            }
        }
    }
    
    override var isHidden: Bool {
        didSet {
            self.isUserInteractionEnabled = !isHidden
        }
    }
}
