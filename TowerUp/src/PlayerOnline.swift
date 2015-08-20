//
//  PlayerOnline.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 18/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit

class PlayerOnline: Player {
    
    func update(currentTime:NSTimeInterval , room:Int) {
        super.update(currentTime)
        
        (self.scene as! MultiplayerGameScene).socket.emit("update", room , self.position.x , self.position.y , self.physicsBody!.velocity.dx , self.physicsBody!.velocity.dy , self.zRotation , self.physicsBody!.angularVelocity)
    }
    
    func updateOnline(x: CGFloat, y: CGFloat , vx: CGFloat , vy: CGFloat , rotation:CGFloat , vrotation:CGFloat)
    {
        self.position.x = x
        self.position.y = y
        self.physicsBody!.velocity.dx = vx
        self.physicsBody!.velocity.dy = vy
        self.zRotation = rotation
        self.physicsBody!.angularVelocity = vrotation
        //println( self.name! + " Updated")
    }
    
}