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
        Control.controlList = Set<Control>()
        Button.buttonList = Set<Button>()
        ScrollNode.scrollNodeList = Set<ScrollNode>()
        for textfield in Textfield.textfieldList {
            textfield.myTextField.removeFromSuperview()
        }
        Textfield.textfieldList = Set<Textfield>()
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        Control.touchesBegan(touches as! Set<UITouch>)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        Control.touchesMoved()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        Control.touchesEnded(touches as! Set<UITouch>)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        Control.touchesEnded(touches as! Set<UITouch>)
    }
}

public extension SKScene {
    func centerOnNode(node:SKNode)
    {
        let cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: node.parent!)
        node.parent!.position = CGPoint(x: node.parent!.position.x - cameraPositionInScene.x, y: node.parent!.position.y - cameraPositionInScene.y)
    }
}
