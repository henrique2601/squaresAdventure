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
    var labelState: Label!
    
    var boxCoins:BoxCoins!
    
    var player:Player!
    var powerUpSlotsScrollNode:ScrollNode!
    
    var skinsScrollNode:ScrollNode!
    var powerUpsScrollNode:ScrollNode!
    var blackSpriteNode:SKSpriteNode!
    
    var mySkins = NSMutableArray()//Skins Desbloqueadas/Compradas
    
    
    
    var socket = SocketIOClient(socketURL: "teste", opts: nil)
    var playersNodes = Array<SKNode>()
    var playerScrollNode : ScrollNode!
    
    var localName: String = "teste"
    
    
    
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
                        
                        let cell = SKSpriteNode(imageNamed: "lobbyCell")
                        cell.addChild(Label(text: player2.name!, x: -89, y: 0))
                        let playerSkin = SKSpriteNode(imageNamed: Skins.types[skin!].imageName)
                        playerSkin.position = CGPoint(x: -193/2, y: 0)
                        cell.addChild(playerSkin)
                        
                        
                        this.playersNodes.append(cell)
                        
                        
                    }
                }
            }
            print("Added Players")
            
            this.playerScrollNode = ScrollNode(x: 388, y: 459,  cells: this.playersNodes, spacing: 0, scrollDirection: ScrollNode.scrollTypes.vertical , scaleNodes: false )
            
            this.addChild(this.playerScrollNode)
            
            
            
            
            
            
        }
        
                
        self.socket.on(messages.disconnect.rawValue) {[weak self] data, ack in
            if let name = data?[0] as? Int {
                
//                for player in PlayerOnline.playerOnlineList {
//                    if let aux = player as PlayerOnline? {
//                        if let id = aux.id
//                        {
//                            if id == name{
//                                aux.removeFromParent()
//                            }
//                        }
//                    }
//                }
            }
        }
        
        self.socket.on(messages.didJoin.rawValue) {[weak self] data, ack in
            
            guard let this = self else {
                return
            }
            
            this.socket.emit(messages.joinRoom.rawValue, this.localName , this.playerData.skinSlot.skin.index.integerValue)
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
                
                
                
                let cell = SKSpriteNode(imageNamed: "lobbyCell")
                cell.addChild(Label(text: player.name!, x: -89, y: 0))
                let playerSkin = SKSpriteNode(imageNamed: Skins.types[skin!].imageName)
                playerSkin.position = CGPoint(x: -193/2, y: 0)
                cell.addChild(playerSkin)
                
                
                this.playersNodes.append(cell)
                
                this.playerScrollNode.removeFromParent()
                
                this.playerScrollNode = ScrollNode(x: 388, y: 459,  cells: this.playersNodes, spacing: 0, scrollDirection: ScrollNode.scrollTypes.vertical , scaleNodes: false )
                
                this.addChild(this.playerScrollNode)
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
            
            self.labelState = Label(text: "Loading", x: 375, y: 275)
            self.addChild(self.labelState)
        }
        
        
        self.boxCoins = BoxCoins()
        self.addChild(boxCoins)
        
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        self.player = Player(playerData: self.playerData, x: 970, y: 459, loadPhysics: false)
        self.addChild(self.player)
        
        
        
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
                    

                    
                    
                }
                break
                
 
                
                
            default:
                break
            }
        }
    }


}
