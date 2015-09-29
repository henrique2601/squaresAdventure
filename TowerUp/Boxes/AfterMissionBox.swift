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
    
    init(background: String, time:String, deaths:String, bonus:String) {
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
        
        let towerData = MemoryCard.sharedInstance.playerData.towers[MapManager.tower] as! TowerData
        let floorData = towerData.floors[MapManager.floor] as! FloorData
        
        let minCoins = Towers.types[MapManager.tower].floorTypes[MapManager.floor].minCoins
        if(Int(bonus) >= minCoins) {
            if(floorData.bonus == NSNumber(bool: false)) {
               floorData.bonus = NSNumber(bool: true)
            }
            self.labelBonus = Label(color:GameColors.green, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
            starsCount++
        } else {
            self.labelBonus = Label(color:GameColors.red, text: "\(bonus)/\(minCoins)", x: 266, y: 211)
        }
        self.addChild(self.labelBonus)
        
        let maxDeathCount = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxDeathCount
        if(Int(deaths) <= maxDeathCount) {
            if(floorData.deaths == NSNumber(bool: false)) {
                floorData.deaths = NSNumber(bool: true)
            }
            self.labelDeaths = Label(color:GameColors.green, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
            starsCount++
        } else {
            self.labelDeaths = Label(color:GameColors.red, text: "\(deaths)/\(maxDeathCount)", x: 266, y: 309)
        }
        self.addChild(self.labelDeaths)
        
        let maxTime = Towers.types[MapManager.tower].floorTypes[MapManager.floor].maxTime
        if(Int(time) <= maxTime) {
            if(floorData.time == NSNumber(bool: false)) {
                floorData.time = NSNumber(bool: true)
            }
            self.labelTime = Label(color:GameColors.green, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
            starsCount++
        } else {
            self.labelTime = Label(color:GameColors.red, text: "\(time)s/\(maxTime)s", x: 266, y: 407)
        }
        self.addChild(self.labelTime)
        
        floorData.stars = NSNumber(integer: floorData.bonus.integerValue + floorData.deaths.integerValue + floorData.time.integerValue)
        
        print(floorData.bonus.integerValue)
        print(floorData.deaths.integerValue)
        print(floorData.time.integerValue)
        
        for(var i = 0; i <= starsCount; i++) {
            switch(i){
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
                    scene.blackSpriteNode.removeFromParent()
                    self.removeFromParent()
                }
                return
            }
            if (self.buttonRestart.containsPoint(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.mission
                    scene.blackSpriteNode.removeFromParent()
                    self.removeFromParent()
                }
                return
            }
            if (self.buttonNext.containsPoint(location)) {
                //
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.powerUp
                    scene.blackSpriteNode.removeFromParent()
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
