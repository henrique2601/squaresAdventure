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
    
    var blackSpriteNode:BlackSpriteNode!
    
    var backgroundUp:Control!
    var backgroundDown:Control!
    
    override init() {
        Control.touchesArray = Set<UITouch>()
        Bomb.bombList = Array<Bomb>()
        Control.controlList = Set<Control>()
        Button.buttonList = Set<Button>()
        Switch.switchList = Set<Switch>()
        ScrollNode.scrollNodeList = Set<ScrollNode>()
        for textfield in Textfield.textfieldList {
            textfield.myTextField.removeFromSuperview()
        }
        Textfield.textfieldList = Set<Textfield>()
        PowerUp.powerUpList = Set<PowerUp>()
        //PlayerOnline.playerOnlineList = Set<PlayerOnline>()
        
        Emitter.emitterList = Set<Emitter>()
        
        MessageBox.messageBoxCount = 0
        
        super.init(size: Config.currentSceneSize)
        
        self.blackSpriteNode = BlackSpriteNode()
        self.addChild(self.blackSpriteNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = SKSceneScaleMode.AspectFit
        self.anchorPoint = CGPoint(x: 0, y: 1)
        MemoryCard.sharedInstance.saveGame()
        
        self.setBackground()
        
        Control.gameScene = self
    }
    
    override func update(currentTime: NSTimeInterval) {
        ScrollNode.update()
    }
    
    override func didFinishUpdate() {
        Control.dx = 0
        Control.dy = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesBegan(touches )
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesMoved()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesEnded(touches)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        Control.touchesEnded(touches! as Set<UITouch>)
    }
    
    func setBackground() {
        
        if let _ = self.backgroundUp {
            self.backgroundUp.removeFromParent()
        }
        if let _ = self.backgroundDown {
            self.backgroundDown.removeFromParent()
        }
        
        var spriteNode = SKSpriteNode(texture: nil, color: GameColors.blueSky, size: self.size)
        let size = CGSize(width: self.size.width, height: self.size.height/CGFloat(2))
        
        self.backgroundUp = Control(spriteNode: spriteNode, x: 0, y: 0, z: -20000, size:size, xAlign: .center, yAlign: .up)
        
        self.addChild(self.backgroundUp)
        
        spriteNode = SKSpriteNode(texture: nil, color: GameColors.greenGrass, size: self.size)
        self.backgroundDown = Control(spriteNode: spriteNode, x: 0, y: 375, z: -20000, size:size, xAlign: .center, yAlign: .center)
        self.addChild(self.backgroundDown)
    }
}
