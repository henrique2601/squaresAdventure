//
//  GameScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    override init() {
        Control.touchesArray = Set<UITouch>()
        
        Control.controlList = Set<Control>()
        Button.buttonList = Set<Button>()
        ScrollNode.scrollNodeList = Set<ScrollNode>()
        for textfield in Textfield.textfieldList {
            textfield.myTextField.removeFromSuperview()
        }
        Textfield.textfieldList = Set<Textfield>()
        PowerUp.powerUpList = Set<PowerUp>()
        PlayerOnline.playerOnlineList = Set<PlayerOnline>()
        super.init(size: Config.sceneSize())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = SKSceneScaleMode.AspectFit
        self.anchorPoint = CGPoint(x: 0, y: 1)
        MemoryCard.sharedInstance.saveGame()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesBegan(touches )
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesMoved()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesEnded(touches )
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        Control.touchesEnded(touches! as Set<UITouch>)
    }
}

public extension SKScene {
    func centerOnNode(node:SKNode)
    {
        if let parent = node.parent {
            let cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: parent)
            parent.position = CGPoint(x: parent.position.x - cameraPositionInScene.x, y: parent.position.y - cameraPositionInScene.y)
        }
    }
}
