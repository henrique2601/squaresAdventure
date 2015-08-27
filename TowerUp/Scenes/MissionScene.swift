//
//  MissionScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MissionScene: GameScene, SKPhysicsContactDelegate {
    enum states {
        case loading
        case mission
        case paused
        case afterMission
        case floors
        case powerUp
    }
    
    var state = states.loading
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    var world:World!
    var camera:Camera!
    var player:Player!
    var mapManager:MapManager!
    var parallax:Parallax!
    
    let velo:CGFloat = 3
    
    //Effect
    var blackSpriteNode:SKSpriteNode!
    
    //Gameplay
    var lastReset:NSTimeInterval!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blueSky
        
        self.parallax = Parallax(imageNamed: "grassBackground")
        self.addChild(self.parallax)
        
        self.world = World(physicsWorld: self.physicsWorld)
        self.addChild(self.world)
        self.physicsWorld.contactDelegate = self
        
        self.camera = Camera()
        self.world.addChild(self.camera)
        
        self.player = Player(x: 200, y: 100, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.mapManager = MapManager()
        self.world.addChild(self.mapManager)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: Chunk.sizeInPoints + 10))
        
        self.addChild(Button(name: "buttonLeft", textureName: "buttonYellowSquare", text:"<", x:20, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonRight", textureName: "buttonYellowSquare", text:">" ,x:160, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonJump", textureName: "buttonYellow", text:"Jump", x:1014, y:630, xAlign:.right, yAlign:.down))
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"||" ,x:20, y:20, xAlign:.left, yAlign:.up))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        world.didBeginContact(contact)
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        world.didEndContact(contact)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
            case states.mission:
                self.player.update(currentTime)
                self.mapManager.update(currentTime)
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                self.mapManager.reloadMap(CGPoint(x: 10, y: Chunk.sizeInPoints + 10))
                self.player.reset()
                self.lastReset = currentTime
                break
            case states.afterMission:
                
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: self.size)
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                let box = AfterMissionBox(background: "boxWhite", time: Int(currentTime - self.lastReset).description, deaths: self.player.deathCount.description, bonus: self.player.collectedBonus.description)
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                
                break
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultGoTransition)
                break
            case states.powerUp:
                self.view!.presentScene(PowerUpScene(), transition: Config.defaultGoTransition)
                break

                
                
            default:
                break
            }
        }
    }
    
    override func didFinishUpdate()
    {
        self.camera.update(self.player.position)
        self.parallax.update(self.camera.position)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            for touch in (touches as! Set<UITouch>) {
                let location = touch.locationInNode(self)
                
                if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                    self.nextState = .afterMission
                    return
                }
            }
        
        }
    }
}
