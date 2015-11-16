//
//  AfterMissionBox.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/20/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class AfterMissionBox: Box {
    
    var labelTime:Label!
    var labelDeaths:Label!
    var labelBonus:Label!
    
    var buttonExit:Button!
    var buttonRestart:Button!
    var buttonNext:Button!
    
    init(background: String, time:String, deaths:String, bonus:String, scene:SKScene?) {
        super.init(textureName: background, x:435, y:82, xAlign:.center, yAlign:.down)
        
        let afterMissionBoxBackground = Control(textureName: "afterMissionBoxBackground", x: 71, y: 172)
        self.addChild(afterMissionBoxBackground)
        
        self.buttonExit = Button(textureName: "buttonGraySquare", icon:"home", x: 42, y: 466)
        self.addChild(self.buttonExit)
        self.buttonRestart = Button(textureName: "buttonSandSquare", icon:"restart", x: 182, y: 466)
        self.addChild(self.buttonRestart)
        self.buttonNext = Button(textureName: "buttonSandSquare", icon:"end",x: 322, y: 466)
        self.addChild(self.buttonNext)
        
        let floorData = MemoryCard.sharedInstance.currentFloor()
        
        /*
        se esta completa
            cinza++
            se completou
                amarela++
        senao
            se completou
                novaAmarela++
        
        for i de 0 ate estrelacinza.count
            exibe estrela cinza
        
        
        for j de 0 ate amarela count
            exibe amarela na posicao i - j
        
        for h 0 ate nova amarela
            exibe amarela na posicao i + h
        
        */
        
        var starsYellowNew:Int = 0
        var starsYellow:Int = 0
        var starsGray:Int = 0
        
        let minCoins = Towers.types[MapManager.tower].floorTypes[MapManager.floor].minCoins
        
        if(floorData.bonus == NSNumber(bool: true)) {
            
            starsGray++
            self.labelBonus = Label(color:GameColors.gray, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            
            if(Int(bonus) >= minCoins) {
                starsYellow++
            }
            
        } else {
            if(Int(bonus) >= minCoins) {
                 floorData.bonus = NSNumber(bool: true)
                starsYellowNew++
                self.labelBonus = Label(color:GameColors.green, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            } else {
                self.labelBonus = Label(color:GameColors.red, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            }
        }
        self.addChild(self.labelBonus)
        
        
        let maxDeathCount = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxDeathCount
        
        if(floorData.deaths == NSNumber(bool: true)) {
            starsGray++
            self.labelDeaths = Label(color:GameColors.gray, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            if(Int(deaths) <= maxDeathCount) {
                starsYellow++
                
            }
        } else {
            if(Int(deaths) <= maxDeathCount) {
                floorData.deaths = NSNumber(bool: true)
                starsYellowNew++
                self.labelDeaths = Label(color:GameColors.green, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            } else {
                self.labelDeaths = Label(color:GameColors.red, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            }
        }
        self.addChild(self.labelDeaths)
        
        
        let maxTime = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxTime
        
        
        if(floorData.time == NSNumber(bool: true)) {
            starsGray++
            self.labelTime = Label(color:GameColors.gray, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            if(Int(time) <= maxTime) {
                starsYellow++
            }
        } else {
            if(Int(time) <= maxTime) {
                 floorData.time = NSNumber(bool: true)
                starsYellowNew++
                self.labelTime = Label(color:GameColors.green, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            } else {
                self.labelTime = Label(color:GameColors.red, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            }
        }
        self.addChild(self.labelTime)
        
        
        let lastStars = floorData.stars.integerValue
        floorData.stars = NSNumber(integer: floorData.bonus.integerValue + floorData.deaths.integerValue + floorData.time.integerValue)
        if(lastStars < 3 && floorData.stars.integerValue == 3) {
            
            let playerData = MemoryCard.sharedInstance.playerData
            
            if let teste = scene {
                teste.addChild(MessageBox(text: "3 stars : + 50 coins", textureName: "messegeBox", type: MessageBox.messageType.OK))
                playerData.coins = NSNumber(integer: playerData.coins.integerValue + 50)
            }
            
            var towerStars = 0
            for item in MemoryCard.sharedInstance.currentTower().floors {
                let floorData = item as! FloorData
                towerStars = towerStars + floorData.bonus.integerValue + floorData.deaths.integerValue + floorData.time.integerValue
            }
            
            if (towerStars == Towers.types[MapManager.tower].floorTypes.count * 3) {
                if let teste = scene {
                    teste.addChild(MessageBox(text: "Tower 100% : + 10 diamonds", textureName: "messegeBox", type: MessageBox.messageType.OK))
                    playerData.gems = NSNumber(integer: playerData.gems.integerValue + 10)
                }
            }
        }
        
        /*
        for i de 0 ate estrelacinza.count
            exibe estrela cinza
        
        
        for j de 0 ate amarela count
            exibe amarela na posicao i - j
        
        for h 0 ate nova amarela
            exibe amarela na posicao i + h
        */
        
        var i = 0
        var j = 0
        var h = 0
        
        for i = 0; i < starsGray; i++ {
            showStarGrayAt(i)
        }
        i--
        
        for j = 0; j < starsYellow; j++ {
            self.showStarAt(i - j)
        }
        i++
        for h = 0; h < starsYellowNew; h++ {
            self.showStarAt(i + h)
        }
        
        self.labelBonus.zPosition = afterMissionBoxBackground.zPosition + 1
        self.labelDeaths.zPosition = afterMissionBoxBackground.zPosition + 1
        self.labelTime.zPosition = afterMissionBoxBackground.zPosition + 1
    }
    
    
    
    func showStarGrayAt(i:Int) {
        
        let starTexture = SKTexture(imageNamed: "starBig")
        let starSpriteNode = SKSpriteNode(texture: starTexture, color: UIColor.clearColor(), size: starTexture.size())
        
        starSpriteNode.color = UIColor.blackColor()
        starSpriteNode.colorBlendFactor = 0.5
        
        switch(i) {
        case 0:
            let star = Control(spriteNode:starSpriteNode, x: 20, y: 20)
            self.addChild(star)
            break
        case 1:
            let star = Control(spriteNode:starSpriteNode, x: 168, y: 20)
            self.addChild(star)
            break
        case 2:
            let star = Control(spriteNode:starSpriteNode, x: 316, y: 20)
            self.addChild(star)
            break
            
        default:
            break
        }
    }
    
    func showStarAt(i:Int) {
        switch(i) {
        case 0:
            let star = Control(textureName: "starBig", x: 20, y: 20)
            let startingPosition = star.position
            let randonPosition = CGPoint(x: Int.random(min: -2000, max: 2000), y: Int.random(min: -2000, max: 2000))
            star.position = randonPosition
            self.addChild(star)
            let emitterNode = SKEmitterNode(fileNamed: "Win.sks")!
            star.runAction(SKAction.moveTo(startingPosition, duration: 1), completion: {
                emitterNode.particleBirthRate = 1000000
                emitterNode.particleSpeedRange = 10000
            })
            emitterNode.position = CGPoint(
                x: star.calculateAccumulatedFrame().width/2,
                y: -star.calculateAccumulatedFrame().height/2)
            emitterNode.targetNode = star.parent!
            star.addChild(emitterNode)
            
            break
        case 1:
            let star = Control(textureName: "starBig", x: 168, y: 20)
            let startingPosition = star.position
            let randonPosition = CGPoint(x: Int.random(min: -2000, max: 2000), y: Int.random(min: -2000, max: 2000))
            star.position = randonPosition
            self.addChild(star)
            let emitterNode = SKEmitterNode(fileNamed: "Win.sks")!
            star.runAction(SKAction.moveTo(startingPosition, duration: 1), completion: {
                emitterNode.particleBirthRate = 1000000
                emitterNode.particleSpeedRange = 10000
            })
            emitterNode.position = CGPoint(
                x: star.calculateAccumulatedFrame().width/2,
                y: -star.calculateAccumulatedFrame().height/2)
            emitterNode.targetNode = star.parent!
            star.addChild(emitterNode)
            break
        case 2:
            let star = Control(textureName: "starBig", x: 316, y: 20)
            let startingPosition = star.position
            let randonPosition = CGPoint(x: Int.random(min: -2000, max: 2000), y: Int.random(min: -2000, max: 2000))
            star.position = randonPosition
            self.addChild(star)
            let emitterNode = SKEmitterNode(fileNamed: "Win.sks")!
            star.runAction(SKAction.moveTo(startingPosition, duration: 1), completion: {
                emitterNode.particleBirthRate = 1000000
                emitterNode.particleSpeedRange = 10000
            })
            emitterNode.position = CGPoint(
                x: star.calculateAccumulatedFrame().width/2,
                y: -star.calculateAccumulatedFrame().height/2)
            emitterNode.targetNode = star.parent!
            star.addChild(emitterNode)
            break
            
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if (self.buttonExit.containsPoint(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.floors
                    scene.blackSpriteNode.hidden = true
                    self.removeFromParent()
                }
                return
            }
            if (self.buttonRestart.containsPoint(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.mission
                    scene.blackSpriteNode.hidden = true
                    self.removeFromParent()
                }
                return
            }
            if (self.buttonNext.containsPoint(location)) {
                //
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.powerUp
                    scene.blackSpriteNode.hidden = true
                    self.removeFromParent()
                    MapManager.floor++
                    
                    var towerIndex = 0
                    for _ in MemoryCard.sharedInstance.playerData.towers {
                        if(MapManager.tower == towerIndex) {
                            //Encontrou torre selecionada
                            let towerType = Towers.types[towerIndex]
                            if(MapManager.floor >= towerType.floorTypes.count) {
                                MapManager.floor = 0
                                MapManager.tower++
                                if(MapManager.tower >= Towers.types.count) {
                                    MapManager.tower = 0
                                }
                            }
                            break
                        }
                        towerIndex++
                    }
                }
                return
            }
        }
    }
}
