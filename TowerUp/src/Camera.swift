//
//  Camera.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Camera: SKNode {
    
    var maxX:CGFloat = 0
    var maxY:CGFloat = 0
    
    func update(newPosition:CGPoint) {
        
        
         self.maxX = Chunk.sizeInPoints * CGFloat(Chunk.maxChunkX)
         self.maxY = Chunk.sizeInPoints * CGFloat(Chunk.maxChunkY)
        
        self.position = CGPoint(x: newPosition.x - self.scene!.size.width/2 , y: newPosition.y + self.scene!.size.height/2)
        
        //certo
        if(position.x < -Tile.sizeInPoints/2 ){
            position.x = -Tile.sizeInPoints/2
        }
        
        //certo
        if(position.x > self.scene!.size.width - Tile.sizeInPoints/2 + self.maxX){
            position.x = self.scene!.size.width - Tile.sizeInPoints/2 + self.maxX
        }
        //certo
        
        if(position.y > Chunk.sizeInPoints - Tile.sizeInPoints / 2 + self.maxY){
            position.y = Chunk.sizeInPoints - Tile.sizeInPoints / 2 + self.maxY
        }
        
        //certo
        if(position.y < self.scene!.size.height - Tile.sizeInPoints/2  ){
            position.y = self.scene!.size.height - Tile.sizeInPoints/2
        }
        
        self.scene!.centerOnNode(self)
    
    
    
    
    }
}
