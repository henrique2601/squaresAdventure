//
//  Tile.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Tile: SKSpriteNode {
    
    static var sizeInPoints:CGFloat = 128/2
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(imageName:String, x:Int, y:Int) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: nil, size: texture.size())
        self.position = CGPoint(x: x * (Int)(Tile.sizeInPoints), y: y * -(Int)(Tile.sizeInPoints) + (Int)(Chunk.sizeInPoints - Tile.sizeInPoints))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum specialTiles:Int {
    case winTile   = 1001
    case coinTile  = 1002
    case spikeTile = 1003
    case doorTile = 1004
}
