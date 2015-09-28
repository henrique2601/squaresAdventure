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
    
    init(text:String, textureName:String) {
        super.init(name: "messegeBox", textureName:textureName, x: 412, y: 283)
        
        self.zPosition = Config.HUDZPosition * CGFloat(2)
        
        self.addChild(Label(text:text, x:255, y:46))
        self.buttonOK = Button(textureName: "buttonOK", x:262, y:93)
        self.addChild(self.buttonOK)
        self.buttonCancel = Button(textureName: "buttonCancel", x:14, y:93)
        self.addChild(self.buttonCancel)
        
        self.hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Button.touchesEnded(touches )
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if (self.buttonCancel.containsPoint(location) == true) {
                self.hidden = true
                self.touchesEndedAtButtonCancel.raise()
                self.removeFromParent()
                return
            }
            
            if (self.buttonOK.containsPoint(location) == true) {
                self.hidden = true
                self.touchesEndedAtButtonOK.raise()
                self.removeFromParent()
                return
            }
        }
    }
    
    override var hidden: Bool {
        didSet {
            self.userInteractionEnabled = !hidden
        }
    }
}
