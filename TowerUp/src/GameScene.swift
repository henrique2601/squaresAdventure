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
    
    var roomID:NSString?
    
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
        
        NotificationCenter.default.addObserver(self, selector: "privateGameInviteRecivied:", name:NSNotification.Name(rawValue: "privateGameInvite"), object: roomID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.scaleMode = SKSceneScaleMode.aspectFit
        self.anchorPoint = CGPoint(x: 0, y: 1)
        MemoryCard.sharedInstance.saveGame()
        
        self.setBackground()
        
        Control.gameScene = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        ScrollNode.update()
    }
    
    override func didFinishUpdate() {
        Control.dx = 0
        Control.dy = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Control.touchesBegan(touches: touches )
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        Control.touchesMoved()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Control.touchesEnded(touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        Control.touchesEnded(touches: touches as Set<UITouch>)
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
        
        self.backgroundUp = Control(spriteNode: spriteNode, size:size, x: 0, y: 0, z: -20000, xAlign: .center, yAlign: .up)
        
        self.addChild(self.backgroundUp)
        
        spriteNode = SKSpriteNode(texture: nil, color: GameColors.greenGrass, size: self.size)
        self.backgroundDown = Control(spriteNode: spriteNode, size:size, x: 0, y: 375, z: -20000, xAlign: .center, yAlign: .center)
        self.addChild(self.backgroundDown)
    }
    
    func privateGameInviteRecivied(notification: NSNotification){
        //Take Action on Notification
        print("notification recieved")
        //print(notification)
        
        let roomID = notification.object as! String
        
        print(roomID)
        
        //self.view!.presentScene(PrivateLobbySceneSecondary(roomName: roomID), transition: Config.defaultTransition)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
}
