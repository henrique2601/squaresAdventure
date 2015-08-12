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
    
    if((self.childNodeWithName("//buttonJump") as! Button).pressed){
        self.physicsBody?.applyForce(CGVector(dx: 0, dy: 100))
    }
    if((self.parent?.childNodeWithName("//buttonLeft") as! Button).pressed){
        self.physicsBody?.applyForce(CGVector(dx: -20, dy: 0))
    }
    if((self.parent?.childNodeWithName("//buttonRight") as! Button).pressed){
        self.physicsBody?.applyForce(CGVector(dx: 20, dy: 0))
    }

}
    
func setRotationToPoint(point:CGPoint) {
        self.rotation = CGFloat(M_PI) + CGFloat(-atan2f(Float(self.position.x - point.x), Float(self.position.y - point.y)))
}
    
}

