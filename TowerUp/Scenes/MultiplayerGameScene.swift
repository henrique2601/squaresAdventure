//
//  MultiplayerGameScene.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 18/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MultiplayerGameScene: GameScene, SKPhysicsContactDelegate {
    enum states {
        case mission
        case paused
        case afterMission
    }
    
    enum messages : String {
        case addPlayers = "a"
        case didJoin = "d"
        case join = "j"
        case joinRoom = "r"
        case update = "u"
    }
    
    var message = messages.addPlayers
    var state = states.mission
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    var world:World!
    var camera:Camera!
    var player:PlayerOnline?
    var mapManager:MapManager!
    var parallax:Parallax!
    var room:Int = 0
    let velo:CGFloat = 3
    var currentTime: NSTimeInterval = 0
    
    
    //Multiplayer
    var localName:String!
    var labelName: Label!
    let socket = SocketIOClient(socketURL: "179.232.86.110:3001", opts: nil)
    
    
    
    
    
    
    
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
        
        self.mapManager = MapManager()
        self.world.addChild(self.mapManager)
        
        
        self.addChild(Button(name: "buttonLeft", textureName: "buttonYellowSquare", text:"<", x:20, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonRight", textureName: "buttonYellowSquare", text:">" ,x:160, y:630, xAlign:.left, yAlign:.down))
        self.addChild(Button(name: "buttonJump", textureName: "buttonYellow", text:"Jump", x:1014, y:630, xAlign:.right, yAlign:.down))
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"||" ,x:20, y:20, xAlign:.left, yAlign:.up))
        
        
        
        //Multiplayer
        self.socket.connect()
        
        self.addHandlers()
        
        message = .addPlayers
        println(message)
        
        
    }
    
    
    func addHandlers(){
        
        
        self.socket.on(messages.addPlayers.rawValue) {[weak self] data, ack in
            
            
            var xPos = 144
            
            self!.player = PlayerOnline(x: xPos, y: 48, loadPhysics: true)
            self!.player!.name = self?.localName
            self!.world.addChild(self!.player!)
            
            
            self!.labelName = Label(name: "labelName", textureName: "", x: 0, y: 0)
            Control.locations.removeObject("labelName")
            self!.labelName.position = CGPoint(x: self!.player!.position.x, y: self!.player!.position.y + 32)
            self!.world.addChild(self!.labelName)
            self!.labelName.zPosition = self!.player!.zPosition + 1
            self!.labelName.setText(self!.localName!, color: GameColors.black)
            self!.player?.labelName = self!.labelName
            
            
            
            
            self!.mapManager = MapManager()
            self!.mapManager.name = "mapManager"
            self!.world.addChild(self!.mapManager);
            self!.mapManager.reloadMap(self!.player!.position)
            
            //println(data?[0])
            
            if let playersArray = data?[0] as? NSArray {
                
               

               for onlinePlayer in playersArray{
                
                    let nameTest = onlinePlayer as? NSDictionary
                    //println (nameTest?.objectForKey("name"))
                    
                    
                    xPos = 144
                    var player2 = PlayerOnline(x: xPos, y: 48, loadPhysics: true)
                    player2.name = nameTest!.objectForKey("name") as? String
                    player2.id = nameTest!.objectForKey("id") as? Int
                    player2.position = CGPoint(x: xPos, y: 48)
                    self!.world.addChild(player2)
                    
                    var labelName2: Label!
                    labelName2 = Label(name: "label"+player2.name! , textureName: "", x: 0, y: 0)
                    Control.locations.removeObject("label" + player2.name!)
                    labelName2.position = CGPoint(x: player2.position.x, y: player2.position.y + 32)
                    self!.world.addChild(labelName2)
                    labelName2.zPosition = player2.zPosition + 1
                    labelName2.setText(player2.name!, color: GameColors.black)
                    player2.labelName = labelName2
                    
                }
                
            }
            
            
            
            
            println("Added Players")
            
        }
        
        
        
        self.socket.on(messages.didJoin.rawValue) {[weak self] data, ack in
            self!.socket.emit(messages.joinRoom.rawValue, self!.localName! , self!.room)
        }
        
        
        self.socket.on(messages.join.rawValue) {[weak self] data, ack in
            if let name = data?[0] as? String {
                
                
                
                var xPos = 144
                var player = PlayerOnline(x: xPos, y: 48, loadPhysics: true)
                player.name = name
                player.position = CGPoint(x: xPos, y: 48)
                self!.world.addChild(player)
                
                var labelName2: Label!
                labelName2 = Label(name: "label"+player.name! , textureName: "", x: 0, y: 0)
                Control.locations.removeObject("label" + player.name!)
                labelName2.position = CGPoint(x: player.position.x, y: player.position.y + 32)
                self!.world.addChild(labelName2)
                labelName2.zPosition = player.zPosition + 1
                labelName2.setText(player.name!, color: GameColors.black)
                
                player.labelName = labelName2
                
            }
            
            println("teste")
            
        }
        
        self.socket.on(messages.update.rawValue) {[weak self] data, ack in
            
            if let name = data?[0] as? Int {
                
                
                for player in PlayerOnline.list {
                    
                    if let aux = player as? PlayerOnline {
                        if let id = aux.id
                        {
                            if id == name{
                                aux.updateOnline(data?[1] as! CGFloat, y: data?[2] as! CGFloat, vx: data?[3] as! CGFloat, vy: data?[4] as! CGFloat, rotation: data?[5] as! CGFloat, vrotation: data?[6] as! CGFloat )
                                aux.labelName.position = CGPoint(x: player.position.x, y: player.position.y + 32)
                            }
                        }
                    }
                    
                    
                }
                
                
                
                
                
            }
        }
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
                if let player = self.player {
                    player.update(currentTime)
                    self.mapManager.update(currentTime)
                }
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                break
            case states.afterMission:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultGoTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func didFinishUpdate()
    {
        if let player = self.player {
            self.camera.update(self.player!.position)
            player.updateEmiter(self.currentTime, room: self.room)
            //self.player!.labelName.position = CGPoint(x: self.player!.position.x, y: self.player!.position.y + 32)
            self.player!.didFinishUpdate()
            self.parallax.update(self.camera.position)
        }
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
