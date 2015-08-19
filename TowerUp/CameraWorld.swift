//
//  CameraWorld.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 18/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class CameraWorld: Camera {

    override func update(newPosition:CGPoint) {
        
        self.position = CGPoint(x: newPosition.x - self.scene!.size.width/2 , y: newPosition.y + self.scene!.size.height/2)
        
        
        
    
            if(position.x > self.scene!.size.width - Tile.sizeInPoints/2){
                
                if(position.x > self.scene!.size.width){
                }
                else{
                    position.x = self.scene!.size.width
                    
                    println("Fora da tela")
                }

                position.x = self.scene!.size.width - Tile.sizeInPoints/2
                
}
        
        
        //certo
        if(position.x < -Tile.sizeInPoints/2){
            position.x = -Tile.sizeInPoints/2
        }
        
        //certo
//        
//        if((position.x > self.scene!.size.width - Tile.sizeInPoints/2) && ){
//        
//        }
//        
//        
        //certo
        
        if(position.y > Chunk.sizeInPoints - Tile.sizeInPoints / 2){
            position.y = Chunk.sizeInPoints - Tile.sizeInPoints / 2
        }
        
        //certo
        if(position.y < self.scene!.size.height - Tile.sizeInPoints/2){
            position.y = self.scene!.size.height - Tile.sizeInPoints/2
        }
        
        self.scene!.centerOnNode(self)
        
        println (Chunk.sizeInPoints)
    }
}
