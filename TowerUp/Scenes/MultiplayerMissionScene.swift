//
//  MultiplayerGameScene.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 18/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MultiplayerMissionScene: GameScene, SKPhysicsContactDelegate {
    enum states {
        case mission
        case paused
        case win
        case loose
    }
    
    //Controls
    var buttonLeft:Button!
    var buttonRight:Button!
    var buttonJump:Button!
    
    var slider:Slider!
    
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
    var state = states.mission
    var nextState = states.mission
    
    var xPos = 500
    var yPos = 200
    var world:World!
    var myCamera:GameCamera!
    var player:PlayerOnline!
    var mapManager:MapManager!
    var parallax:Parallax!
    var room:Int = 0
    let velo:CGFloat = 3
    var currentTime: NSTimeInterval = 0
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    //Multiplayer
    var localName:String!
    //let socket = SocketIOClient(socketURL: "https://squaregame.mybluemix.net", opts: nil)
    //let socket = SocketIOClient(socketURL: "179.232.86.110:3001", opts: nil)
    let socket = SocketIOClient(socketURL: "181.41.197.181:3001", opts: nil)
    
    var labelCoins:Label!
    var collectedBonus = 0 {
        didSet {
            self.labelCoins.setText(MemoryCard.sharedInstance.playerData.coins.description)
            PowerUp.updatePowerUpLabels()
        }
    }
    
     var powerUpsScrollNode:ScrollNode!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blueSky
        
        self.parallax = Parallax(imageNamed: "grassBackground")
        self.addChild(self.parallax)
        
        self.world = World(physicsWorld: self.physicsWorld)
        self.addChild(self.world)
        self.physicsWorld.contactDelegate = self
        
        self.myCamera = GameCamera()
        self.world.addChild(self.myCamera)
        
        self.player = PlayerOnline(skinId: self.playerData.skinSlot.skin.index.integerValue, x: 200, y: 100, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.player.labelName = Label(name: "labelName", textureName: "???", x: 0, y: 0)
        self.world.addChild(self.player.labelName)
        
        self.mapManager = MapManager()
        MapManager.tower = -1//TODO: altas gambs
        MapManager.floor = 1//TODO: altas gambs
        self.world.addChild(self.mapManager)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: Chunk.sizeInPoints + 10))
        
        switch(self.playerData.configControls.integerValue) {
            
        case 1: //controlsConfig.useButtons.rawValue:
            self.buttonLeft = Button(name: "buttonLeft", textureName: "buttonYellowSquare", text:"<", x:20, y:630, xAlign:.left, yAlign:.down)
            self.addChild(self.buttonLeft)
            
            self.buttonRight = Button(name: "buttonRight", textureName: "buttonYellowSquare", text:">" ,x:160, y:630, xAlign:.left, yAlign:.down)
            self.addChild(self.buttonRight)
            
            self.buttonJump = Button(name: "buttonJump", textureName: "buttonYellow", text:"Jump", x:1014, y:630, xAlign:.right, yAlign:.down)
            self.addChild(self.buttonJump)
            break
            
        default:
            break
        }
        
        let boxCoins = Control(name: "boxCoins", textureName: "boxCoins", x: 1058, y: 20, xAlign: .right, yAlign: .up)
        self.labelCoins = Label(name: "lebelCoins", color: GameColors.black, textureName: self.playerData.coins.description, x: 160, y: 39)
        boxCoins.addChild(self.labelCoins)
        self.addChild(boxCoins)
        
        if(self.playerData.powerUps.count > 0) {
            var powerUpsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                if let powerUpSlotData = item as? PowerUpSlotData {
                    if let powerUpData = powerUpSlotData.powerUp {
                        let powerUp = PowerUp(powerUpData: powerUpData)
                        powerUp.loadEvent(self.player)
                        powerUpsArray.append(powerUp)
                    }
                }
            }
            
            self.powerUpsScrollNode = ScrollNode(name: "powerUpSlotsScrollNode", textureName: "", x: 667, y: 680, xAlign: .center, yAlign: .down, cells: powerUpsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false)
            self.powerUpsScrollNode.canScroll = false
            self.addChild(self.powerUpsScrollNode)
            
            PowerUp.updatePowerUpLabels()
        }
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", text:"X" ,x:20, y:20, xAlign:.left, yAlign:.up))
        
        //Multiplayer
        self.socket.connect()
        
        self.addHandlers()
       
    }
    
    func addHandlers(){
        
        self.socket.on(messages.addPlayers.rawValue) {[weak self] data, ack in
            
            self!.player.name = self!.localName
            
            self!.player.labelName.position = CGPoint(x: self!.player!.position.x, y: self!.player!.position.y + 32)
            self!.player.labelName.zPosition = self!.player!.zPosition + 1
            self!.player.labelName.setText(self!.localName!, color: GameColors.black)
            
            
            
            
            if let playersArray = data?[0] as? NSArray {
                for onlinePlayer in playersArray {
                    let nameTest = onlinePlayer as? NSDictionary
                    
                    var test = 0
                    
                    for player in PlayerOnline.playerOnlineList {
                        if let aux = player as PlayerOnline? {
                            if let id = aux.id
                            {
                                if id == nameTest!.objectForKey("id") as? Int{
                                    test++
                                }
                            }
                        }
                    }
                    
                    if (test == 0) {
                        
                        print(nameTest)
                        
                        let skin = nameTest!.objectForKey("skin") as? Int
                        let player2 = PlayerOnline(skinId: skin! ,x: 200, y: 48, loadPhysics: true)
                        player2.name = nameTest!.objectForKey("name") as? String
                        player2.id = nameTest!.objectForKey("id") as? Int
                        player2.position = CGPoint(x: 200, y: 48)
                        self!.world.addChild(player2)
                        
                        var labelName2: Label!
                        labelName2 = Label(name: "label"+player2.name! , textureName: "", x: 0, y: 0)
                        Control.controlList.remove(labelName2)
                        labelName2.position = CGPoint(x: player2.position.x, y: player2.position.y + 32)
                        self!.world.addChild(labelName2)
                        labelName2.zPosition = player2.zPosition + 1
                        labelName2.setText(player2.name!, color: GameColors.black)
                        player2.labelName = labelName2
                    }
                }
            }
            print("Added Players")
        }
        
        self.socket.on("win") {[weak self] data, ack in
            if let name = data?[0] as? Int {
                for player in PlayerOnline.playerOnlineList {
                    if let id = player.id
                    {
                        if id == name{
                            print(player.name! + " win")
                            self!.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: self!.size)
                            self!.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                            self!.addChild(self!.blackSpriteNode)
                            let box = MultiplayerWinBox(background: "boxWhite", name:player.name! + " win!!!")
                            self!.addChild(box)
                            
                            self!.blackSpriteNode.zPosition = box.zPosition - 1
                            self!.nextState = states.loose
                            
                        }
                    }
                }
            }
            
        }
        
        self.socket.on(messages.disconnect.rawValue) {[weak self] data, ack in
            if let name = data?[0] as? Int {
                
                for player in PlayerOnline.playerOnlineList {
                    if let aux = player as PlayerOnline? {
                        if let id = aux.id
                        {
                            if id == name{
                                aux.removeFromParent()
                            }
                        }
                    }
                }
            }
        }
        
        self.socket.on(messages.didJoin.rawValue) {[weak self] data, ack in
            self!.socket.emit(messages.joinRoom.rawValue, self!.localName! , self!.room, self!.playerData.skinSlot.skin.index.integerValue)
        }
        
        self.socket.on(messages.join.rawValue) {[weak self] data, ack in
            
            if let name = data?[0] as? NSDictionary {
                
                let xPos = 144
                let skin = name.objectForKey("skin") as? Int
                let player = PlayerOnline(skinId: skin!, x: xPos, y: 48, loadPhysics: true)
                player.name = name.objectForKey("name") as? String
                print(player.name)
                player.id = name.objectForKey("id") as? Int
                print(player.id.description)
                player.position = CGPoint(x: xPos, y: 48)
                self!.world.addChild(player)
                
                var labelName2: Label!
                labelName2 = Label(name: "label"+player.name! , textureName: "", x: 0, y: 0)
                Control.controlList.remove(labelName2)
                labelName2.position = CGPoint(x: player.position.x, y: player.position.y + 32)
                self!.world.addChild(labelName2)
                labelName2.zPosition = player.zPosition + 1
                labelName2.setText(player.name!, color: GameColors.black)
                
                player.labelName = labelName2
            }
        }
        
        self.socket.on(messages.update.rawValue) {[weak self] data, ack in
            
            if let name = data?[0] as? Int {
                for player in PlayerOnline.playerOnlineList {
                    if let aux = player as PlayerOnline? {
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
                PowerUp.doLogic(currentTime)
                switch(self.playerData.configControls.integerValue) {
                case 1: //controlsConfig.useButtons.rawValue:
                    self.player.jump = self.buttonJump.pressed
                    
                    self.player.move = 0
                    if(self.buttonLeft.pressed) {
                        self.player.move += -100
                    }
                    if(self.buttonRight.pressed) {
                        self.player.move += 100
                    }
                    break
                case 2: //controlsConfig.useLeftSliderAndScreenRight:
                    
                    var jump = 0
                    for touch in Control.touchesArray {
                        let location = touch.locationInNode(self)
                        
                        if(location.x > (self.scene?.size.width)!/2) {
                            jump++
                        }
                    }
                    
                    if(self.slider != nil) {
                        var x = Int(self.slider.touch.locationInNode(self).x) - Int(self.slider.position.x)
                        if(x > self.slider.limit) {
                            x = self.slider.limit
                        }
                        if(x < -self.slider.limit) {
                            x = -self.slider.limit
                        }
                        let y = Int(self.slider.thumbSpriteNode.position.y)
                        self.slider.thumbSpriteNode.position = CGPoint(x: x, y: y)
                        self.player.move = Int(100.0 * (Float(x) / Float(self.slider.limit)))
                    } else {
                        self.player.move = 0
                    }
                    self.player.jump = jump > 0
                    
                    break
                default:
                    break
                }
                self.player.update(currentTime)
                self.mapManager.update(currentTime)
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.mission:
                break
            case states.win:
                self.socket.emit("win", self.room)
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: self.size)
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                let box = MultiplayerWinBox(background: "boxWhite", name:"You Win!!")
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                break
                
            case states.loose:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultGoTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func didFinishUpdate() {
        if(self.player.healthPoints > 0){
            self.myCamera.update(self.player.position)
        }
        self.player.updateEmiter(self.currentTime, room: self.room)
        self.player.didFinishUpdate()
        self.parallax.update(self.myCamera.position)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        switch(self.playerData.configControls.integerValue) {
        case 2: //controlsConfig.useLeftSliderAndScreenRight.rawValue:
            if (self.state == self.nextState) {
                for touch in touches {
                    
                    let location = touch.locationInNode(self)
                    
                    if(self.slider == nil) {
                        if(location.x < (self.scene?.size.width)!/2) {
                            self.slider = Slider(name: "slider", x: 0, y: 0, align:.center)
                            self.slider.touch = touch
                            self.addChild(self.slider)
                            self.slider.position = location
                        }
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        switch(self.playerData.configControls.integerValue) {
        case 2: //controlsConfig.useLeftSliderAndScreenRight.rawValue:
            if Control.touchesArray.count <= 0 {
                if let slider = self.slider {
                    slider.removeFromParent()
                    self.slider = nil
                }
            } else {
                if let slider = self.slider {
                    for touch in touches {
                        if (slider.touch == touch) {
                            slider.removeFromParent()
                            self.slider = nil
                        }
                    }
                }
            }
            break
        default:
            break
        }
        
        if (self.state == self.nextState) {
            for touch in (touches ) {
                let location = touch.locationInNode(self)
                
                if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                    self.nextState = .loose
                    return
                }
            }
        }
    }
}