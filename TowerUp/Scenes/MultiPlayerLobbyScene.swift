
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
        case countDown = "c"
        case begin = "b"
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
    var labelState: Label!
    var labelCountDown: Label!
    
    var boxCoins:BoxCoins!
    
    var player:Player!
    var powerUpSlotsScrollNode:ScrollNode!
    
    var skinsScrollNode:ScrollNode!
    var powerUpsScrollNode:ScrollNode!
    
    var mySkins = NSMutableArray()//Skins Desbloqueadas/Compradas
    
    var socket : SocketIOClient!
    var playersNodes = Array<SKNode>()
    var playerScrollNode : ScrollNode!
    
    var localName: String = "teste"
    
    var lobby2:CropBox!
    
    func addHandlers(){
        
        self.socket.on(messages.addPlayers.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            
            this.room = data?[1] as! Int
            MapManager.floor = data?[2] as! Int
            
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
                        
                        var labelName2: Label!
                        labelName2 = Label(text: "")
                        Control.controlList.remove(labelName2)
                        labelName2.zPosition = player2.zPosition + 1
                        labelName2.setText(player2.name!, color: GameColors.black)
                        player2.labelName = labelName2
                        
                        let cell = SKSpriteNode(imageNamed: "lobbyCell")
                        cell.addChild(Label(text: player2.name!, x: -89, y: 0))
                        let playerSkin = SKSpriteNode(imageNamed: Skins.types[skin!].imageName)
                        playerSkin.position = CGPoint(x: -193/2, y: 0)
                        cell.addChild(playerSkin)
                        cell.name = player2.id!.description
                        
                        this.playersNodes.append(cell)
                    }
                }
            }
            print("Added Players")
            
            this.playerScrollNode = ScrollNode(x: 388, y: 359,  cells: this.playersNodes, spacing: 0, scrollDirection: ScrollNode.scrollTypes.vertical , scaleNodes: false )
            
            this.lobby2.addChild(this.playerScrollNode)
        }
        
                
        self.socket.on(messages.disconnect.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            if let name = data?[0] as? Int {
                
                for player in PlayerOnline.playerOnlineList {
                    if let aux = player as PlayerOnline? {
                        if let id = aux.id
                        {
                            if id == name{
                                
                                aux.removeFromParent()
                                
                                var index: Int?
                                for (idx, objectToCompare) in this.playersNodes.enumerate() {
                                    if let to = objectToCompare.name! as String! {
                                        if aux.id.description == to {
                                            index = idx
                                        }
                                    }
                                }
                                
                                if((index) != nil) {
                                    this.playersNodes.removeAtIndex(index!)
                                }
                                
                                print(this.playersNodes)
                                
                                
                                this.playerScrollNode.removeAllChildren()
                                this.playerScrollNode.removeFromParent()
                                
                                this.playerScrollNode = ScrollNode(x: 388, y: 359,  cells: this.playersNodes, spacing: 0, scrollDirection: ScrollNode.scrollTypes.vertical , scaleNodes: false )
                                
                                this.lobby2.addChild(this.playerScrollNode)
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
            
            this.socket.emit(messages.joinRoom.rawValue, this.localName , this.playerData.skinSlot.skin.index.integerValue)
        }
        
        
        
        self.socket.on(messages.countDown.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            if let count = data?[0] as? Int {
                this.labelCountDown.setText(count.description + "s")
            }
            
            if let count = data?[0] as? String {
                this.labelCountDown.setText(count)
            }
        }
        
        
        self.socket.on(messages.begin.rawValue) {[weak self] data, ack in
            
            print("begin Recieved")
            
            guard let this = self else {
                return
            }
            
            this.nextState = .multiplayerMission
            print(PlayerOnline.playerOnlineList)
        }
        
        
        
        self.socket.on(messages.join.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            if let name = data?[0] as? NSDictionary {
                
                print(data![0])
                let xPos = 128
                let skin = name.objectForKey("skin") as? Int
                let player = PlayerOnline(skinId: skin!, x: xPos, y: 128, loadPhysics: true)
                player.name = name.objectForKey("name") as? String
                player.id = name.objectForKey("id") as? Int
                
                
                var labelName: Label!
                labelName = Label(text: "")
                Control.controlList.remove(labelName)
                labelName.setText(player.name!, color: GameColors.black)
                player.labelName = labelName
                
                
                for var i = 0; i < 10; i++ {
                
                let cell = SKSpriteNode(imageNamed: "lobbyCell")
                cell.addChild(Label(text: player.name!, x: -89, y: 0))
                let playerSkin = SKSpriteNode(imageNamed: Skins.types[skin!].imageName)
                playerSkin.position = CGPoint(x: -193/2, y: 0)
                cell.addChild(playerSkin)
                cell.name = player.id!.description
                
                this.playerScrollNode.append(cell)
                    
                }
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(textureName: "background", z: -1001, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        self.lobby2 = CropBox(textureName: "lobby2", z: -1000, xAlign: .center, yAlign: .center)
        self.addChild(self.lobby2)
        self.backgroundColor = GameColors.blue
        
        self.myTextField = Textfield(name: self.playerData.name , x: 820, y: 270, align:.center, view:self.view!)
        self.myTextField.myTextField.delegate = self
        self.myTextField.myTextField.enabled = false
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
        
        
        self.labelState = Label(text: "Loading", x: 375, y: 175, xAlign:.center, yAlign:.center)
        self.addChild(self.labelState)
        
        self.labelCountDown = Label(text: "", x: 375, y: 210, xAlign:.center, yAlign:.center)
        self.addChild(self.labelCountDown)
        
        self.boxCoins = BoxCoins()
        self.addChild(boxCoins)
        
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        self.player = Player(playerData: self.playerData, x: 970, y: 459, loadPhysics: false)
        self.addChild(self.player)
        
        self.localName = MemoryCard.sharedInstance.playerData.name
        
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
                    self.labelState.setText("Searching Best Server")
                    ServerManager.sharedInstance.bestServer { serverStr in
                        self.server = serverStr
                        print(self.server)
                        
                        if (self.server == "erro") {
                            
                            let box = MessageBox(text: "Error connecting to server", textureName: "messegeBox", type: MessageBox.messageType.OK)
                            box.touchesEndedAtButtonOK.addHandler({
                                self.nextState = .lobby
                            })
                            
                            let size = self.size.width > self.size.height ? self.size.width : self.size.height
                            self.player.removeFromParent()
                            self.blackSpriteNode.hidden = false
                            self.addChild(box)
                            self.myTextField.myTextField.hidden = true
                            self.powerUpSlotsScrollNode.removeFromParent()
                            
                        } else {
                           self.nextState = .connecting
                        }
                        
                        
                    }
                } else {
                    let box = MessageBox(text: "You not connect to internet", textureName: "messegeBox", type: MessageBox.messageType.OK)
                    box.touchesEndedAtButtonOK.addHandler({
                        self.nextState = .lobby
                    })
                    
                    let size = self.size.width > self.size.height ? self.size.width : self.size.height
                    self.player.removeFromParent()
                    self.blackSpriteNode.hidden = false
                    self.addChild(box)
                    self.myTextField.myTextField.hidden = true
                    self.powerUpSlotsScrollNode.removeFromParent()
                    
                }
                
                
                
                
                break
                
            case states.connecting:
                self.socket = SocketIOClient(socketURL: self.server, opts: nil)
                self.socket.connect()
                self.labelState.setText("Waiting Other Players")
                self.addHandlers()
                self.nextState = .multiPlayerLobby
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
                
                self.blackSpriteNode.hidden = true
                
                break
                
            case states.lobby:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultTransition)
                break
                
            case states.multiplayerMission:
                let nextScene = MultiplayerMissionScene(socket: self.socket)
                nextScene.room = self.room
                nextScene.localName = self.myTextField.myTextField.text
                self.view!.presentScene(nextScene, transition: Config.defaultTransition)
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
                        self.socket.disconnect(fast: true)
                        PlayerOnline.playerOnlineList = Set<PlayerOnline>()
                        self.nextState = states.lobby
                        return
                    }
                    

                    
                    
                }
                break
                
 
                
                
            default:
                break
            }
        }
    }


}
