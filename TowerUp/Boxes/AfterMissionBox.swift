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
    
    lazy var coinSound:SoundEffect = SoundEffect(soundFile: SoundEffect.files.coin.rawValue, node: self)
    
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
            cinza += 1
            se completou
                amarela += 1
        senao
            se completou
                novaAmarela += 1
        
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
        
        let minCoins = Towers.types[MapManager.tower].floorTypes[MapManager.floor].minCoins!
        
        if(floorData.bonus == NSNumber(value: true)) {
            
            starsGray += 1
            self.labelBonus = Label(color:GameColors.gray, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            
            if(Int(bonus)! >= minCoins) {
                starsYellow += 1
            }
            
        } else {
            if(Int(bonus)! >= minCoins) {
                floorData.bonus = NSNumber(value: true)
                starsYellowNew += 1
                self.labelBonus = Label(color:GameColors.green, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            } else {
                self.labelBonus = Label(color:GameColors.red, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            }
        }
        self.addChild(self.labelBonus)
        
        
        let maxDeathCount = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxDeathCount!
        
        if(floorData.deaths == NSNumber(value: true)) {
            starsGray += 1
            self.labelDeaths = Label(color:GameColors.gray, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            if(Int(deaths)! <= maxDeathCount) {
                starsYellow += 1
                
            }
        } else {
            if(Int(deaths)! <= maxDeathCount) {
                floorData.deaths = NSNumber(value: true)
                starsYellowNew += 1
                self.labelDeaths = Label(color:GameColors.green, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            } else {
                self.labelDeaths = Label(color:GameColors.red, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            }
        }
        self.addChild(self.labelDeaths)
        
        
        let maxTime = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxTime!
        
        
        if(floorData.time == NSNumber(value: true)) {
            starsGray += 1
            self.labelTime = Label(color:GameColors.gray, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            if(Int(time)! <= maxTime) {
                starsYellow += 1
            }
        } else {
            if(Int(time)! <= maxTime) {
                floorData.time = NSNumber(value: true)
                starsYellowNew += 1
                self.labelTime = Label(color:GameColors.green, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            } else {
                self.labelTime = Label(color:GameColors.red, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            }
        }
        self.addChild(self.labelTime)
        
        let lastStars = floorData.stars.intValue
        floorData.stars = NSNumber(value: floorData.bonus.intValue + floorData.deaths.intValue + floorData.time.intValue)
        
        if(lastStars < 3 && floorData.stars.intValue == 3) {
            
            let playerData = MemoryCard.sharedInstance.playerData
            
            if let teste = scene as? MissionScene {
                let bonusCoins = 100
                playerData!.coins = NSNumber(value: playerData!.coins.intValue + bonusCoins)
                
                var labelCoinsCount = Int(teste.boxCoins.labelCoins.getText())!
                let labelCoins = teste.boxCoins.labelCoins
                
                let texture = SKTexture(imageNamed: "gold_1")
                let size = CGSize(width: 32, height: 32)
                
                self.run({ let a = SKAction(); a.duration = 1; return a }(), completion: {
                    for i in 0 ..< bonusCoins {
                        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: size)
                        spriteNode.position = CGPoint(x: Int(Config.sceneSize.width/2), y: -Int(Config.sceneSize.height/2))
                        spriteNode.zPosition = self.zPosition * 10
                        teste.addChild(spriteNode)
                        
                        
                        spriteNode.run(SKAction.fadeAlpha(by: -0.5, duration: 0))
                        
                        let duration = Double.random(min: 0.25, max: 1)
                        spriteNode.run(SKAction.fadeAlpha(by: 0.5, duration: duration))
                        spriteNode.run(SKAction.move(to: CGPoint(x: Int.random(min: -Int(Config.sceneSize.width), max: Int(Config.sceneSize.width) * 2),
                            y: -Int.random(min: -Int(Config.sceneSize.height), max: Int(Config.sceneSize.height) * 2)), duration: duration), completion: {
                                
                                let duration = Double.random(min: 0.25, max: 1)
                                spriteNode.run(SKAction.fadeAlpha(by: -1, duration: duration))
                                
                                spriteNode.run(SKAction.move(to: CGPoint(x: Int(Config.sceneSize.width) - 50, y: -40), duration: duration), completion: {
                                    self.coinSound.play()
                                    spriteNode.removeFromParent()
                                    labelCoinsCount += 1
                                    labelCoins!.setText(labelCoinsCount.description)
                                })
                        })
                    }
                })
            }
            
            var towerStars = 0
            for item in MemoryCard.sharedInstance.currentTower().floors {
                let floorData = item as! FloorData
                towerStars = towerStars + floorData.bonus.intValue + floorData.deaths.intValue + floorData.time.intValue
            }
            
            if (towerStars == Towers.types[MapManager.tower].floorTypes.count * 3) {
                if let teste = scene as? MissionScene {
                    
                    let bonusGems = 10
                    
                    var labelGemsCount = Int(teste.boxCoins.labelGems.getText())!
                    let labelGems = teste.boxCoins.labelGems
                    
                    let texture = SKTexture(imageNamed: "gemBlue")
                    let size = CGSize(width: 64, height: 64)
                    
                    self.run({ let a = SKAction(); a.duration = 2; return a }(), completion: {
                        for var i in 0 ..< bonusGems {
                            let spriteNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: size)
                            spriteNode.position = CGPoint(x: Int(Config.sceneSize.width/2), y: -Int(Config.sceneSize.height/2))
                            spriteNode.zPosition = self.zPosition * 11
                            teste.addChild(spriteNode)
                            
                            
                            spriteNode.run(SKAction.fadeAlpha(by: -0.5, duration: 0))
                            
                            let duration = Double.random(min: 0.25, max: 1)
                            spriteNode.run(SKAction.fadeAlpha(by: 0.5, duration: duration))
                            spriteNode.run(SKAction.move(to: CGPoint(x: Int.random(min: -Int(Config.sceneSize.width), max: Int(Config.sceneSize.width) * 2),
                                y: -Int.random(min: -Int(Config.sceneSize.height), max: Int(Config.sceneSize.height) * 2)), duration: duration), completion: {
                                    
                                    let duration = Double.random(min: 0.25, max: 1)
                                    spriteNode.run(SKAction.fadeAlpha(by: -1, duration: duration))
                                    
                                    spriteNode.run(SKAction.move(to: CGPoint(x: Int(Config.sceneSize.width) - 50, y: -40), duration: duration), completion: {
                                        self.coinSound.play()
                                        spriteNode.removeFromParent()
                                        labelGemsCount += 1
                                        labelGems!.setText(labelGemsCount.description)
                                    })
                            })
                        }
                    })
                    
                    playerData!.gems = NSNumber(value: playerData!.gems.intValue + bonusGems)
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
        
        for i in 0 ..< starsGray {
            showStarGrayAt(i: i)
        }
        i -= 1
        
        for j in 0 ..< starsYellow {
            self.showStarAt(i: i - j)
        }
        i += 1
        for h in 0 ..< starsYellowNew {
            self.showStarAt(i: i + h)
        }
        
        self.labelBonus.zPosition = afterMissionBoxBackground.zPosition + 1
        self.labelDeaths.zPosition = afterMissionBoxBackground.zPosition + 1
        self.labelTime.zPosition = afterMissionBoxBackground.zPosition + 1
    }
    
    
    
    func showStarGrayAt(i:Int) {
        
        let starTexture = SKTexture(imageNamed: "starBig")
        let starSpriteNode = SKSpriteNode(texture: starTexture, color: UIColor.clear, size: starTexture.size())
        
        starSpriteNode.color = UIColor.black
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
            star.run(SKAction.move(to: startingPosition, duration: 1), completion: {
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
            star.run(SKAction.move(to: startingPosition, duration: 1), completion: {
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
            star.run(SKAction.move(to: startingPosition, duration: 1), completion: {
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (self.buttonExit.contains(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.floors
                    scene.blackSpriteNode.isHidden = true
                    self.removeFromParent()
                }
                return
            }
            if (self.buttonRestart.contains(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.mission
                    scene.blackSpriteNode.isHidden = true
                    self.removeFromParent()
                }
                return
            }
            if (self.buttonNext.contains(location)) {
                //
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.powerUp
                    scene.blackSpriteNode.isHidden = true
                    self.removeFromParent()
                    MapManager.floor += 1
                    
                    var towerIndex = 0
                    for _ in MemoryCard.sharedInstance.playerData.towers {
                        if(MapManager.tower == towerIndex) {
                            //Encontrou torre selecionada
                            let towerType = Towers.types[towerIndex]
                            if(MapManager.floor >= towerType.floorTypes.count) {
                                MapManager.floor = 0
                                MapManager.tower += 1
                                if(MapManager.tower >= Towers.types.count) {
                                    MapManager.tower = 0
                                }
                            }
                            break
                        }
                        towerIndex += 1
                    }
                }
                return
            }
        }
    }
}
