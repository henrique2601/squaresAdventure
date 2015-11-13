//
//  LobbyScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/7/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class LobbyScene: GameScene, UITextFieldDelegate {
    enum states {
        case loading
        case lobby
        case choosePowerUps
        case chooseSkin
        case multiplayerLobby
        case localLobby
        case mainMenu
    }
    
    var room: Int = 0
    //let socket = SocketIOClient(socketURL: "179.232.86.110:3001", opts: nil)

    var myTextField: Textfield!
    var playerData = MemoryCard.sharedInstance.playerData
    
    var buttonOnline:Button!
    var buttonQuick:Button!
    var buttonLocal:Button!
    var buttonBack:Button!
    
    var state = states.loading
    var nextState = states.lobby
    
    var boxCoins:BoxCoins!
    
    var player:Player!
    var powerUpSlotsScrollNode:ScrollNode!
    
    var skinsScrollNode:ScrollNode!
    var powerUpsScrollNode:ScrollNode!
    
    var mySkins = NSMutableArray()//Skins Desbloqueadas/Compradas
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(textureName: "background", z: -1001, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.addChild(Control(textureName: "lobby1", z: -1000, xAlign: .center, yAlign: .center))
        self.backgroundColor = GameColors.blue
        
        self.buttonOnline = Button(textureName: "buttonPink", text:"ONLINE GAME", x: 229, y: 393, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonOnline)
        
//        self.buttonQuick = Button(textureName: "buttonPink", text:"QUICKPLAY", x: 229, y: 393, xAlign: .center, yAlign: .center)
//        self.addChild(self.buttonQuick)
        
//        self.buttonLocal = Button(textureName: "buttonPink", text:"LOCAL GAME", x: 229, y: 517, xAlign: .center, yAlign: .center)
//        self.addChild(self.buttonLocal)
        
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
        
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
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
                
                
                
            case states.chooseSkin:
                self.player.removeFromParent()
                
                var skinsArray = Array<SKNode>()
                self.mySkins = NSMutableArray()
                
                //Skins desbloqueadas
                for item in self.playerData.skins as NSOrderedSet {
                    let skin = item as! SkinData
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
                
                self.skinsScrollNode = ScrollNode(x: 836, y: 466, cells: skinsArray, spacing: 0, scrollDirection: ScrollNode.scrollTypes.horizontal, scaleNodes: true, scaleDistance:1334/4 + 100)
                self.addChild(skinsScrollNode)
                
                self.blackSpriteNode.hidden = false
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
                
       
                
                self.powerUpsScrollNode = ScrollNode(x: 970, y: 436, cells: powerUpsArray, scrollDirection: .horizontal, scaleNodes: false, scaleDistance:95)
                self.addChild(self.powerUpsScrollNode)
                
                break
                
            case states.lobby:
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
                
            case states.multiplayerLobby:
                self.view!.presentScene(MultiPlayerLobbyScene(), transition: Config.defaultTransition)
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultTransition)
                break
                
            case states.localLobby:
                self.view!.presentScene(LocalLobbyScene(), transition: Config.defaultTransition)
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
            case states.lobby:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonOnline.containsPoint(location)) {
                        room = 0
                        self.nextState = .multiplayerLobby
                        return
                    }
                    
//                    if (self.buttonQuick.containsPoint(location)) {
//                        room = 1
//                        self.nextState = .multiplayerLobby
//                        return
//                    }
//                    
//                    if (self.buttonLocal.containsPoint(location)) {
//                        room = 2
//                        self.nextState = .localLobby
//                        return
//                    }
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .mainMenu
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
                        self.nextState = .lobby
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
                                                self.nextState = states.lobby
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
                                                self.nextState = states.lobby
                                            } else {
                                                //TODO: assistir video para ganhar mais gemas???
                                                print("Não tenho gemas para comprar")
                                            }
                                        }
                                    } else {
                                        for item in self.playerData.skins as! NSOrderedSet {
                                            let skinData = item as! SkinData
                                            if (skinData.index.description == skin.name!) {
                                                self.playerData.skinSlot.skin = skinData
                                                self.nextState = states.lobby
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            self.nextState = states.lobby
                        }
                    }
                }
                break
                
            case states.choosePowerUps:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                  
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .lobby
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
                            self.nextState = states.lobby
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
