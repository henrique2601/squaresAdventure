//
//  PlayerOnline.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 18/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit

class PlayerOnline: Player {
    
    var lastCurrentTime: NSTimeInterval = 0
    var labelName: Label!
    
    func updateEmiter(currentTime:NSTimeInterval , room:Int) {
        
        if ((currentTime - lastCurrentTime) > 0.032) {
            (self.scene as! MultiplayerGameScene).socket.emit("update", room , Int(self.position.x) , Int(self.position.y) , self.physicsBody!.velocity.dx , self.physicsBody!.velocity.dy , self.zRotation , self.physicsBody!.angularVelocity, currentTime)
            lastCurrentTime = currentTime
        }
       
    }
    
    func updateOnline(x: CGFloat, y: CGFloat , vx: CGFloat , vy: CGFloat , rotation:CGFloat , vrotation:CGFloat, currentTime:NSTimeInterval)
    {
        

        self.position.x = (x + self.position.x)/2
        self.position.y = (y + self.position.y)/2
        self.physicsBody!.velocity.dx = vx
        self.physicsBody!.velocity.dy = vy
        self.zRotation = rotation
        self.physicsBody!.angularVelocity = vrotation
        //println( self.name! + " Updated")
    }
    
}