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
    
    var lastShot:NSTimeInterval = 0
    
    var shotInterval:NSTimeInterval = 0
    
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
    
    static func update(currentTime: NSTimeInterval) {
        for emitter in Emitter.emitterList {
            emitter.update(currentTime)
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        if(currentTime - self.lastShot > self.shotInterval) {
            
            //self.addChild(Shot(shotDirection: self.shotDirection))
            
            self.lastShot = currentTime
            self.shotInterval = Double.random(min: 1, max: 3)
        }
    }
}
