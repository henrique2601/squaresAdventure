//
//  Emitter.swift
//  Squares Adventure
//
//  Created by Gabriel Prado Marcolino on 08/11/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import SpriteKit

class Emitter: Tile {
    init(x:Int, y:Int, specialTiles:Int) {
        var imageName:String!
        
        switch (specialTiles) {
        case Tile.specialTiles.emitterDown.rawValue:
            imageName = "cannonDown"
            break
        case Tile.specialTiles.emitterLeft.rawValue:
            imageName = "cannonLeft"
            break
        case Tile.specialTiles.emitterRight.rawValue:
            imageName = "cannonRight"
            break
        case Tile.specialTiles.emitterUp.rawValue:
            imageName = "cannonUp"
            break
        default:
            break
        }
        
        super.init(imageName: imageName, x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
