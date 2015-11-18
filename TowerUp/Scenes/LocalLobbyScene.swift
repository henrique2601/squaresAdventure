//
//  LocalLobbyScene.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 10/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity

class LocalLobbyScene: GameScene {
    enum states {
        case loading
        case searching
        case hosting
        case waitingPlayers
        case waitingHostStart
        case lobby
        case localMission
    }
    
    var room: Int = 0
    var state = states.loading
    var nextState = states.searching
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var zeroTime: NSTimeInterval = 0
    
    var labelStatus: Label!
    
    var playerData = MemoryCard.sharedInstance.playerData
    //var mpcManager: MPCManager!

    var buttonGo: Button!
    var buttonBack:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(textureName: "lobby1Background", xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.backgroundColor = GameColors.blue
        
        self.labelStatus = Label(color: GameColors.white, text: "", x: 215, y: 328)
        self.addChild(self.labelStatus)
        
        self.buttonGo = Button(textureName: "buttonPinkSmall", text:"GO", x: 295, y: 560, fontColor:.white)
        self.buttonGo.hidden = true
        self.addChild(self.buttonGo)
        self.addChild(Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        
//        self.mpcManager = MPCManager()
//        self.mpcManager.delegate = self
//        self.mpcManager.peer = MCPeerID(displayName: self.playerData.currentSkin.index.description + " " + self.playerData.name)
//        println(self.mpcManager.peer)
//        self.mpcManager.advertiser.startAdvertisingPeer()
//        self.mpcManager.browser.startBrowsingForPeers()
        
        
        

        
    }
    

    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        if(self.state == self.nextState){
            switch (self.state) {
            case states.searching:
                
                if ((currentTime - self.zeroTime) > 10) {
                    print("Nao achei, vou hostear")
//                    appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
//                    appDelegate.mpcManager.browser.startBrowsingForPeers()
                    self.nextState = states.hosting
                }
                break
                
                
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.searching:
                
                self.zeroTime = currentTime
                self.labelStatus.setText("searching")
                break
            
            case states.hosting:
                self.buttonGo.hidden = false
                self.labelStatus.setText("hosting")
                break
                
            case states.waitingHostStart:
                self.labelStatus.setText("Waiting")
                break
                
            case states.lobby:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultTransition)
                break
                
            case states.localMission:
                self.view!.presentScene(LocalGameScene(), transition: Config.defaultTransition)
                break
                

                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        
                for touch in touches {
                    let location = touch.locationInNode(self)
                    
                    
                    if (self.state == self.nextState) {
                        switch (self.state) {
                        case states.hosting:
                            
                            if (self.buttonGo.containsPoint(location)) {
                                self.nextState = .localMission
                                return
                            }
                            
                            break
                            
                        default:
                            break
                        }
                            
                    
                    
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .lobby
                        return
                    }
                    
                    
                }
                
        }
    }
    

    
    

    
}

