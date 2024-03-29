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
    var lastCurrentTime: TimeInterval = 0
    var labelName: Label!
    var skin: Int!
    static var playerOnlineList = Set<PlayerOnline>()
    
    
    init(x: Int, y: Int, loadPhysics: Bool) {
        super.init(x: x, y: y, loadPhysics: loadPhysics)
        PlayerOnline.playerOnlineList.insert(self)
    }
    
    override init(skinId:Int, x:Int, y:Int, loadPhysics:Bool) {
        super.init(skinId: skinId, x: x, y: y, loadPhysics: loadPhysics)
        PlayerOnline.playerOnlineList.insert(self)
        self.skin = skinId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateEmiter(currentTime:TimeInterval , room:String) {
        
//        if ((currentTime - lastCurrentTime) > 0.047) {
//            (self.scene as! MultiplayerMissionScene).socket.emit("u", room , Int(self.position.x) , Int(self.position.y) , Int(self.physicsBody!.velocity.dx) , Int(self.physicsBody!.velocity.dy) , Int(self.zRotation * 1000000) , Int(self.physicsBody!.angularVelocity))
//            lastCurrentTime = currentTime
//        }
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
        for player in PlayerOnline.playerOnlineList {
            player.labelName.position = CGPoint(x: player.position.x, y: player.position.y + 48)
        }
    }
    
    override func removeFromParent() {
        
        self.labelName.removeFromParent()
        PlayerOnline.playerOnlineList.remove(self)
        super.removeFromParent()
        
    }
}
