//
//  MultiplayerWinBox.swift
//  TowerUp
//
//  Created by Pablo Henrique on 28/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MultiplayerWinBox: Box {
    
    var labelName:Label!
    
    
    init(background: String, name:String) {
        super.init(background: background)
        
        self.addChild(Button(name: "buttonExit", textureName: "buttonGraySquare", text:"X", x: 98, y: 590))
        
        self.labelName = Label(name: "labelName", color:GameColors.black, textureName: name, x: 288, y: 226)
        self.addChild(self.labelName)
        
        if let scene = self.scene as? MultiplayerGameScene {
            //scene.socket.emit("win", scene.room)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if (self.childNodeWithName("buttonExit")!.containsPoint(location)) {
                if let scene = self.scene as? MultiplayerGameScene {
                    scene.view!.presentScene(MainMenuScene(), transition: Config.defaultGoTransition)
                }
                return
            }
        }
    }
}