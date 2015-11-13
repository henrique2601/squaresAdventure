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
    var startingPosition:CGPoint!
    
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
    
    //Sound Effects
    var boom:SoundEffect!
    var coinSound:SoundEffect!
    var jumpSound:SoundEffect!
    var spikeSound:SoundEffect!
    var winSound:SoundEffect!
    
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
        self.loadSoundEffects()
    }
    
    func loadSoundEffects() {
        self.boom = SoundEffect(soundFile: SoundEffect.files.boom.rawValue, node: self)
        self.coinSound = SoundEffect(soundFile: SoundEffect.files.coin.rawValue, node: self)
        //self.jumpSound = SoundEffect(soundFile: SoundEffect.files.jump.rawValue, node: self)
        self.spikeSound = SoundEffect(soundFile: SoundEffect.files.player_Spike.rawValue, node: self)
        
        self.winSound = SoundEffect(soundFile: SoundEffect.files.win.rawValue, node: self)
    }
    
    func resetCategoryBitMasks() {
        self.physicsBody!.categoryBitMask = physicsCategory.player.rawValue
        self.physicsBody!.contactTestBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.boxCrate.rawValue |
            physicsCategory.player.rawValue |
            
            physicsCategory.winTile.rawValue |
            physicsCategory.coin.rawValue |
            physicsCategory.gem.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.saw.rawValue |
            physicsCategory.bomb.rawValue |
            physicsCategory.spring.rawValue |
            physicsCategory.doorTile.rawValue |
            physicsCategory.boxExplosive.rawValue
        
        
        self.physicsBody!.collisionBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.saw.rawValue |
            physicsCategory.bomb.rawValue |
            physicsCategory.spring.rawValue |
            physicsCategory.boxCrate.rawValue |
            physicsCategory.slime.rawValue |
            physicsCategory.player.rawValue |
            physicsCategory.boxExplosive.rawValue |
            physicsCategory.bullet.rawValue
    }
    
