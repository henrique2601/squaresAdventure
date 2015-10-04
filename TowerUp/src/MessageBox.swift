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
        let position = CGPoint(x: 1334/2 - texture.size().width,
            y: 750/2  - texture.size().height)
        super.init(texture: texture, x: Int(position.x), y: Int(position.y), xAlign:.center, yAlign:.center)
        
        MessageBox.messageBoxCount++
        self.zPosition = Config.HUDZPosition * CGFloat(3 + MessageBox.messageBoxCount)
        
        self.addChild(Label(text:text, x:255, y:46))
        
        switch (type) {
        case messageType.OK:
            self.buttonOK = Button(textureName: "buttonBlueSmall", text: "Ok", x:139, y:162)
            self.addChild(self.buttonOK)
            break
        case messageType.OKCancel:
            self.buttonOK = Button(textureName: "buttonBlueSmall", text: "Ok", x:262, y:162)
            self.addChild(self.buttonOK)
            self.buttonCancel = Button(textureName: "buttonRedSmall", text: "Cancel", x:14, y:162)
            self.addChild(self.buttonCancel)
            break
        }
        
        self.hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Button.touchesEnded(touches )
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if let _ = self.buttonCancel {
                if (self.buttonCancel.containsPoint(location) == true) {
                    self.hidden = true
                    self.touchesEndedAtButtonCancel.raise()
                    self.removeFromParent()
                    return
                }
            }
            
            if let _ = self.buttonOK {
                if (self.buttonOK.containsPoint(location) == true) {
                    self.hidden = true
                    self.touchesEndedAtButtonOK.raise()
                    self.removeFromParent()
                    return
                }
            }
        }
    }
    
    override var hidden: Bool {
        didSet {
            self.userInteractionEnabled = !hidden
        }
    }
}
