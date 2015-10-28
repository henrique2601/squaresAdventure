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
        super.init(background: background, x:435, y:82, xAlign:.center, yAlign:.down)
        
        let afterMissionBoxBackground = Control(textureName: "afterMissionBoxBackground", x: 71, y: 172)
        self.addChild(afterMissionBoxBackground)
        
        self.buttonExit = Button(textureName: "buttonGraySquare", icon:"home", x: 42, y: 466)
        self.addChild(self.buttonExit)
        self.buttonRestart = Button(textureName: "buttonBlueSquare", icon:"restart", x: 182, y: 466)
        self.addChild(self.buttonRestart)
        self.buttonNext = Button(textureName: "buttonBlueSquare", icon:"end",x: 322, y: 466)
        self.addChild(self.buttonNext)
        
        var starsCount:Int = 0
        
        let floorData = MemoryCard.sharedInstance.currentFloor()
        
        let minCoins = Towers.types[MapManager.tower].floorTypes[MapManager.floor].minCoins
        if(floorData.bonus == NSNumber(bool: false)) {
            if(Int(bonus) >= minCoins) {
                floorData.bonus = NSNumber(bool: true)
                self.labelBonus = Label(color:GameColors.green, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
                starsCount++
            } else {
                self.labelBonus = Label(color:GameColors.red, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            }
        } else {
            self.labelBonus = Label(color:GameColors.gray, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
        }
        self.addChild(self.labelBonus)
        
        
        let maxDeathCount = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxDeathCount
        if(floorData.deaths == NSNumber(bool: false)) {
            if(Int(deaths) <= maxDeathCount) {
                floorData.deaths = NSNumber(bool: true)
                self.labelDeaths = Label(color:GameColors.green, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
                starsCount++
            } else {
                self.labelDeaths = Label(color:GameColors.red, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            }
        } else {
            self.labelDeaths = Label(color:GameColors.gray, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
        }
        self.addChild(self.labelDeaths)
        
        
        
        let maxTime = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxTime
        if(floorData.time == NSNumber(bool: false)) {
            if(Int(time) <= maxTime) {
                floorData.time = NSNumber(bool: true)
                self.labelTime = Label(color:GameColors.green, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
                starsCount++
            } else {
                self.labelTime = Label(color:GameColors.red, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            }
        } else {
            self.labelTime = Label(color:GameColors.gray, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
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
        
        for(var i = 0; i <= floorData.stars.integerValue; i++) {
            switch(i) {
            case 0:
                break
            case 1:
                self.addChild(Control(textureName: "starBig", x: 20, y: 20))
                break
            case 2:
                self.addChild(Control(textureName: "starBig", x: 168, y: 20))
                break
            case 3:
                self.addChild(Control(textureName: "starBig", x: 316, y: 20))
                break
                
            default:
                break
            }
        }
        
        self.labelBonus.zPosition = afterMissionBoxBackground.zPosition + 1
        self.labelDeaths.zPosition = afterMissionBoxBackground.zPosition + 1
        self.labelTime.zPosition = afterMissionBoxBackground.zPosition + 1
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
