//
//  PlayerOnline.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 18/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit

class PlayerOnline: Player {
    
    var id : Int!
    var lastCurrentTime: NSTimeInterval = 0
    var labelName: Label!
    static var list:NSMutableArray = NSMutableArray()
    
    override init(x: Int, y: Int, loadPhysics: Bool) {
        super.init(x: x, y: y, loadPhysics: loadPhysics)
        PlayerOnline.list.addObject(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateEmiter(currentTime:NSTimeInterval , room:Int) {
        
        if ((currentTime - lastCurrentTime) > 0.035) {
            (self.scene as! MultiplayerGameScene).socket.emit("u", room , Int(self.position.x) , Int(self.position.y) , Int(self.physicsBody!.velocity.dx) , Int(self.physicsBody!.velocity.dy) , Int(self.zRotation * 1000000) , Int(self.physicsBody!.angularVelocity))
            lastCurrentTime = currentTime
        }
       
    }
    
    func updateOnline(x: CGFloat, y: CGFloat , vx: CGFloat , vy: CGFloat , rotation:CGFloat , vrotation:CGFloat)
    {
        

        self.position.x = (x + self.position.x)/2
        self.position.y = (y + self.position.y)/2
        self.physicsBody!.velocity.dx = vx
        self.physicsBody!.velocity.dy = vy
        self.zRotation = rotation / 1000000
        self.physicsBody!.angularVelocity = vrotation
        //println( self.name! + " Updated")
    }
    
    func didFinishUpdate(){
        for player in PlayerOnline.list {
            player.labelName!.position = CGPoint(x: player.position.x, y: player.position.y + 48)
        }
    }
    
    
    
}