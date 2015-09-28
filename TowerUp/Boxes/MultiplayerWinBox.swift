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
    
    var buttonExit:Button!
    
    init(background: String, name:String) {
        super.init(background: background)
        
        self.buttonExit = Button(textureName: "buttonGraySquare", text:"X", x: 98, y: 590)
        self.addChild(self.buttonExit)
        
        self.labelName = Label(text: name, x: 288, y: 226)
        self.addChild(self.labelName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if (self.buttonExit.containsPoint(location)) {
                if let scene = self.scene as? MultiplayerMissionScene {
                    scene.view!.presentScene(LobbyScene(), transition: Config.defaultGoTransition)
                }
                
                if let scene = self.scene as? LocalGameScene {
                    scene.view!.presentScene(MainMenuScene(), transition: Config.defaultGoTransition)
                }
                
                return
            }
        }
    }
}
