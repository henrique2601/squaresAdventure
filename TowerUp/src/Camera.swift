//
//  Camera.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class GameCamera: SKNode {
    
    var maxX:CGFloat = 0
    var maxY:CGFloat = 0
    
    func update(newPosition:CGPoint) {
        
        self.position = CGPoint(x: Int(newPosition.x - self.scene!.size.width/2), y: Int(newPosition.y + self.scene!.size.height/2))
        
         self.maxX = Chunk.sizeInPoints * CGFloat(Chunk.maxChunkX)
         self.maxY = Chunk.sizeInPoints * CGFloat(Chunk.maxChunkY)
        
        //certo
        if(position.x < -Tile.sizeInPoints/2 ){
            position.x =  -Tile.sizeInPoints/2
        }
        
        //certo
        if(position.x > self.scene!.size.width - Tile.sizeInPoints/2 + self.maxX){
            position.x = self.scene!.size.width - Tile.sizeInPoints/2 + self.maxX
        }
        //certo
        
        if(position.y > Chunk.sizeInPoints - Tile.sizeInPoints / 2 + self.maxY) {
            position.y = Chunk.sizeInPoints - Tile.sizeInPoints / 2 + self.maxY
        }
        
        //certo
        if(position.y < self.scene!.size.height - Tile.sizeInPoints/2  ){
            position.y = self.scene!.size.height - Tile.sizeInPoints/2
        }
        
        self.scene!.centerOnNode(self)
    }
}

public extension SKScene {
    func centerOnNode(node:SKNode)
    {
        if let parent = node.parent {
            let cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: parent)
            parent.position = CGPoint(
                x: CGFloat(Int(parent.position.x - cameraPositionInScene.x)),
                y: CGFloat(Int(parent.position.y - cameraPositionInScene.y)))
        }
    }
}
