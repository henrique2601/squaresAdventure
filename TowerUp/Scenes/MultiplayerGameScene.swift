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
    
    
    //Multiplayer
    var localName:String!
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
        //println( "Room " + self.room.description)
        
        
    }
    
    
    func addHandlers(){
        
        self.socket.on("addPlayers") {[weak self] data, ack in
            
            
            var xPos = 144
            
            
            self!.player = PlayerOnline(x: xPos, y: 48, loadPhysics: true)
            self!.player!.name = self?.localName
            
            //self?.localName = name
            
            self!.world.addChild(self!.player!)
            
            self!.mapManager = MapManager()
            self!.mapManager.name = "mapManager"
            self!.world.addChild(self!.mapManager);
            self!.mapManager.reloadMap(self!.player!.position)
            
            if let playersArray = data?[0] as? NSArray {
                
                //println(playersArray)
                
                for onlinePlayer in playersArray{
                    
                    let nameTest = onlinePlayer as? String
                    
                    switch nameTest! {
                    case "0":
                        xPos = 80
                    case "1":
                        xPos = 120
                    case "2":
                        xPos = 160
                    case "3":
                        xPos = 200
                    default:
                        xPos = 80
                        
                    }
                    
                    xPos = 144
                    var player2 = PlayerOnline(x: xPos, y: 48, loadPhysics: true)
                    
                    player2.name = nameTest
                    
                    player2.position = CGPoint(x: xPos, y: 48)
                    self!.world.addChild(player2)
                }
                
            }
            
            
            
            
            println("Added Players")
            
        }
        
        
        
        self.socket.on("didJoin") {[weak self] data, ack in
            self!.socket.emit("joinRoom", self!.localName! , self!.room)
        }
        
        
        self.socket.on("join") {[weak self] data, ack in
            if let name = data?[0] as? String {
                
                println(name + "Join")
                
                var xPos = 144
                var player = PlayerOnline(x: xPos, y: 48, loadPhysics: true)
                player.name = name
                
                player.position = CGPoint(x: xPos, y: 48)
                
                self!.world.addChild(player)
            }
            
            println("teste")
            
        }
        
        self.socket.on("update") {[weak self] data, ack in
            //println("teste")
            if let name = data?[0] as? String{
                
                
                if let player = self?.childNodeWithName("//\(name)") as? PlayerOnline {
                    //println("teste2")
                    player.updateOnline(data?[1] as! CGFloat, y: data?[2] as! CGFloat, vx: data?[3] as! CGFloat, vy: data?[4] as! CGFloat, rotation: data?[5] as! CGFloat, vrotation: data?[6] as! CGFloat)
                    
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
        if(self.state == self.nextState){
            switch (self.state) {
            case states.mission:
                if let player = self.player {
                    player.update(currentTime, room: self.room)
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
