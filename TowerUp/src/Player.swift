//
//  Player.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/13/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Player: Square {
    
    //Ajuste de angulo
    var needAngularImpulse = 0
    var totalRotation:CGFloat = 0
    var auxRotation:CGFloat = 0
    
    //Respawn
    var startingPosition:CGPoint = CGPoint.zero
    
    //Vida
    var maxDeathCount = 10
    var maxHealthPoints = 2
    var healthPoints = 2
    var deathCount = 0 {
        didSet {
            if let scene = self.scene as? MissionScene {
               scene.boxDeathsAndTime.labelDeaths.setText(deathCount.description)
            }
        }
    }
    var lastAlive:NSTimeInterval = 0
    var lastHeal:NSTimeInterval = 0
    
    //Gameplay
    var win:Bool = false
    var lastNoWin:NSTimeInterval = 0
    
    //Controls
    var jump:Bool = false
    var move:Int = 0
    
    //Effects
    var needToPlayDeathAnimation:Bool = true
    var redSpritekitNode:SKSpriteNode!
    var spriteNode:SKSpriteNode!
    var spriteNodeDead:SKSpriteNode!
    
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    init(texture:String = "rabbit", x:Int, y:Int, loadPhysics:Bool) {
        super.init()
        self.loadNewPlayer("player", texture:texture, x: x, y: y, loadPhysics: loadPhysics)
    }
    
    init(playerData:PlayerData, x:Int, y:Int, loadPhysics:Bool) {
        super.init()
        
        let skinType = Skins.types[playerData.skinSlot.skin.index.integerValue]
        
        self.loadNewPlayer("player", texture:skinType.imageName, x: x, y: y, loadPhysics: loadPhysics)
    }
    
    init(skinId:Int, x:Int, y:Int, loadPhysics:Bool) {
        super.init()
        
        let skinType = Skins.types[skinId]
        
        self.loadNewPlayer("player", texture:skinType.imageName, x: x, y: y, loadPhysics: loadPhysics)
    }
    
    func loadNewPlayer(name:String, texture:String, x:Int, y:Int, loadPhysics:Bool) {
        self.name = name
        
        let texture = SKTexture(imageNamed: texture)
        
        if(loadPhysics) {
            self.zPosition = Config.HUDZPosition/2
            self.spriteNode = SKSpriteNode(texture: texture, size: texture.size())
            self.spriteNode.name = name
            
            self.position = CGPoint(x: x, y: y)
            self.startingPosition = self.position
            self.loadPhysics()
        } else {
            self.zPosition = Config.HUDZPosition
            self.spriteNode = SKSpriteNode(texture: texture, size: CGSize(width: texture.size().width, height: texture.size().height))
            self.spriteNode.name = name
            
            //spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.sketchPosition = CGPoint(x: x, y: y)
            self.yAlign = .center
            self.xAlign = .center
            Control.controlList.insert(self)
        }
        
        self.addChild(spriteNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadPhysics() {
        super.loadPhysics()
        self.resetCategoryBitMasks()
    }
    
    func resetCategoryBitMasks() {
        self.physicsBody!.categoryBitMask = physicsCategory.player.rawValue
        self.physicsBody!.contactTestBitMask =
            physicsCategory.winTile.rawValue |
            physicsCategory.coin.rawValue |
            physicsCategory.gem.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.bomb.rawValue |
            physicsCategory.spring.rawValue |
            physicsCategory.doorTile.rawValue
        
        
        self.physicsBody!.collisionBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.bomb.rawValue |
            physicsCategory.spring.rawValue |
            physicsCategory.boxCrate.rawValue |
            physicsCategory.player.rawValue
        
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody) {
        
        switch(physicsBody.categoryBitMask) {
            
        case physicsCategory.ground.rawValue:
            break
            
        case physicsCategory.gem.rawValue:
            if let node = physicsBody.node {
                let gem = (node as! Gem)
                if let scene = self.scene as? MissionScene {
                    let playerData = MemoryCard.sharedInstance.playerData
                    playerData.gems = NSNumber(integer: Int(playerData.gems) + gem.bonus)
                    print("now i have \(playerData.gems.description ) gems =}")
                    MemoryCard.sharedInstance.currentFloor().gemAvailable = false
                    
                    scene.boxCoins.labelGems.setText(playerData.gems.description)
                } else {
                    if let _ = self.scene as? MultiplayerMissionScene {
                        let playerData = MemoryCard.sharedInstance.playerData
                        playerData.gems = NSNumber(integer: Int(playerData.gems) + gem.bonus)
                    }
                }
                gem.bonus = 0
                gem.removeFromParent()
            }
            break
            
        case physicsCategory.coin.rawValue:
            if let node = physicsBody.node {
                let coin = (node as! Coin)
                if let scene = self.scene as? MissionScene {
                    let playerData = MemoryCard.sharedInstance.playerData
                    playerData.coins = NSNumber(integer: Int(playerData.coins) + coin.bonus)
                    
                    scene.collectedBonus = scene.collectedBonus + coin.bonus
                } else {
                    if let scene = self.scene as? MultiplayerMissionScene {
                        let playerData = MemoryCard.sharedInstance.playerData
                        playerData.coins = NSNumber(integer: Int(playerData.coins) + coin.bonus)
                        
                        scene.collectedBonus = scene.collectedBonus + coin.bonus
                    }
                }
                coin.bonus = 0
                coin.removeFromParent()
            }
            break
            
        case physicsCategory.spike.rawValue:
            if(self.healthPoints > 0) {
                self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 25))
                self.healthPoints = 0
            }
            break
            
        case physicsCategory.spring.rawValue:
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 25))
            self.physicsBody!.angularVelocity = self.physicsBody!.angularVelocity/2
            self.physicsBody!.velocity.dx = self.physicsBody!.velocity.dx/2
            break
            
        case physicsCategory.bomb.rawValue:
            self.healthPoints = 0
            
            if let node = physicsBody.node {
                let bomb = (node as! Bomb)
                bomb.removeFromParent()
            }
            
            break
            
        case physicsCategory.doorTile.rawValue:
            print("Toc toc , tem alguem na \(physicsBody.node!.name!)")
            break
            
        case physicsCategory.winTile.rawValue:
            self.physicsBody?.dynamic = false
            self.win = true
            break
            
        default:
            print("didBeginContact de player com \(physicsBody.node!.name!) não está sendo processado")
            break
        }
    }
    
    func didEndContact(physicsBody:SKPhysicsBody) {
        //physicsBody.node pode ter sido removido(nulo) em didBeginContact. Use ? no lugar de !
        switch(physicsBody.categoryBitMask) {
        case physicsCategory.ground.rawValue:
            
            break
        case physicsCategory.coin.rawValue:
            
            break
        case physicsCategory.spike.rawValue:
            
            break
            
        case physicsCategory.bomb.rawValue:
            
            break
            
        case physicsCategory.spring.rawValue:
            
            break
            
        case physicsCategory.doorTile.rawValue:
            
            break
            
        case physicsCategory.winTile.rawValue:
            self.physicsBody?.dynamic = true
            self.win = false
            break
            
        default:
            print("didEndContact de player com \(physicsBody.node?.name!) não está sendo processado")
            break
        }
    }
    
    func update(currentTime:NSTimeInterval) {
        
        if(self.healthPoints > 0) {
            self.lastAlive = currentTime
            
            //Teste heal. Exportar função
            if(self.healthPoints >= self.maxHealthPoints) {
                self.lastHeal = currentTime
            } else {
                if(currentTime - self.lastHeal > 3) {
                    self.healthPoints++
                }
            }
            //
            
            //Win exprotar função?
            if(!self.win){
                self.lastNoWin = currentTime
            } else {
                if(currentTime - self.lastNoWin > 0.1) {
                    if let scene = self.scene as? MissionScene {
                        scene.nextState = MissionScene.states.win
                    }
                    if let scene = self.scene as? MultiplayerMissionScene {
                        scene.nextState = MultiplayerMissionScene.states.win
                    }
                }
            }
            //
            
            if(self.position.y < 0) {
                self.healthPoints = 0
            }
            
            self.needAngularImpulse = 1
            if let physicsBody = self.physicsBody {
                if(physicsBody.allContactedBodies().count > 0) {
                    for body in physicsBody.allContactedBodies() as NSArray {
                        if(
                            body.categoryBitMask == physicsCategory.ground.rawValue ||
                            body.categoryBitMask == physicsCategory.boxCrate.rawValue ||
                            body.categoryBitMask == physicsCategory.player.rawValue) {
                            if (abs(self.physicsBody!.velocity.dy) < 200) {
                                if(self.jump) {
                                    self.physicsBody?.velocity.dy = 900
                                    //self.physicsBody?.applyForce(CGVector(dx: 0, dy: 2100))
                                    self.jump = false
                                }
                            }
                            break
                        }
                    }
                } else {
                    //Player esta no ar
                    self.needAngularImpulse = 3
                }
            }
            
            if self.move != 0 {
                self.needAngularImpulse--
                let velocity = self.physicsBody!.velocity
                if (abs(velocity.dx) < 400) {
                    self.physicsBody?.applyImpulse(CGVector(dx: self.move/20, dy: 0))
                }
            }
            
            if(self.needAngularImpulse > 0) {
                self.ajustAngle()
            }
        } else {
            
            if(self.needToPlayDeathAnimation) {
                self.redSpritekitNode = SKSpriteNode(color: UIColor(red: 1, green: 0, blue: 0, alpha: 0.75), size: Config.currentSceneSize)
                self.redSpritekitNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.redSpritekitNode.runAction(SKAction.fadeOutWithDuration(1))
                self.redSpritekitNode.zPosition = Config.HUDZPosition * 2
                self.scene?.addChild(redSpritekitNode)
                self.needToPlayDeathAnimation = false
                
                let skinType = Skins.types[playerData.skinSlot.skin.index.integerValue]
                
                self.spriteNodeDead = SKSpriteNode(imageNamed: skinType.imageName + "Dead")
                self.spriteNodeDead.zPosition = self.spriteNode.zPosition + 1
                self.addChild(self.spriteNodeDead)
            }
            
            for touch in Control.touchesArray {
                if(touch.tapCount >= 2) {
                    self.respawn()
                }
            }
        }
        
        if(currentTime - self.lastAlive > 3) {//Intervalo de spawn apos zerar healthPoints
            self.respawn()
        }
    }
    
    func ajustAngle() {
        if let physicsBody = self.physicsBody {
            if(abs(physicsBody.angularVelocity) < CGFloat(M_PI) * 2) {
                self.totalRotation = self.auxRotation - self.zRotation
                
                while(self.totalRotation < -CGFloat(M_PI)) { self.totalRotation += CGFloat(M_PI * 2) }
                while(self.totalRotation >  CGFloat(M_PI)) { self.totalRotation -= CGFloat(M_PI * 2) }
                
                physicsBody.applyAngularImpulse(self.totalRotation * 0.001)
            }
        }
    }
    
    func respawn(){
        self.position = self.startingPosition
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 1)
        self.physicsBody!.angularVelocity = 0
        self.zRotation = 0
        self.healthPoints = self.maxHealthPoints
        self.deathCount++
        
        self.needToPlayDeathAnimation = true
        if let _ = self.redSpritekitNode {
            self.redSpritekitNode.removeFromParent()
            
        }
        if let _ = self.spriteNodeDead {
            self.spriteNodeDead.removeFromParent()
        }
        
    }
    
    func reset() {
        self.respawn()
        
        //Vida
        self.healthPoints = self.maxHealthPoints
        self.deathCount = 0
        self.lastAlive = 0
        self.lastHeal = 0
        
        //Gameplay
        self.win = false
        self.lastNoWin = 0
        
        self.physicsBody?.dynamic = true
    }
}
