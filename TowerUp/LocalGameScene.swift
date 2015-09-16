//
//  LocalGameScene.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 09/09/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit
import MultipeerConnectivity

class LocalGameScene: GameScene, SKPhysicsContactDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    enum states {
        case loading
        case mission
        case paused
        case afterMission
    }
    
    //Effect
    var blackSpriteNode:SKSpriteNode!
    
    enum messages : String {
        case disconnect = "q"
        case addPlayers = "a"
        case didJoin = "d"
        case join = "j"
        case joinRoom = "r"
        case update = "u"
    }
    
    var message = messages.addPlayers
    var state = states.loading
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    var world:World!
    var camera:Camera!
    var player:PlayerOnline!
    var mapManager:MapManager!
    var parallax:Parallax!
    var room:Int = 0
    let velo:CGFloat = 3
    var currentTime: NSTimeInterval = 0
    var zeroTime: NSTimeInterval = 0
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    //Multiplayer
    var localName:String!
    var numUpdates = 0
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
        
        self.player = PlayerOnline(skinId: self.playerData.currentSkin.index.integerValue, x: 200, y: 100, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.player.labelName = Label(name: "labelName", textureName: "", x: 0, y: 0)
        self.world.addChild(self.player.labelName)
        
        self.mapManager = MapManager()
        MapManager.tower = -1//TODO: altas gambs
        MapManager.floor = 1//TODO: altas gambs
        self.world.addChild(self.mapManager)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: Chunk.sizeInPoints + 10))
        
        self.addChild(Button(name: "buttonLeft", textureName: "buttonYellowSquare", text:"<", x:20, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonRight", textureName: "buttonYellowSquare", text:">" ,x:160, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonJump", textureName: "buttonYellow", text:"Jump", x:1014, y:630, xAlign:.right, yAlign:.down))
        
        self.addChild(Button(name: "buttonPowerUp0", textureName: "buttonBlueSquare", text:"1", x: 497, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp1", textureName: "buttonOrangeSquare", text:"2", x: 617, y: 630, xAlign:.center, yAlign:.down))
        self.addChild(Button(name: "buttonPowerUp2", textureName: "buttonYellowSquare", text:"3", x: 737, y: 630, xAlign:.center, yAlign:.down))
        
        self.boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.boxCoins.addChild(Label(name: "lebelCoins", color: GameColors.black, textureName: "0", x: 160, y: 39))
        self.addChild(self.boxCoins)
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"||" ,x:20, y:20, xAlign:.left, yAlign:.up))
        
        //self.mpcManager.browser.startBrowsingForPeers()
        //self.mpcManager.advertiser.startAdvertisingPeer()
        
        let UTCDate = NSDate()
        println(UTCDate)
        
        self.addHandlers()
        
    }
    
    func addHandlers(){
        

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        world.didBeginContact(contact)
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        world.didEndContact(contact)
    }
    
    override func update(currentTime: NSTimeInterval) {
        self.currentTime = currentTime
        if(self.state == self.nextState){
            switch (self.state) {
            case states.mission:
                self.player.update(currentTime)
                self.mapManager.update(currentTime)
                //println(currentTime - self.zeroTIme)
                
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                self.zeroTime = currentTime
                break
            case states.afterMission:
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: self.size)
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                let box = MultiplayerWinBox(background: "boxWhite", name:"You Win!!")
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                break
                
            default:
                break
            }
        }
    }
    
    override func didFinishUpdate() {
        if(self.player.healthPoints > 0){
            self.camera.update(self.player.position)
        }
        self.player.updateEmiter(self.currentTime, room: self.room)
        self.player.didFinishUpdate()
        self.parallax.update(self.camera.position)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            for touch in (touches as! Set<UITouch>) {
                let location = touch.locationInNode(self)
                
                if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                    
                    
                    
                    self.nextState = .afterMission
                    return
                }
            }
        }
    }
}
