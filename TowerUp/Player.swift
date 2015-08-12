//
//  Player.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 07/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import Foundation
import SpriteKit


class Player: Control {

    //Atributos
    var spped:Int = 3
    var force:Int = 2
    var jump:Int = 8
   
    //Movimentação
    var needToMove:Bool = false
    var destination:CGPoint = CGPoint.zeroPoint
    var rotation:CGFloat = 0
    var totalRotation:CGFloat = 0
    var startMoving:Double = 0
    
    //Toques
    var lastNoTouchTime:Double = 0
    var touchesArrayCount: Int = 0
    var lastTouchesArrayCount: Int = 0
    var firstTouchLocation:CGPoint = CGPoint.zeroPoint
    var lastTouchLocation:CGPoint = CGPoint.zeroPoint


    override init(name:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    override init(name:String, textureName:String, x:Int, y:Int) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up)
    }
    
    override init(name:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    override init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }
    
    override init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center)
    }
    
    override init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
func update(currentTime: NSTimeInterval) {
        
        self.lastTouchesArrayCount = self.touchesArrayCount
        self.touchesArrayCount = Control.touchesArray.count
        
        switch(self.touchesArrayCount) {
            
            //Zero toques
        case 0:
            //Um toque curto
            if((self.lastTouchesArrayCount == 1) && currentTime - lastNoTouchTime < 1) {
                self.needToMove = true
                self.startMoving = currentTime
                self.destination = self.firstTouchLocation
            }
            self.lastNoTouchTime = currentTime
            
            if(self.needToMove){
                self.setRotationToPoint(self.destination)
            }
            
            break
            
            //Um toque
        case 1:
            self.firstTouchLocation = (Control.touchesArray[0] as! UITouch).locationInNode(self.parent)
            
            self.setRotationToPoint(self.firstTouchLocation)
            break
            
            //Mais de um toque
        default:
            
            self.firstTouchLocation = (Control.touchesArray[0] as! UITouch).locationInNode(self.parent)
            self.lastTouchLocation = (Control.touchesArray.lastObject as! UITouch).locationInNode(self.parent)
            
            self.needToMove = true
            self.startMoving = currentTime
            self.destination = lastTouchLocation
            
            self.setRotationToPoint(self.firstTouchLocation)
            
            break
        }
        
        if(currentTime - self.startMoving > 1){
            self.needToMove = false
        }
        /*
        if(abs(self.physicsBody!.angularVelocity) < CGFloat(M_PI * 2) && (self.needToMove || self.touchesArrayCount > 0)) {
            self.totalRotation = self.rotation - self.zRotation
            
            while(self.totalRotation < -CGFloat(M_PI)) { self.totalRotation += CGFloat(M_PI * 2) }
            while(self.totalRotation >  CGFloat(M_PI)) { self.totalRotation -= CGFloat(M_PI * 2) }
            
            self.physicsBody!.applyAngularImpulse(self.totalRotation *  0.005)
        }
        */
        
        if (self.needToMove) {
            var dX:CGFloat = destination.x - self.position.x
            var dY:CGFloat = destination.y - self.position.y
            var distanceToDestination:CGFloat = sqrt((dX * dX) + (dY * dY))
            
            
            if(distanceToDestination < 64) {
                needToMove = false
            } else {
                switch(self.touchesArrayCount) {
                case 0:
                    if(abs(self.totalRotation) < 1){
                        //self.physicsBody!.applyForce(CGVector(dx: -sin(self.zRotation) * 1000, dy: cos(self.zRotation) * 1000))
                    }
                    break
                    
                default:
                    //aplicar forca em direcao ao destino
                    //self.physicsBody!.applyForce(CGVector(dx: (dX/distanceToDestination) * 1000, dy: (dY/distanceToDestination) * 1000))
                    break
                }
            }
        }
    }
    if((self.parent?.childNodeWithName("//buttonRight") as! Button).pressed){
        self.physicsBody?.applyForce(CGVector(dx: 20, dy: 0))
    }

}
    
func setRotationToPoint(point:CGPoint) {
        self.rotation = CGFloat(M_PI) + CGFloat(-atan2f(Float(self.position.x - point.x), Float(self.position.y - point.y)))
}
    
}

