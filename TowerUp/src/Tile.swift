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
    
    internal enum specialTiles:Int {
        case coinTile  = 65
        case winTile   = 66
        case spikeTile = 67
        case bomb = 68
        case boxCreate = 69
        case gem = 70
        case saw = 71
        case woodenBridge = 72
        case spring = 73
        case slime = 74
    }
    
    static var sizeInPoints:CGFloat = 128/2
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(imageName:String, x:Int, y:Int) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.position = CGPoint(x: x * (Int)(Tile.sizeInPoints), y: y * -(Int)(Tile.sizeInPoints) + (Int)(Chunk.sizeInPointsY - Tile.sizeInPoints))
        self.zPosition = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
