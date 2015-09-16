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

class LocalLobbyScene: GameScene, MPCManagerDelegate {
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
    var buttonGo: Button!
    var labelStatus: Label!

    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(name: "lobby1Background", x:0, y:0, align:.center))
        self.backgroundColor = GameColors.blue
        
        self.labelStatus = Label(name: "Status", color: GameColors.white, x: 215, y: 328)
        self.addChild(self.labelStatus)
        
        self.buttonGo = Button(name: "buttonGo", textureName: "buttonYellowSmall", text:"GO", x: 295, y: 560, align:.center)
        self.buttonGo.hidden = true
        self.addChild(self.buttonGo)
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        
        

        
    }
    

    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
            case states.searching:
                
                if ((currentTime - self.zeroTime) > 10) {
                    println("Nao achei, vou hostear")
                    appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
                    appDelegate.mpcManager.browser.startBrowsingForPeers()
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
                self.view!.presentScene(LobbyScene(), transition: Config.defaultBackTransition)
                break
                
            case states.localMission:
                self.view!.presentScene(LocalGameScene(), transition: Config.defaultBackTransition)
                break
                

                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.lobby:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    
                    if (self.childNodeWithName("Go")!.containsPoint(location)) {
                        room = 2
                        self.nextState = .localMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        self.nextState = .lobby
                        return
                    }
                    
                    
                }
                break
                
            default:
                break
            }
        }
    }
    
    
    func connectedWithPeer(peerID: MCPeerID) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            println("Conectado a " + peerID.displayName)
            self.nextState = .waitingHostStart
        }
    }

    
}
