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
    
    init(text:String, textureName:String) {
        super.init(name: "messegeBox", textureName:textureName, x: 412, y: 283, align:.center)
        
        self.zPosition = Config.HUDZPosition * CGFloat(2)
        
        self.addChild(Label(name:"label0", textureName:text, x:255, y:46))
        self.addChild(Button(name: "buttonOK", x:262, y:93))
        self.addChild(Button(name: "buttonCancel", x:14, y:93))
        
        self.hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        Button.touchesEnded(touches as! Set<UITouch>)
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if (self.childNodeWithName("buttonCancel")!.containsPoint(location) == true) {
                self.hidden = true
                self.touchesEndedAtButtonCancel.raise()
                self.removeFromParent()
                return
            }
            
            if (self.childNodeWithName("buttonOK")!.containsPoint(location) == true) {
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