//    func blood(contact: SKPhysicsContact) {
//        let particles = SKEmitterNode(fileNamed: "Blood.sks")!
//        //particles.particleSpeed = contact.collisionImpulse * 1
//        //particles.emissionAngle = atan2(contact.contactNormal.dx, contact.contactNormal.dy) - CGFloat(M_PI/2)
//        
//        particles.emissionAngle = atan2(
//            -self.physicsBody!.velocity.dx,
//            -self.physicsBody!.velocity.dy)
//        
//        particles.position = CGPoint(
//            x: Int(self.position.x),
//            y: Int(self.position.y))
//        particles.zPosition = self.zPosition
//        self.parent!.addChild(particles)
//        
//        let action = SKAction()
//        action.duration = 2
//        particles.runAction(action , completion: { () -> Void in
//            particles.removeFromParent()
//        })
//    }
    
    func smoke(contact: SKPhysicsContact) {
        let particles = SKEmitterNode(fileNamed: "Smoke.sks")!
        particles.particleSpeed = contact.collisionImpulse * 1
        //particles.emissionAngle = atan2(contact.contactNormal.dx, contact.contactNormal.dy) - CGFloat(M_PI/2)
        
        particles.emissionAngle = atan2(
            self.physicsBody!.velocity.dx,
            self.physicsBody!.velocity.dy) - CGFloat(M_PI/2)
        
        particles.position = CGPoint(
            x: Int(self.position.x),
            y: Int(self.position.y))
        particles.zPosition = self.zPosition
        self.parent!.addChild(particles)
        
        let action = SKAction()
        action.duration = 2
        particles.runAction(action , completion: { () -> Void in
            particles.removeFromParent()
        })
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch(physicsBody.categoryBitMask) {
            
        case physicsCategory.ground.rawValue:
            self.smoke(contact)
            break
            
        case physicsCategory.boxCrate.rawValue:
            self.smoke(contact)
            break
            
        case physicsCategory.player.rawValue:
            self.smoke(contact)
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
                
                let particles = SKEmitterNode(fileNamed: "Gem.sks")
                
                particles?.position.x = gem.position.x
                particles?.position.y = gem.position.y
                particles?.zPosition = gem.zPosition
                self.parent!.addChild(particles!)
                
                let action = SKAction()
                action.duration = 2
                particles?.runAction(action , completion: { () -> Void in
                    particles?.removeFromParent()
                })
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
                self.coinSound.play()
                
                let particles = SKEmitterNode(fileNamed: "Coin.sks")!
                
                particles.position.x = coin.position.x
                particles.position.y = coin.position.y
                particles.zPosition = coin.zPosition
                
                self.parent!.addChild(particles)
                
                let action = SKAction()
                action.duration = 2
                particles.runAction(action , completion: { () -> Void in
                    particles.removeFromParent()
                })

                coin.removeFromParent()
            }
            break
            
        case physicsCategory.saw.rawValue:
            //self.blood(contact)
            self.spikeSound.play()//TODO: novo som
            if(self.healthPoints > 0) {
                self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 10))
                self.physicsBody!.applyAngularImpulse(0.1)
                self.healthPoints = 0
            }
            break
            
        case physicsCategory.spike.rawValue:
            //self.blood(contact)
            self.spikeSound.play()
            if(self.healthPoints > 0) {
                self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 25))
                self.healthPoints = 0
            }
            break
            
        case physicsCategory.spring.rawValue:
            self.smoke(contact)
            if let node = physicsBody.node {
                let spring = node as! Spring
                spring.doLogic(self)
            }
            break
            
        case physicsCategory.bomb.rawValue:
            //self.blood(contact)
            
            if let node = physicsBody.node {
                let bomb = (node as! Bomb)
                
                self.boom.play()
                self.healthPoints = 0
                
                if let scene = self.scene as? MultiplayerMissionScene {
                    
                    
                    //print("toquei na caixa")
                    //print(scene.localName)
                    //print(self.name)
                    
                    if (scene.localName == self.name!) {
                        print("mandei pro servidor " + bomb.listPosition.description)
                        
                        scene.socket.emit("removeBomb", scene.room , bomb.listPosition)
                        bomb.removeFromParent()
                    }
                } else {
                    bomb.removeFromParent()
                }
            }
            break
            
        case physicsCategory.doorTile.rawValue:
            print("Toc toc , tem alguem na \(physicsBody.node!.name!)")
            break
            
        case physicsCategory.winTile.rawValue:
            if (self.healthPoints > 0) {
                self.physicsBody?.dynamic = false
                self.physicsBody?.categoryBitMask = physicsCategory.none.rawValue
                self.hidden = true
                self.win = true
                self.winSound.play()
            }
            break
            
        case physicsCategory.boxExplosive.rawValue:
            
            if let node = physicsBody.node {
                let boxCrateBomb = (node as! BoxExplosive)
                
                self.boom.play()
                self.healthPoints = 0
                
                
                if let scene = self.scene as? MultiplayerMissionScene {
                    
                    
                    //print("toquei na caixa")
                    //print(scene.localName)
                    //print(self.name)
                    
                    if (scene.localName == self.name!){
                        //print("mandei pro servidor")
                        
                        
                        scene.socket.emit("removeBoxCrateBomb", scene.room , boxCrateBomb.listPosition)
                        boxCrateBomb.removeFromParent()
                        
                        
                    }
                } else {
                    
                        boxCrateBomb.removeFromParent()
                }
            }
            
            break
            
        default:
            print("didBeginContact de player com \(physicsBody.node!.name) não está sendo processado")
            break
        }
    }
    
    func didEndContact(physicsBody:SKPhysicsBody, contact:SKPhysicsContact) {
        //physicsBody.node pode ter sido removido(nulo) em didBeginContact. Use ? no lugar de !
        switch(physicsBody.categoryBitMask) {
        case physicsCategory.ground.rawValue:
            
            break
        case physicsCategory.coin.rawValue:
            
            break
        case physicsCategory.saw.rawValue:
            
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
            print("didEndContact de player com \(physicsBody.node?.name) não está sendo processado")
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
                                    //self.jumpSound.play()
                                    
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
    
    func respawn() {
        
        let emitterNode = SKEmitterNode(fileNamed: "PlayerSpawn.sks")!
        self.parent!.addChild(emitterNode)
        emitterNode.zPosition = self.zPosition + 1
        emitterNode.position = self.startingPosition
        
        self.resetCategoryBitMasks()
        self.hidden = false
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
        
        self.runAction(SKAction.fadeAlphaTo(-1, duration: 0))
        self.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
    
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
