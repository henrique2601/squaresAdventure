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
    
    static var size:CGFloat = 128
    
    init(imageName:String, x:Int, y:Int) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: nil, size: texture.size())
        self.position = CGPoint(x: x * (Int)(Tile.size), y: y * -(Int)(Tile.size) + (Int)(Chunk.size - Tile.size))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
