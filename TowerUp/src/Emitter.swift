//
//  Emitter.swift
//  Squares Adventure
//
//  Created by Gabriel Prado Marcolino on 08/11/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import SpriteKit

class Emitter: Tile {
    
    static var emitterList = Set<Emitter>()
    
    var shotDirection:CGVector!
    
    var lastShot:TimeInterval = 0
    
    var shotInterval:TimeInterval = 0
    
    init(x:Int, y:Int, specialTiles:Int) {
        var imageName:String!
        
        switch (specialTiles) {
        case Tile.specialTiles.emitterDown.rawValue:
            imageName = "cannonDown"
            self.shotDirection = CGVector(dx: 0, dy: -1)
            break
        case Tile.specialTiles.emitterLeft.rawValue:
            imageName = "cannonLeft"
            self.shotDirection = CGVector(dx: -1, dy: 0)
            break
        case Tile.specialTiles.emitterRight.rawValue:
            imageName = "cannonRight"
            self.shotDirection = CGVector(dx: 1, dy: 0)
            break
        case Tile.specialTiles.emitterUp.rawValue:
            imageName = "cannonUp"
            self.shotDirection = CGVector(dx: 0, dy: 1)
            break
        default:
            break
        }
        
        super.init(imageName: imageName, x: x, y: y)
        
    
        Emitter.emitterList.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func update(currentTime: TimeInterval) {
        for emitter in Emitter.emitterList {
            emitter.update(currentTime: currentTime)
        }
    }
    
    func update(currentTime: TimeInterval) {
        if(currentTime - self.lastShot > self.shotInterval) {
            let shot = Shot(shotDirection: self.shotDirection)
            shot.position = self.position
            shot.zPosition = self.zPosition - 1
            self.parent?.addChild(shot)
            
            self.lastShot = currentTime
            self.shotInterval = Double.random(min: 0.5, max: 1)
        }
    }
}
