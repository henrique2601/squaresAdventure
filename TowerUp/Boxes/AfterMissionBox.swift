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
    
    init(background: String, time:String, deaths:String, bonus:String) {
        super.init(background: background)
        
        self.addChild(Button(name: "buttonExit", textureName: "buttonGraySquare", text:"X", x: 98, y: 590))
        self.addChild(Button(name: "buttonRestart", textureName: "buttonBlueSquare", text:"R", x: 238, y: 590))
        self.addChild(Button(name: "buttonNext", textureName: "buttonBlueSquare", text:"N",x: 378, y: 590))
        
        let aux = Int.random(4)//TODO: numero de estrelas baseado no desempenho do jogador.
        for(var i = 0; i <= aux; i++){
            switch(i){
            case 0:
                break
            case 1:
                self.addChild(Control(name: "star1", textureName: "starBig", x: 76, y: 40))
                break
            case 2:
                self.addChild(Control(name: "star2", textureName: "starBig", x: 224, y: 40))
                break
            case 3:
                self.addChild(Control(name: "star3", textureName: "starBig", x: 372, y: 40))
                break
                
            default:
                break
            }
        }
        
        self.labelTime = Label(name: "labelTime", color:GameColors.black, textureName: "Time \(time)s", x: 288, y: 226)
        self.addChild(self.labelTime)
        
        self.labelDeaths = Label(name: "labelDeaths", color:GameColors.black, textureName: "Deaths \(deaths)", x: 288, y: 366)
        self.addChild(self.labelDeaths)
        
        self.labelBonus = Label(name: "labelBonus", color:GameColors.black, textureName: "Coins \(bonus)", x: 288, y: 506)
        self.addChild(self.labelBonus)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if (self.childNodeWithName("buttonExit")!.containsPoint(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.floors
                    scene.blackSpriteNode.removeFromParent()
                    self.removeFromParent()
                }
                return
            }
            if (self.childNodeWithName("buttonRestart")!.containsPoint(location)) {
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.mission
                    scene.blackSpriteNode.removeFromParent()
                    self.removeFromParent()
                }
                return
            }
            if (self.childNodeWithName("buttonNext")!.containsPoint(location)) {
                //
                if let scene = self.scene as? MissionScene {
                    scene.nextState = MissionScene.states.powerUp
                    scene.blackSpriteNode.removeFromParent()
                    self.removeFromParent()
                    MapManager.floor++
                    
                    var towerIndex = 0
                    for tower in MemoryCard.sharedInstance.playerData.towers {
                        if(MapManager.tower == towerIndex) {
                            //Encontrou torre selecionada
                            let towerType = Towers.types[towerIndex]
                            if(MapManager.floor >= towerType.floorCount) {
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
