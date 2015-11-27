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
        case restart
        case tutorial6
        case tutorial7
    }
    
    //variavel para teste deve ser substituida por uma que fique salva no banco de dados
    
    var tutorialD:Bool!
    var tutorialD2:Bool!
    
    var tutorial5:SKSpriteNode!
    var tutorial6:SKSpriteNode!
    var labelTutorial5:Control!
    var labelTutorial6:Control!
    
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
    
    //Gameplay
    var lastReset:NSTimeInterval!
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    var boxCoins:BoxCoins!
    var boxDeathsAndTime:BoxDeathsAndTime!
    var collectedBonus = 0 {
        didSet {
            self.boxCoins.labelCoins.setText(MemoryCard.sharedInstance.playerData.coins.description)
            PowerUp.updatePowerUpLabels()
        }
    }
    
    var powerUpsScrollNode:ScrollNode!
    
    //Controls
    var buttonLeft:Button!
    var buttonRight:Button!
    var buttonJump:Button!
    var buttonBack:Button!
    var buttonRestart:Button!
    
    var slider:Slider!
    
    override func setBackground() {
        return
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blueSky
        
        self.boxDeathsAndTime = BoxDeathsAndTime()
        
        Music.sharedInstance.play(musicNamed: "A New Camp.mp3")
        
        self.tutorialD = self.playerData.tutorial!.tutorial5!.boolValue
        self.tutorialD2 = self.playerData.tutorial!.tutorial6!.boolValue
        
        self.parallax = Parallax(imageNamed: Towers.types[MapManager.tower].tileset + "Background")
        self.addChild(self.parallax)
        
        self.world = World(physicsWorld: self.physicsWorld)
        self.addChild(self.world)
        self.physicsWorld.contactDelegate = self
        
        
        self.myCamera = GameCamera()
        self.world.addChild(self.myCamera)
        
        self.mapManager = MapManager()
        self.world.addChild(self.mapManager)
        
        self.player = Player(playerData: self.playerData, x: 128, y: 128, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: 10))
        
        switch(self.playerData.configControls.integerValue) {
            
        case controlsConfig.useButtons.rawValue:
            self.buttonLeft = Button(textureName: "buttonSandSquare", icon:"arrowLeft", x:20, y:626, xAlign:.left, yAlign:.down, colorBlendFactor:0.5, top:Int(Config.currentSceneSize.height/2), bottom: 39, left:39, right:39)
            
            self.addChild(self.buttonLeft)
            
            self.buttonRight = Button(textureName: "buttonSandSquare", icon:"arrowRight" ,x:276, y:626, xAlign:.left, yAlign:.down, colorBlendFactor:0.5, top:Int(Config.currentSceneSize.height/2), bottom: 39, left:39, right:39)
            self.addChild(self.buttonRight)
            
            self.buttonJump = Button(textureName: "buttonSand", icon:"arrowUp", x:1014, y:626, xAlign:.right, yAlign:.down, colorBlendFactor:0.5, top:Int(Config.currentSceneSize.height/2), bottom: 39, left:39, right:39)
            
            self.addChild(self.buttonJump)
            break
            
        default:
            break
        }
        
        self.boxCoins = BoxCoins()
        
        self.addChild(boxCoins)
        self.addChild(boxDeathsAndTime)
        
        if(self.playerData.powerUps.count > 0) {
            var powerUpsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                if let powerUpSlotData = item as? PowerUpSlotData {
                    if let powerUpData = powerUpSlotData.powerUp {
                        let powerUp = PowerUp(powerUpData: powerUpData, colorBlendFactor: 0.5)
                        powerUp.loadEvent(self.player, world: self.world)
                        powerUpsArray.append(powerUp)
                    }
                }
            }
            
            self.powerUpsScrollNode = ScrollNode(x: 547, y: 680, xAlign: .center, yAlign: .down, cells: powerUpsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false)

            self.powerUpsScrollNode.canScroll = false
            self.addChild(self.powerUpsScrollNode)
            
            PowerUp.updatePowerUpLabels()
        }
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return" ,x:20, y:20, xAlign:.left, yAlign:.up)
        self.addChild(self.buttonBack)
        
        self.buttonRestart = Button(textureName: "buttonSandSquareSmall", icon:"restart" ,x:118, y:20, xAlign:.left, yAlign:.up)
        self.addChild(self.buttonRestart)
        
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        world.didBeginContact(contact)
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        world.didEndContact(contact)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        if(self.state == self.nextState){
            switch (self.state) {
            case states.mission:
                
                if(self.boxDeathsAndTime.time < Int(currentTime - self.lastReset)) {
                    self.boxDeathsAndTime.time = Int(currentTime - self.lastReset)
                    
                }
                
                switch(self.playerData.configControls.integerValue) {
                case controlsConfig.useButtons.rawValue:
                    self.player.jump = self.buttonJump.pressed
                    
                    self.player.move = 0
                    if(self.buttonLeft.pressed) {
                        self.player.move += -100
                    }
                    if(self.buttonRight.pressed) {
                        self.player.move += 100
                    }
                    break
                case controlsConfig.useLeftSliderAndScreenRight.rawValue:
                    
                    var jump = 0
                    for touch in Control.touchesArray {
                        let location = touch.locationInNode(self)
                        
                        if (!self.powerUpsScrollNode.containsPoint(location)) {
                            if(location.x > (self.scene?.size.width)!/2) {
                                jump++
                            }
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
                
                PowerUp.doLogic(currentTime)
                
                self.player.update(currentTime)
                self.mapManager.update(currentTime)
                Emitter.update(currentTime)
                
                if(!tutorialD) {
                    
                    self.nextState = states.tutorial6
                    
                    self.playerData.tutorial?.tutorial5 = NSNumber(bool: true)
                    //
                    
                }
                
                
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
                
            case states.restart:
                self.view!.presentScene(MissionScene(), transition: Config.defaultTransition)
                break
                
            case states.mission:
                self.mapManager.reloadMap(CGPoint(x: 10, y: 10))
                self.player.reset()
                self.boxDeathsAndTime.reset()
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
                            if(tower.floors.count < towerType.floorTypes.count) {
                                let floor = MemoryCard.sharedInstance.newFloorData()
                                tower.addFloor(floor)
                            } else {
                                if (tower.floors.count == towerType.floorTypes.count) {
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
                
                let box = AfterMissionBox(background: "boxWhite", time: Int(currentTime - self.lastReset).description, deaths: self.player.deathCount.description, bonus: self.collectedBonus.description, scene: self.scene)
                
                self.addChild(box)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = box.zPosition - 1
                
                break
            case states.floors:
                self.view!.presentScene(FloorsScene(), transition: Config.defaultTransition)
                break
            case states.powerUp:
                self.view!.presentScene(MissionScene(), transition: Config.defaultTransition)
                break
                
            case states.tutorial6:
                
                
                self.tutorial5 = SKSpriteNode(imageNamed: "finger00")
                self.tutorial5.position = CGPoint(x: 290,y: -110)
                self.tutorial5.size.height = 128
                self.tutorial5.size.width = 256
                self.addChild(tutorial5)
                self.tutorial5.runAction(self.tutorialAnimation)
                self.labelTutorial5 = Control(textureName: "tutorialEn5", x:120 , y:120)
                self.labelTutorial5.zPosition = self.tutorial5.zPosition - 1
                self.addChild(labelTutorial5)
                
                self.nextState  = states.tutorial7
                self.tutorialD = true
                
                break
                
            case states.tutorial7:
                
                self.tutorial6 = SKSpriteNode(imageNamed: "tapFinger00")
                self.tutorial6.position = CGPoint(x: 550,y: -220)
                self.tutorial6.size.height = 128
                self.tutorial6.size.width = 256
                self.addChild(tutorial6)
                self.tutorial6.runAction(self.tutorialAnimation2)
                
                self.nextState  = states.mission
                self.tutorialD2 = true
                
                self.playerData.tutorial?.tutorial6 = NSNumber(bool: true)
                
                break
                
                default:
                break
            }
        }
    }
    
    override func didFinishUpdate()
    {
        super.didFinishUpdate()
        if(self.player.healthPoints > 0){
            self.myCamera.update(CGPoint(x:Int(self.player.position.x), y: Int(self.player.position.y)))
        }
        self.parallax.update(self.myCamera.position)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        switch(self.playerData.configControls.integerValue) {
        case controlsConfig.useLeftSliderAndScreenRight.rawValue:
            if (self.state == self.nextState) {
                for touch in touches {
                    
                    let location = touch.locationInNode(self)
                    
                    if(self.slider == nil) {
                        if(location.x < (self.scene?.size.width)!/2) {
                            self.slider = Slider()
                            self.slider.touch = touch
                            Control.touchesArray.remove(self.slider.touch)
                            self.addChild(self.slider)
                            self.slider.position = CGPoint(x: Int(location.x), y: Int(location.y) + 32)
                            
                            if(!tutorialD2){
                            
                                self.nextState = states.tutorial6
                                
                                print("Ultima parte")
                                
                                
                            
                            }
                            
                            break
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
        case controlsConfig.useLeftSliderAndScreenRight.rawValue:
            
            if let slider = self.slider {
                for touch in touches {
                    if (slider.touch == touch) {
                        slider.removeFromParent()
                        self.slider = nil
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
                
                if (self.buttonBack.containsPoint(location)) {
                    self.nextState = .floors
                    return
                }
                if(self.boxCoins.containsPoint(location)) {
                    self.boxCoins.containsPoint()
                }
                if (self.buttonRestart.containsPoint(location)) {
                    self.nextState = .restart
                    return
                }
                
            }
        }
    }
    
    
    lazy var tutorialAnimation:SKAction = {
        let textures = [
            SKTexture(imageNamed: "finger00"),
            SKTexture(imageNamed: "finger01"),
            SKTexture(imageNamed: "finger02"),
            SKTexture(imageNamed: "finger03"),
            SKTexture(imageNamed: "finger04"),
            SKTexture(imageNamed: "finger05"),
            SKTexture(imageNamed: "finger06"),
            SKTexture(imageNamed: "finger07"),
            SKTexture(imageNamed: "finger08"),
            SKTexture(imageNamed: "finger09"),
            SKTexture(imageNamed: "finger10"),
            SKTexture(imageNamed: "finger11"),
            SKTexture(imageNamed: "finger12"),
            SKTexture(imageNamed: "finger13"),
            SKTexture(imageNamed: "finger14"),
            SKTexture(imageNamed: "finger15"),
            SKTexture(imageNamed: "finger16"),
            SKTexture(imageNamed: "finger17"),
            SKTexture(imageNamed: "finger18"),
            SKTexture(imageNamed: "finger19"),
            SKTexture(imageNamed: "finger20"),
            SKTexture(imageNamed: "finger21"),
            SKTexture(imageNamed: "finger22"),
            SKTexture(imageNamed: "finger23"),
            SKTexture(imageNamed: "finger24"),
            SKTexture(imageNamed: "finger25"),
            SKTexture(imageNamed: "finger26"),
            SKTexture(imageNamed: "finger27"),
            SKTexture(imageNamed: "finger28"),
            SKTexture(imageNamed: "finger29"),
            SKTexture(imageNamed: "finger30"),
            SKTexture(imageNamed: "finger31"),
            SKTexture(imageNamed: "finger32"),
            SKTexture(imageNamed: "finger33")
        ]
        
        let a = SKAction.animateWithTextures(textures, timePerFrame: 0.08)
        
        let b = SKAction.repeatAction(a, count: 5)
        
        return b
    }()
    
    lazy var tutorialAnimation2:SKAction = {
        let textures = [
            SKTexture(imageNamed: "tapFinger00"),
            SKTexture(imageNamed: "tapFinger01"),
            SKTexture(imageNamed: "tapFinger02"),
            SKTexture(imageNamed: "tapFinger03"),
            SKTexture(imageNamed: "tapFinger04"),
            SKTexture(imageNamed: "tapFinger05"),
            SKTexture(imageNamed: "tapFinger06"),
            SKTexture(imageNamed: "tapFinger07"),
            SKTexture(imageNamed: "tapFinger08"),
            SKTexture(imageNamed: "tapFinger09"),
            SKTexture(imageNamed: "tapFinger10"),
            SKTexture(imageNamed: "tapFinger11"),
            SKTexture(imageNamed: "tapFinger12"),
            SKTexture(imageNamed: "tapFinger13"),
            SKTexture(imageNamed: "tapFinger14"),
            SKTexture(imageNamed: "tapFinger15"),
            SKTexture(imageNamed: "tapFinger16"),
            SKTexture(imageNamed: "tapFinger17"),
            SKTexture(imageNamed: "tapFinger18"),
            SKTexture(imageNamed: "tapFinger19"),
            SKTexture(imageNamed: "tapFinger20"),
            SKTexture(imageNamed: "tapFinger21"),
            SKTexture(imageNamed: "tapFinger22"),
            SKTexture(imageNamed: "tapFinger23"),
            SKTexture(imageNamed: "tapFinger24"),
            SKTexture(imageNamed: "tapFinger25"),
            SKTexture(imageNamed: "tapFinger26"),
            SKTexture(imageNamed: "tapFinger27"),
            SKTexture(imageNamed: "tapFinger28"),
            SKTexture(imageNamed: "tapFinger29"),
            SKTexture(imageNamed: "tapFinger30"),
            SKTexture(imageNamed: "tapFinger31")
        ]
        
        let a = SKAction.animateWithTextures(textures, timePerFrame: 0.08)
        
        let b = SKAction.repeatAction(a, count: 5)
        
        return b
    }()

    
}
