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
    
    
    
    //Controls
    var buttonLeft:Button!
    var buttonRight:Button!
    var buttonJump:Button!
    
    var slider:Slider!

    
    //Effect
    var labelWin:Label?
    
    enum messages : String {
        case disconnect = "q"
        case addPlayers = "a"
        case didJoin = "d"
        case join = "j"
        case joinRoom = "r"
        case update = "u"
        case bomb = "bomb"
    }
    
    var message = messages.addPlayers
    var state = states.loading
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
    var time: NSTimeInterval = 0
    var currentTime:NSTimeInterval!
    var lastReset:NSTimeInterval!
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    //Multiplayer
    var localName:String!
    //let socket = SocketIOClient(socketURL: "https://squaregame.mybluemix.net", opts: nil)
    //let socket = SocketIOClient(socketURL: "179.232.86.110:3001", opts: nil)
    var socket = SocketIOClient(socketURL: "181.41.197.181:3001", opts: nil)
    
    //var teste: NSURL
    
    var winPlayersList = Array<String>()
    
    var boxCoins:BoxCoins!
    var collectedBonus = 0 {
        didSet {
            self.boxCoins.labelCoins.setText(MemoryCard.sharedInstance.playerData.coins.description)
            PowerUp.updatePowerUpLabels()
        }
    }
    
     var powerUpsScrollNode:ScrollNode!
    
    var buttonBack:Button!
    
    
    init(socket:SocketIOClient) {
        super.init()
        self.socket = socket
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum states {
        case loading
        case mission
        case paused
        case win
        case loose
    }
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        print(PlayerOnline.playerOnlineList)
        self.backgroundColor = GameColors.blueSky
        
        Music.sharedInstance.play(musicNamed: "A New Camp.mp3")
        
        self.parallax = Parallax(imageNamed: "grassBackground")
        self.addChild(self.parallax)
        
        self.world = World(physicsWorld: self.physicsWorld)
        self.addChild(self.world)
        self.physicsWorld.contactDelegate = self
        
        self.myCamera = GameCamera()
        self.world.addChild(self.myCamera)
        
        self.player = PlayerOnline(skinId: self.playerData.skinSlot.skin.index.integerValue, x: 128, y: 128, loadPhysics: true)
        self.world.addChild(self.player)
        
        self.player.labelName = Label(text: "???")
        self.world.addChild(self.player.labelName)
        
        self.mapManager = MapManager()
        MapManager.tower = -1//TODO: altas gambs
        self.world.addChild(self.mapManager)
        
        self.mapManager.reloadMap(CGPoint(x: 10, y: 10))
        
        self.localName = MemoryCard.sharedInstance.playerData.name
        
        switch(self.playerData.configControls.integerValue) {
            
        case 1: //controlsConfig.useButtons.rawValue:
            self.buttonLeft = Button(textureName: "buttonYellowSquare", text:"<", x:20, y:626, xAlign:.left, yAlign:.down, colorBlendFactor:0.5, top:39, bottom: 39, left:39, right:39)
            
            self.addChild(self.buttonLeft)
            
            self.buttonRight = Button(textureName: "buttonYellowSquare", text:">" ,x:276, y:626, xAlign:.left, yAlign:.down, colorBlendFactor:0.5, top:39, bottom: 39, left:39, right:39)
            self.addChild(self.buttonRight)
            
            self.buttonJump = Button(textureName: "buttonYellow", text:"Jump", x:1014, y:626, xAlign:.right, yAlign:.down, colorBlendFactor:0.5, top:39, bottom: 39, left:39, right:39)
            
            self.addChild(self.buttonJump)
            break
            
        default:
            break
        }
        
        self.boxCoins = BoxCoins()
        self.addChild(self.boxCoins)
        
        if(self.playerData.powerUps.count > 0) {
            var powerUpsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                if let powerUpSlotData = item as? PowerUpSlotData {
                    if let powerUpData = powerUpSlotData.powerUp {
                        let powerUp = PowerUp(powerUpData: powerUpData, colorBlendFactor: 0.5)
                        powerUp.loadEvent(self.player, world: self.world)
                        powerUpsArray.append(powerUp)
                    }
                }
            }
            
            self.powerUpsScrollNode = ScrollNode(x: 547, y: 680, xAlign: .center, yAlign: .down, cells: powerUpsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false)
            self.powerUpsScrollNode.canScroll = false
            self.addChild(self.powerUpsScrollNode)
            
            PowerUp.updatePowerUpLabels()
        }
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"X" ,x:20, y:20, xAlign:.left, yAlign:.up)
        self.addChild(self.buttonBack)

        self.player.name = self.localName
        self.player.labelName.setText(self.localName, color: GameColors.black)
        
        for player in PlayerOnline.playerOnlineList {
            if let aux = player as PlayerOnline? {
                if let name = aux.name
                {
                    if name != self.localName {
                        print("adicionei")
                        print(aux)
                        aux.position = CGPoint(x: 200, y: 48)
                        self.world.addChild(aux)
                        
                        var labelName2: Label!
                        labelName2 = Label(text: "")
                        Control.controlList.remove(labelName2)
                        labelName2.position = CGPoint(x: aux.position.x, y: aux.position.y + 32)
                        self.world.addChild(labelName2)
                        labelName2.zPosition = aux.zPosition + 1
                        labelName2.setText(aux.name!, color: GameColors.black)
                        aux.labelName = labelName2
                    }
                }
            }
        }
        
        
        self.addHandlers()
       
    }
    
    func addHandlers(){
        
        self.socket.on("win") {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            if let name = data?[0] as? Int {
                for player in PlayerOnline.playerOnlineList {
                    if let id = player.id
                    {
                        if id == name{
                            
                            this.labelWin = Label(text: "\(player.name!) finish with \(Int(this.time)) seconds", x: 675, y: 375, xAlign: Control.xAlignments.center, yAlign: Control.yAlignments.center)
                            this.addChild(this.labelWin!)
                            this.labelWin?.runAction(SKAction.fadeOutWithDuration(2), completion: { () -> Void in
                                this.labelWin?.removeFromParent()
                                
                            })
                            this.winPlayersList.append("\(player.skin!),\(player.name!),\(Int(this.time))")
                            print(this.winPlayersList)
                            
                        
                            
                        }
                    }
                }
            }
            
        }
        
        
        
        self.socket.on("removeBoxCrateBomb") {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            print("removeBoxCrateBomb")
           
            if let boxCrateBomb = data?[0] as? Int {
                for crateBomb in BoxExplosive.boxExplosiveList {
                    if let id = crateBomb.listPosition
                    {
                        if id == boxCrateBomb{
                            
                            crateBomb.removeFromParent()
                            
                        }
                    }
                }
            }
            
        }
        
        
        
        self.socket.on("removeBomb") {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            
            print("removeBomb test")
            
            if let bomb = data?[0] as? Int {
            
                print("removeBomb" + bomb.description)
                
                
                for item in Bomb.bombList{
                    print("Bomba " + item.listPosition.description)
                    if (item.listPosition == bomb){
                        print("achei a bomba " + item.listPosition.description)
                        item.removeFromParent()
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
        
        
        self.socket.on(messages.bomb.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            print(data)
            
            if let x = data?[0] as? Int, let y = data?[1] as? Int {
                
                let bomb = BoxExplosive(position: CGPoint(x: x, y: y))
                this.world.addChild(bomb)
                
                print("bomb at " + x.description + " " + y.description )
                
                bomb.runAction({
                    let action = SKAction()
                    action.duration = 1
                    return action
                    }(), completion: { () -> Void in
                        bomb.activate()
                })
                
                
                
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
                self.time = currentTime - lastReset
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
                        
                        if (!self.powerUpsScrollNode.containsPoint(location)) {
                            if(location.x > (self.scene?.size.width)!/2) {
                                jump++
                            }
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
                
                PowerUp.doLogic(currentTime)
                
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
                self.lastReset = currentTime
                break
            case states.win:
                self.socket.emit("win", self.room)
                
                self.winPlayersList.append("\(self.playerData.skinSlot.skin.index),\(self.localName),\(Int(self.time))")
                let box = MultiplayerWinBox(background: "boxWinBackground", winPlayersList: self.winPlayersList)
                self.addChild(box)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = box.zPosition - 1
                
                break
                
            case states.loose:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultTransition)
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
                            self.slider = Slider()
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
                
                if (self.buttonBack.containsPoint(location)) {
                    self.socket.disconnect(fast: true)
                    PlayerOnline.playerOnlineList = Set<PlayerOnline>()
                    self.nextState = .loose
                    return
                }
            }
        }
    }
}
