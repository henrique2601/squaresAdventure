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
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var boxCoins:Control!
    
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
        
        //self.player = Player(x: 200, y: 100, loadPhysics: true)
        self.player = Player(playerData: self.playerData, x: 200, y: 100, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.mapManager = MapManager()
        self.world.addChild(self.mapManager)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: Chunk.sizeInPoints + 10))
        
        self.addChild(Button(name: "buttonLeft", textureName: "buttonYellowSquare", text:"<", x:20, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonRight", textureName: "buttonYellowSquare", text:">" ,x:160, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonJump", textureName: "buttonYellow", text:"Jump", x:1014, y:630, xAlign:.right, yAlign:.down))
        
        self.addChild(Button(name: "buttonPowerUp0", textureName: "buttonBlueSquare", text:"1", x: 497, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp1", textureName: "buttonOrangeSquare", text:"2", x: 617, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp2", textureName: "buttonYellowSquare", text:"3", x: 737, y: 630, xAlign:.center, yAlign:.down))
        
        self.boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.boxCoins.addChild(Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39))
        self.addChild(self.boxCoins)
        
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
                
                //Desbloquear nova fase?
                var towerIndex:Int = 0
                for item in self.playerData.towers as NSOrderedSet {
                    let tower = item as! TowerData
                    
                    let towerType = Towers.types[towerIndex]
                    
                    if(MapManager.tower == towerIndex) {
                        if(MapManager.floor == tower.floors.count - 1) {
                            if(tower.floors.count < towerType.floorCount) {
                                var floor = MemoryCard.sharedInstance.newFloorData()
                                tower.addFloor(floor)
                            } else {
                                if (tower.floors.count == towerType.floorCount) {
                                    //Libera fase para futuros updates
                                    var floor = MemoryCard.sharedInstance.newFloorData()
                                    tower.addFloor(floor)
                                    
                                    //Cria próxima torre
                                    var newTower = MemoryCard.sharedInstance.newTowerData()
                                    floor = MemoryCard.sharedInstance.newFloorData()
                                    self.playerData.addTower(newTower)
                                    newTower.addFloor(floor)
                                    break
                                }
                            }
                        }
                        break
                    }
                    towerIndex++
                }
                
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: self.size)
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                let box = AfterMissionBox(background: "boxWhite", time: Int(currentTime - self.lastReset).description, deaths: self.player.deathCount.description, bonus: self.player.collectedBonus.description)
                
                self.playerData.coins = NSNumber(integer: Int(self.playerData.coins) + self.player.collectedBonus)
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                
                break
            case states.floors:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultGoTransition)
                break
            case states.powerUp:
                self.view!.presentScene(MissionScene(), transition: Config.defaultGoTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func didFinishUpdate()
    {
        if(self.player.healthPoints > 0){
            self.camera.update(self.player.position)
        }
        self.parallax.update(self.camera.position)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            for touch in (touches as! Set<UITouch>) {
                let location = touch.locationInNode(self)
                
                if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                    self.nextState = .floors
                    return
                }
            }
        
        }
    }
}
