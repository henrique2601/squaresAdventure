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
        case win
        case floors
        case powerUp
    }
    
    var state = states.loading
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    var world:World!
    var myCamera:GameCamera!
    var player:Player!
    var mapManager:MapManager!
    var parallax:Parallax!
    
    let velo:CGFloat = 3
    
    //Effect
    var blackSpriteNode:SKSpriteNode!
    
    //Gameplay
    var lastReset:NSTimeInterval!
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var labelCoins:Label!
    var collectedBonus = 0 {
        didSet {
            self.labelCoins.setText(MemoryCard.sharedInstance.playerData.coins.description)
            PowerUp.updatePowerUpLabels()
        }
    }
    
    var powerUpsScrollNode:ScrollNode!
    
    //Controls
    var buttonLeft:Button!
    var buttonRight:Button!
    var buttonJump:Button!
    
    var slider:Slider!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blueSky
        
        self.parallax = Parallax(imageNamed: "grassBackground")
        self.addChild(self.parallax)
        
        self.world = World(physicsWorld: self.physicsWorld)
        self.addChild(self.world)
        self.physicsWorld.contactDelegate = self
        
        
        self.myCamera = GameCamera()
        self.world.addChild(self.myCamera)
        
        //self.player = Player(x: 200, y: 100, loadPhysics: true)
        self.player = Player(playerData: self.playerData, x: 200, y: 100, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.mapManager = MapManager()
        self.world.addChild(self.mapManager)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: Chunk.sizeInPoints + 10))
        
        switch(self.playerData.configControls.integerValue) {
            
        case 1: //controlsConfig.useButtons.rawValue:
            self.buttonLeft = Button(name: "buttonLeft", textureName: "buttonYellowSquare", text:"<", x:20, y:630, xAlign:.left, yAlign:.down)
            self.addChild(self.buttonLeft)
            
            self.buttonRight = Button(name: "buttonRight", textureName: "buttonYellowSquare", text:">" ,x:160, y:630, xAlign:.left, yAlign:.down)
            self.addChild(self.buttonRight)
            
            self.buttonJump = Button(name: "buttonJump", textureName: "buttonYellow", text:"Jump", x:1014, y:630, xAlign:.right, yAlign:.down)
            self.addChild(self.buttonJump)
            break
            
        default:
            break
        }
        
        
        
        let boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.labelCoins = Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39)
        boxCoins.addChild(self.labelCoins)
        self.addChild(boxCoins)
        
        if(self.playerData.powerUps.count > 0) {
            var powerUpsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                if let powerUpSlotData = item as? PowerUpSlotData {
                    if let powerUpData = powerUpSlotData.powerUp {
                        let powerUp = PowerUp(powerUpData: powerUpData)
                        powerUp.loadEvent(self.player)
                        powerUpsArray.append(powerUp)
                    }
                }
            }
            
            self.powerUpsScrollNode = ScrollNode(name: "powerUpSlotsScrollNode", textureName: "", x: 667, y: 680, xAlign: .center, yAlign: .down, cells: powerUpsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false)
            self.powerUpsScrollNode.canScroll = false
            self.addChild(self.powerUpsScrollNode)
            
            PowerUp.updatePowerUpLabels()
        }
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"X" ,x:20, y:20, xAlign:.left, yAlign:.up))
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
                PowerUp.doLogic(currentTime)
                
                switch(self.playerData.configControls.integerValue) {
                case 1: //controlsConfig.useButtons.rawValue:
                    self.player.jump = self.buttonJump.pressed
                    
                    self.player.move = 0
                    if(self.buttonLeft.pressed) {
                        self.player.move += -100
                    }
                    if(self.buttonRight.pressed) {
                        self.player.move += 100
                    }
                    break
                case 2: //controlsConfig.useLeftSliderAndScreenRight:
                    
                    var jump = 0
                    for touch in Control.touchesArray {
                        let location = touch.locationInNode(self)
                        
                        if(location.x > (self.scene?.size.width)!/2) {
                            jump++
                        }
                    }
                    
                    if(self.slider != nil) {
                        var x = Int(self.slider.touch.locationInNode(self).x) - Int(self.slider.position.x)
                        if(x > self.slider.limit) {
                            x = self.slider.limit
                        }
                        if(x < -self.slider.limit) {
                            x = -self.slider.limit
                        }
                        let y = Int(self.slider.thumbSpriteNode.position.y)
                        self.slider.thumbSpriteNode.position = CGPoint(x: x, y: y)
                        self.player.move = Int(100.0 * (Float(x) / Float(self.slider.limit)))
                    } else {
                        self.player.move = 0
                    }
                    
                    
                    self.player.jump = jump > 0
                    
                    break
                default:
                    break
                }
                
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
            case states.win:
                
                //Desbloquear nova fase?
                var towerIndex:Int = 0
                for item in self.playerData.towers as NSOrderedSet {
                    let tower = item as! TowerData
                    
                    let towerType = Towers.types[towerIndex]
                    
                    if(MapManager.tower == towerIndex) {
                        if(MapManager.floor == tower.floors.count - 1) {
                            if(tower.floors.count < towerType.floorCount) {
                                let floor = MemoryCard.sharedInstance.newFloorData()
                                tower.addFloor(floor)
                            } else {
                                if (tower.floors.count == towerType.floorCount) {
                                    //Libera fase para futuros updates
                                    var floor = MemoryCard.sharedInstance.newFloorData()
                                    tower.addFloor(floor)
                                    
                                    //Cria próxima torre
                                    let newTower = MemoryCard.sharedInstance.newTowerData()
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
                let box = AfterMissionBox(background: "boxWhite", time: Int(currentTime - self.lastReset).description, deaths: self.player.deathCount.description, bonus: self.collectedBonus.description)
                self.collectedBonus = 0
                
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                
                break
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultGoTransition)
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
            self.myCamera.update(self.player.position)
        }
        self.parallax.update(self.myCamera.position)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        switch(self.playerData.configControls.integerValue) {
        case 2: //controlsConfig.useLeftSliderAndScreenRight.rawValue:
            if (self.state == self.nextState) {
                for touch in touches {
                    
                    let location = touch.locationInNode(self)
                    
                    if(self.slider == nil) {
                        if(location.x < (self.scene?.size.width)!/2) {
                            self.slider = Slider(name: "slider", x: 0, y: 0, align:.center)
                            self.slider.touch = touch
                            self.addChild(self.slider)
                            self.slider.position = location
                        }
                    }
                }
            }
            break
        default:
            break
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        switch(self.playerData.configControls.integerValue) {
        case 2: //controlsConfig.useLeftSliderAndScreenRight.rawValue:
            if Control.touchesArray.count <= 0 {
                if let slider = self.slider {
                    slider.removeFromParent()
                    self.slider = nil
                }
            } else {
                if let slider = self.slider {
                    for touch in touches {
                        if (slider.touch == touch) {
                            slider.removeFromParent()
                            self.slider = nil
                        }
                    }
                }
            }
            break
        default:
            break
        }
        
        if (self.state == self.nextState) {
            for touch in touches {
                let location = touch.locationInNode(self)
                
                if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                    self.nextState = .floors
                    return
                }
            }
        }
    }
}
