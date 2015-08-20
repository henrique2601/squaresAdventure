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
    
    //Respawn
    var startingPosition:CGPoint = CGPoint.zeroPoint
    
    //Vida
    var maxDeathCount = 10
    var maxHealthPoints = 2
    var healthPoints = 2
    var deathCount = 0
    var lastAlive:NSTimeInterval = 0
    var lastHeal:NSTimeInterval = 0
    
    var collectedBonus = 0
    
    init(x:Int, y:Int, loadPhysics:Bool) {
        super.init()
        self.loadNewPlayer("player", x: x, y: y, loadPhysics: loadPhysics)
    }
    
    func loadNewPlayer(name:String, x:Int, y:Int, loadPhysics:Bool) {
        self.name = name
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: "rabbit")//TODO: SKIN!!!
        let spriteNode = SKSpriteNode(texture: texture, color: nil, size: CGSize(width: 64, height: 64))
        spriteNode.name = name
        
        if(loadPhysics) {
            self.position = CGPoint(x: x, y: y)
            self.startingPosition = self.position
            self.loadPhysics()
        } else {
            self.sketchPosition = CGPoint(x: x, y: y)
            self.yAlign = .center
            self.xAlign = .center
            Control.locations.addObject(name)
        }
        
        self.addChild(spriteNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadPhysics() {
        super.loadPhysics()
        
        self.physicsBody!.categoryBitMask = physicsCategory.player.rawValue
        self.physicsBody!.contactTestBitMask =
            physicsCategory.winTile.rawValue |
            physicsCategory.coin.rawValue |
            physicsCategory.spike.rawValue |
            physicsCategory.doorTile.rawValue
        
        self.physicsBody!.collisionBitMask =
            physicsCategory.ground.rawValue |
            physicsCategory.spike.rawValue
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody) {
        
        switch(physicsBody.categoryBitMask) {
            
        case physicsCategory.ground.rawValue:
            break
            
        case physicsCategory.coin.rawValue:
            let coin = (physicsBody.node! as! Coin)
            self.collectedBonus += coin.bonus
            coin.bonus = 0
            Coin.list.removeObject(coin)
            coin.removeFromParent()
            break
            
        case physicsCategory.spike.rawValue:
            if(self.healthPoints > 0) {
                self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 25))
                self.healthPoints = 0
            }
            break
        
        case physicsCategory.doorTile.rawValue:
            
           println("Toc toc , tem alguem na \(physicsBody.node!.name!)")
            
            
            break

            
        default:
            println("didBeginContact de player com \(physicsBody.node!.name!) não está sendo processado")
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
        
        case physicsCategory.doorTile.rawValue:
            
            break
        
        default:
            println("didEndContact de player com \(physicsBody.node?.name!) não está sendo processado")
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
            
            if(self.position.y < 0) {
                self.healthPoints = 0
            }
            
            self.needAngularImpulse = 1
            if(self.physicsBody!.allContactedBodies().count > 0) {
                for body in self.physicsBody!.allContactedBodies(){
                    if(body.categoryBitMask == physicsCategory.ground.rawValue) {
                        if (abs(self.physicsBody!.velocity.dy) < 500) {
                            if((self.childNodeWithName("//buttonJump") as! Button).pressed) {
                                self.physicsBody?.applyForce(CGVector(dx: 0, dy: 2100))
                            }
                        }
                        break
                    }
                }
                
            } else {
                //Player esta no ar
                self.needAngularImpulse = 3
            }
            
            if((self.parent?.childNodeWithName("//buttonLeft") as! Button).pressed){
                self.needAngularImpulse--
                let velocity = self.physicsBody!.velocity
                if (abs(velocity.dx) < 400) {
                    self.physicsBody?.applyImpulse(CGVector(dx: -5, dy: 0))
                }
            }
            
            if((self.parent?.childNodeWithName("//buttonRight") as! Button).pressed){
                self.needAngularImpulse--
                let velocity = self.physicsBody!.velocity
                if (abs(velocity.dx) < 400) {
                    self.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
                }
            }
            
            if(self.needAngularImpulse > 0){
                self.ajustAngle()
            }
        }
        
        if(currentTime - self.lastAlive > 1) {//Intervalo de spawn apos zerar healthPoints
            self.respawn()
        }
    }
    
    func ajustAngle() {
        if(abs(self.physicsBody!.angularVelocity) < CGFloat(M_PI)) {
            self.totalRotation = 0 - self.zRotation
            
            while(self.totalRotation < -CGFloat(M_PI)) { self.totalRotation += CGFloat(M_PI * 2) }
            while(self.totalRotation >  CGFloat(M_PI)) { self.totalRotation -= CGFloat(M_PI * 2) }
            
            self.physicsBody!.applyAngularImpulse(self.totalRotation * 0.001)
        }
    }
    
    func respawn(){
        self.position = self.startingPosition
        self.physicsBody!.velocity = CGVector(dx: 0, dy: 1)
        self.physicsBody!.angularVelocity = 0
        self.zRotation = 0
        self.healthPoints = self.maxHealthPoints
        self.deathCount++
    }
}
