//
//  MissionScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MissionScene: GameScene {
    enum states {
        case mission
        case paused
        case afterMission
    }
    
    var state = states.mission
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    var world:World!
    var camera:Camera!
    var player:Player!
    var mapManager:MapManager!
    
    let velo:CGFloat = 3
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.cornflowerBlue
        
        self.world = World()
        self.addChild(world)
        
        self.physicsWorld.gravity = CGVectorMake(0 ,-2);
        
        
        self.camera = Camera()
        world.addChild(camera)
        
        self.player = Player(x: 0, y: 100, loadPhysics: true)
        
        world.addChild(player)
    
        
        self.mapManager = MapManager()
        world.addChild(mapManager)
        
        mapManager.reloadMap(player.position)
        
        
        self.addChild(Button(name: "buttonLeft", textureName: "buttonYellowLeft" ,x:20, y:652, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonRight", textureName: "buttonYellowRight" ,x:118, y:652, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonJump" ,x:1236, y:652, xAlign:.right, yAlign:.down))
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGrayLeft" ,x:20, y:20, xAlign:.left, yAlign:.down))
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
            case states.mission:
                self.player.update(currentTime)
                self.mapManager.update(currentTime, position: self.player.position)
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                let player = self.childNodeWithName("//player")! as! Player
                player.update(currentTime)
                break
            case states.afterMission:
                self.view!.presentScene(AfterMissionScene(), transition: Config.defaultGoTransition)
                break
                
            default:
                break
            }
        }
    }
    
     override func didFinishUpdate()
    {
        self.camera.update(self.player.position)
    
}
}
