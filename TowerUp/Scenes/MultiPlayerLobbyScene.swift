//
//  MultiPlayerLobbyScene.swift
//  Squares Adventure
//
//  Created by Paulo Henrique dos Santos on 13/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MultiPlayerLobbyScene: GameScene, UITextFieldDelegate {
    
    enum states {
        case loading
        case searching
        case connecting
        case multiPlayerLobby
        case choosePowerUps
        case chooseSkin
        case multiplayerMission
        case lobby
    }
    
    enum messages : String {
        case disconnect = "q"
        case addPlayers = "a"
        case didJoin = "d"
        case join = "j"
        case joinRoom = "r"
        case update = "u"
    }
    
    var server: String = "nao"
    var message = messages.addPlayers
    
    var room: Int = 0
    //let socket = SocketIOClient(socketURL: "179.232.86.110:3001", opts: nil)
    
    var myTextField: Textfield!
    var playerData = MemoryCard.sharedInstance.playerData
    
    var buttonBack:Button!
    
    var state = states.loading
    var nextState = states.searching
    
    var boxCoins:BoxCoins!
    
    var player:Player!
    var powerUpSlotsScrollNode:ScrollNode!
    
    var skinsScrollNode:ScrollNode!
    var powerUpsScrollNode:ScrollNode!
    var blackSpriteNode:SKSpriteNode!
    
    var mySkins = NSMutableArray()//Skins Desbloqueadas/Compradas
    
    
    var socket = SocketIOClient(socketURL: "teste", opts: nil)
    
    
    
    func addHandlers(){
        
        self.socket.on(messages.addPlayers.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            print(data?[0])
            
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
                        let player2 = PlayerOnline(skinId: skin! ,x: 128, y: 128, loadPhysics: true)
                        player2.name = nameTest!.objectForKey("name") as? String
                        player2.id = nameTest!.objectForKey("id") as? Int
                        player2.position = CGPoint(x: 200, y: 48)
                        this.world.addChild(player2)
                        
                        var labelName2: Label!
                        labelName2 = Label(text: "")
                        Control.controlList.remove(labelName2)
                        labelName2.position = CGPoint(x: player2.position.x, y: player2.position.y + 32)
                        this.world.addChild(labelName2)
                        labelName2.zPosition = player2.zPosition + 1
                        labelName2.setText(player2.name!, color: GameColors.black)
                        player2.labelName = labelName2
                    }
                }
            }
            print("Added Players")
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
            
            guard let this = self else {
                return
            }
            
            this.socket.emit(messages.joinRoom.rawValue, this.localName! , this.playerData.skinSlot.skin.index.integerValue)
        }
        
        self.socket.on(messages.join.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            if let name = data?[0] as? NSDictionary {
                
                let xPos = 128
                let skin = name.objectForKey("skin") as? Int
                let player = PlayerOnline(skinId: skin!, x: xPos, y: 128, loadPhysics: true)
                player.name = name.objectForKey("name") as? String
                print(player.name)
                player.id = name.objectForKey("id") as? Int
                print(player.id.description)
                player.position = CGPoint(x: xPos, y: 48)
                this.world.addChild(player)
                
                var labelName2: Label!
                labelName2 = Label(text: "")
                Control.controlList.remove(labelName2)
                labelName2.position = CGPoint(x: player.position.x, y: player.position.y + 32)
                this.world.addChild(labelName2)
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

    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(textureName: "mainMenuBackground", z: -1001, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        self.addChild(Control(textureName: "lobby2", z: -1000, xAlign: .center, yAlign: .center))
        self.backgroundColor = GameColors.blue
        
        self.myTextField = Textfield(name: self.playerData.name , x: 820, y: 270, align:.center, view:self.view!)
        self.myTextField.myTextField.delegate = self
        self.addChild(self.myTextField)
        
        if(self.playerData.powerUps.count > 0) {
            var powerUpSlotsArray = Array<SKNode>()
            
            for item in self.playerData.powerUpSlots {
                powerUpSlotsArray.append(PowerUpSlot(powerUpSlotData: item as! PowerUpSlotData))
            }
            
            self.powerUpSlotsScrollNode = ScrollNode(x: 970, y: 610, xAlign: .center, yAlign: .center, cells: powerUpSlotsArray, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: false, index:1)
            self.powerUpSlotsScrollNode.canScroll = false
            self.addChild(self.powerUpSlotsScrollNode)
        }
        
        
        self.boxCoins = BoxCoins()
        self.addChild(boxCoins)
        
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        
        
        
        
    }
    
    
    
    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    //do anything befor keyboard go away
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        self.playerData.name = textField.text!
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        return newLength <= 20 // Bool
    }
    
    

    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
            
                
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
                
            case states.searching:
                
                if ( Reachability.isConnectedToNetwork() ){
                    ServerManager.sharedInstance.bestServer { serverStr in
                        self.server = serverStr
                        print(self.server)
                        self.nextState = .connecting
                    }
                } else {
                    let box = MessageBox(text: "You not connect to internet", textureName: "messegeBox", type: MessageBox.messageType.OK)
                    box.touchesEndedAtButtonOK.addHandler({
                        self.nextState = .lobby
                    })
                    
                    let size = self.size.width > self.size.height ? self.size.width : self.size.height
                    self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: CGSize(width: size * 2, height: size * 2))
                    self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                    self.addChild(self.blackSpriteNode)
                    self.addChild(box)
                    self.myTextField.myTextField.hidden = true
                    self.powerUpSlotsScrollNode.removeFromParent()
                    
                }
                
                
                
                
                break
                
            case states.connecting:
                self.socket.socketURL = self.server
                socket.connect()
                self.addHandlers()
                break
                
            case states.chooseSkin:
                self.player.removeFromParent()
                
                var skinsArray = Array<SKNode>()
                self.mySkins = NSMutableArray()
                
                //Skins desbloqueadas
                for skin in self.playerData.skins as! Set<SkinData> {
                    self.mySkins.addObject(skin.index.description)//Gravando indices das minhas skins
                    
                    let cell = SKSpriteNode(imageNamed: "boxSmall")
                    cell.name = String(skin.index.description)
                    
                    let skinType = Skins.types[skin.index.integerValue]
                    
                    let spriteNodeSkin = SKSpriteNode(imageNamed: skinType.imageName)
                    spriteNodeSkin.zPosition = cell.zPosition + 1
                    cell.addChild(spriteNodeSkin)
                    
                    //cell.addChild(Label(name: "lebelName", color:GameColors.black, textureName: "", x: 0, y: -100))
                    
                    //cell.addChild(Label(name: "lebelPrice", color:GameColors.black, textureName: skinType.price.description, x: 0, y: 100))
                    
                    skinsArray.append(cell)
                }
                
                //Skins bloqueadas
                var skinIndex = 0
                for skinType in Skins.types {
                    if(!self.mySkins.containsObject(skinIndex.description)) {
                        let cell = SKSpriteNode(imageNamed: "boxSmall")
                        cell.name = skinIndex.description
                        
                        let spriteNodeSkin = SKSpriteNode(imageNamed: skinType.imageName)
                        spriteNodeSkin.color = GameColors.black
                        
                        cell.addChild(spriteNodeSkin)
                        spriteNodeSkin.zPosition = 1
                        
                        let spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
                        cell.addChild(spriteNodeBox)
                        spriteNodeBox.zPosition = 2
                        
                        
                        var spriteNodeIcon:SKSpriteNode!
                        if (skinType.buyWithCoins == true) {
                            spriteNodeIcon = SKSpriteNode(imageNamed: "hudCoin")
                            spriteNodeSkin.colorBlendFactor = 0.9
                        } else {
                            spriteNodeIcon = SKSpriteNode(imageNamed: "hudJewel_blue")
                            spriteNodeSkin.colorBlendFactor = 0.5
                        }
                        
                        spriteNodeIcon.position = CGPoint(x: -32, y: -32)
                        cell.addChild(spriteNodeIcon)
                        spriteNodeIcon.zPosition = 3
                        
                        cell.addChild(Label(color:GameColors.white, text: "?", x: 0, y: 0))
                        
                        cell.addChild(Label(color:GameColors.white, text: skinType.price.description, x: 64, y: 64))
                        
                        skinsArray.append(cell)
                    }
                    skinIndex++
                }
                
                //Skin misteriosa =}
                let cell = SKSpriteNode(imageNamed: "boxSmall")
                cell.name = skinIndex.description
                
                let spriteNodeBox = SKSpriteNode(imageNamed: "boxSmallLocked")
                cell.addChild(spriteNodeBox)
                
                cell.addChild(Label(color:GameColors.white, text: "?"))
                
                skinsArray.append(cell)
                //
                
                let size = self.size.width > self.size.height ? self.size.width : self.size.height
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: CGSize(width: size * 2, height: size * 2))
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                
                
                
                self.skinsScrollNode = ScrollNode(x: 836, y: 466, cells: skinsArray, spacing: 0, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: true, scaleDistance:1334/4 + 100)
                self.addChild(skinsScrollNode)
                
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.skinsScrollNode.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.myTextField.myTextField.hidden = true
                
                
                break
                
                
            case states.choosePowerUps:
                self.player.removeFromParent()
                
                var powerUpsArray = Array<PowerUp>()
                
                //PowerUps desbloqueados
                for item in self.playerData.powerUps {
                    let powerUp = PowerUp(powerUpData: item as! PowerUpData)
                    for item in self.powerUpSlotsScrollNode.cells {
                        if let powerUpSlot = item as? PowerUpSlot {
                            if powerUpSlot.powerUpSlotData.powerUp?.index == powerUp.powerUpData.index {
                                powerUp.inUse = true
                                break
                            }
                        }
                    }
                    powerUpsArray.append(powerUp)
                }
  
                
                self.powerUpsScrollNode = ScrollNode(x: 970, y: 436, cells: powerUpsArray, scrollDirection: .horizontal, scaleNodes: false, scaleDistance:100)
                self.addChild(self.powerUpsScrollNode)
                
                break
                
            case states.multiPlayerLobby:
                self.player = Player(playerData: self.playerData, x: 970, y: 459, loadPhysics: false)
                self.addChild(self.player)
                
                self.myTextField.myTextField.hidden = false
                
                if let teste = self.skinsScrollNode {
                    teste.removeFromParent()
                }
                if let teste = self.powerUpsScrollNode {
                    teste.removeFromParent()
                }
                
                if let teste = self.blackSpriteNode {
                    teste.removeFromParent()
                }
                break
                
            case states.lobby:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultBackTransition)
                break
                
            case states.multiplayerMission:
                let nextScene = MultiplayerMissionScene()
                nextScene.room = self.room
                nextScene.localName = self.myTextField.myTextField.text
                self.view!.presentScene(nextScene, transition: Config.defaultGoTransition)
                break
                
                
                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.multiPlayerLobby:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                  
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = states.lobby
                        return
                    }
                    
                    if (self.player.containsPoint(location)) {
                        self.nextState = .chooseSkin
                        return
                    }
                    
                    if(self.playerData.powerUps.count > 0) {
                        if(self.powerUpSlotsScrollNode.containsPoint(location)) {
                            self.nextState = .choosePowerUps
                            return
                        }
                    }
                    
                    
                }
                break
                
            case states.chooseSkin:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .multiPlayerLobby
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.skinsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.skinsScrollNode)
                            
                            for skin in self.skinsScrollNode.cells {
                                if(skin.containsPoint(locationInScrollNode)) {
                                    if(!self.mySkins.containsObject(skin.name!)) {
                                        let cellIndex:Int = Int(skin.name!)!
                                        if(cellIndex >= Skins.types.count) {
                                            return
                                        }
                                        let skinType = Skins.types[cellIndex]
                                        
                                        if (skinType.buyWithCoins == true) {
                                            if(Int(self.playerData.coins) >= skinType.price) {
                                                let skinData = MemoryCard.sharedInstance.newSkinData()
                                                skinData.index = NSNumber(integer: Int(skin.name!)!)
                                                self.playerData.addSkin(skinData)
                                                self.playerData.skinSlot.skin = skinData
                                                self.playerData.coins = NSNumber(integer: Int(self.playerData.coins) - skinType.price)
                                                self.boxCoins.labelCoins.setText(self.playerData.coins.description)
                                                self.nextState = states.multiPlayerLobby
                                            } else {
                                                //TODO: assistir video para ganhar mais moedas???
                                                print("Não tenho dinheiro para comprar")
                                            }
                                        } else {
                                            //Tentando comprar com gemas
                                            if(Int(self.playerData.gems) >= skinType.price) {
                                                let skinData = MemoryCard.sharedInstance.newSkinData()
                                                skinData.index = NSNumber(integer: Int(skin.name!)!)
                                                self.playerData.addSkin(skinData)
                                                self.playerData.skinSlot.skin = skinData
                                                self.playerData.gems = NSNumber(integer: Int(self.playerData.gems) - skinType.price)
                                                self.boxCoins.labelGems.setText(self.playerData.gems.description)
                                                self.nextState = states.multiPlayerLobby
                                            } else {
                                                //TODO: assistir video para ganhar mais gemas???
                                                print("Não tenho gemas para comprar")
                                            }
                                        }
                                    } else {
                                        for skinData in self.playerData.skins as! Set<SkinData> {
                                            if (skinData.index.description == skin.name!) {
                                                self.playerData.skinSlot.skin = skinData
                                                self.nextState = states.multiPlayerLobby
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            self.nextState = states.multiPlayerLobby
                        }
                    }
                }
                break
                
            case states.choosePowerUps:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = states.multiPlayerLobby
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.powerUpSlotsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.powerUpSlotsScrollNode)
                            
                            for powerUpSlot in self.powerUpSlotsScrollNode.cells {
                                if(powerUpSlot.containsPoint(locationInScrollNode)) {
                                    if let powerUpSlot = powerUpSlot as? PowerUpSlot {
                                        for powerUp in self.powerUpsScrollNode.cells {
                                            if let powerUp = powerUp as? PowerUp {
                                                if (powerUp.powerUpData.index == powerUpSlot.powerUpSlotData.powerUp?.index) {
                                                    powerUp.inUse = false
                                                    break
                                                }
                                            }
                                        }
                                        powerUpSlot.reset()
                                    }
                                }
                            }
                            return
                        }
                        
                        if (self.powerUpsScrollNode.containsPoint(location)) {
                            let locationInScrollNode = touch.locationInNode(self.powerUpsScrollNode)
                            
                            for cell in self.powerUpsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    
                                    for powerUpSlot in self.powerUpSlotsScrollNode.cells as! Array<PowerUpSlot> {
                                        if(powerUpSlot.empty) {
                                            if let powerUp = cell as? PowerUp {
                                                if(!powerUp.inUse) {
                                                    powerUp.inUse = true
                                                    powerUpSlot.setPowerUp(powerUp.powerUpData)
                                                }
                                            }
                                            break
                                        }
                                    }
                                    return
                                }
                            }
                        } else {
                            self.nextState = states.multiPlayerLobby
                            return
                        }
                    }
                }
                break
                
                
            default:
                break
            }
        }
    }


}
