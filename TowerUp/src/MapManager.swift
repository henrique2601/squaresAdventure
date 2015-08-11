//
//  MapManager.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MapManager: SKNode {
    
    var playerRegionX = 0
    var playerRegionY = 0
    var loadedRegionX = 0
    var loadedRegionY = 0
    
    static var bodies = [SKPhysicsBody]()
    
    static var loading:Bool = false
    var lastUpdate:NSTimeInterval = 0
    
    func reloadMap(position:CGPoint) {
        
        self.updatePlayerRegion(position)
        
        self.loadPhysics()
        
        var i = 0;
        for (var y = self.playerRegionY - 1; y <= self.playerRegionY + 1 ; y++) {
            for (var x = self.playerRegionX - 1; x <= self.playerRegionX + 1 ; x++) {
                let chunk = Chunk(regionX: x, regionY: y)
                chunk.name = "chunk\(i)"
                self.addChild(chunk);
                i++
            }
        }
        
        self.loadedRegionX = self.playerRegionX;
        self.loadedRegionY = self.playerRegionY;
    }
    
    func loadPhysics() {
        MapManager.bodies = []
        
        //Preload de fisica dos cenário.
        for (var i = 0; i < Ground.typeCount; i++) {
            var texture = SKTexture(imageNamed: "dirt\(i + 1)")//TODO tema do tile
            MapManager.bodies.append(SKPhysicsBody(texture: texture, alphaThreshold: 0.7,  size: texture.size()))
        }
    }
    
    func update(currentTime: NSTimeInterval, player:Player, region:Int) {
        if(!MapManager.loading) {
            if(currentTime - self.lastUpdate > 0.1) {
                self.updatePlayerRegion(player.position)
                if (self.playerRegionX != self.loadedRegionX || self.playerRegionY != self.loadedRegionY) {
                    MapManager.loading = true
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        self.loadMap()
                        MapManager.loading = false
                        self.lastUpdate = currentTime
                    }
                }
            }
        }
    }
    
    func updatePlayerRegion(position:CGPoint) {
        
        var positionX = position.x
        var positionY = position.y
        
        self.playerRegionX = Int(positionX / Chunk.size)
        self.playerRegionY = Int(positionY / Chunk.size)
        
        if (self.playerRegionY <= 0) {
            if (position.y / CGFloat(Chunk.size) < 0) {
                self.playerRegionY--;
            }
        }
        
        if (self.playerRegionX <= 0) {
            if (position.x / CGFloat(Chunk.size) < 0) {
                self.playerRegionX--;
            }
        }
    }
    
    func loadMap() {
        
        if (self.playerRegionX < self.loadedRegionX)
        {
            self.loadedRegionX--;
            self.loadA();
            return;
        }
        if (self.playerRegionY < self.loadedRegionY)
        {
            self.loadedRegionY--;
            self.loadS();
            return;
        }
        if (self.playerRegionX > self.loadedRegionX)
        {
            self.loadedRegionX++;
            self.loadD();
            return;
        }
        if (self.playerRegionY > self.loadedRegionY)
        {
            self.loadedRegionY++;
            self.loadW();
            return;
        }
    }
    
    func loadA() {
        /*
        6 7 8
        3 4 5
        0 1 2
        */
        let chunk8 = self.childNodeWithName("chunk8")! as! Chunk
        chunk8.removeAllChildren()
        chunk8.load(self.loadedRegionX - 1, regionY: self.loadedRegionY + 1)
        
        let chunk5 = self.childNodeWithName("chunk5")! as! Chunk
        chunk5.removeAllChildren()
        chunk5.load(self.loadedRegionX - 1, regionY: self.loadedRegionY + 0)
        
        let chunk2 = self.childNodeWithName("chunk2")! as! Chunk
        chunk2.removeAllChildren()
        chunk2.load(self.loadedRegionX - 1, regionY: self.loadedRegionY - 1)
        
        let chunk7 = self.childNodeWithName("chunk7")! as! Chunk
        let chunk4 = self.childNodeWithName("chunk4")! as! Chunk
        let chunk1 = self.childNodeWithName("chunk1")! as! Chunk
        
        let chunk6 = self.childNodeWithName("chunk6")! as! Chunk
        let chunk3 = self.childNodeWithName("chunk3")! as! Chunk
        let chunk0 = self.childNodeWithName("chunk0")! as! Chunk
        
        chunk8.name = "chunk6"
        chunk5.name = "chunk3"
        chunk2.name = "chunk0"
        
        chunk7.name = "chunk8"
        chunk4.name = "chunk5"
        chunk1.name = "chunk2"
        
        chunk6.name = "chunk7"
        chunk3.name = "chunk4"
        chunk0.name = "chunk1"
    }
    
    func loadS() {
        /*
        6 7 8
        3 4 5
        0 1 2
        */
        let chunk6 = self.childNodeWithName("chunk6")! as! Chunk
        chunk6.removeAllChildren()
        chunk6.load(self.loadedRegionX - 1, regionY: self.loadedRegionY - 1)
        
        let chunk7 = self.childNodeWithName("chunk7")! as! Chunk
        chunk7.removeAllChildren()
        chunk7.load(self.loadedRegionX + 0, regionY: self.loadedRegionY - 1)
        
        let chunk8 = self.childNodeWithName("chunk8")! as! Chunk
        chunk8.removeAllChildren()
        chunk8.load(self.loadedRegionX + 1, regionY: self.loadedRegionY - 1)
        
        let chunk0 = self.childNodeWithName("chunk0")! as! Chunk
        let chunk1 = self.childNodeWithName("chunk1")! as! Chunk
        let chunk2 = self.childNodeWithName("chunk2")! as! Chunk
        
        let chunk3 = self.childNodeWithName("chunk3")! as! Chunk
        let chunk4 = self.childNodeWithName("chunk4")! as! Chunk
        let chunk5 = self.childNodeWithName("chunk5")! as! Chunk
        
        chunk6.name = "chunk0"
        chunk7.name = "chunk1"
        chunk8.name = "chunk2"
        
        chunk0.name = "chunk3"
        chunk1.name = "chunk4"
        chunk2.name = "chunk5"
        
        chunk3.name = "chunk6"
        chunk4.name = "chunk7"
        chunk5.name = "chunk8"
    }
    
    func loadD() {
        /*
        6 7 8
        3 4 5
        0 1 2
        */
        let chunk6 = self.childNodeWithName("chunk6")! as! Chunk
        chunk6.removeAllChildren()
        chunk6.load(self.loadedRegionX + 1, regionY: self.loadedRegionY + 1)
        
        let chunk3 = self.childNodeWithName("chunk3")! as! Chunk
        chunk3.removeAllChildren()
        chunk3.load(self.loadedRegionX + 1, regionY: self.loadedRegionY + 0)
        
        let chunk0 = self.childNodeWithName("chunk0")! as! Chunk
        chunk0.removeAllChildren()
        chunk0.load(self.loadedRegionX + 1, regionY: self.loadedRegionY - 1)
        
        let chunk7 = self.childNodeWithName("chunk7")! as! Chunk
        let chunk4 = self.childNodeWithName("chunk4")! as! Chunk
        let chunk1 = self.childNodeWithName("chunk1")! as! Chunk
        
        let chunk8 = self.childNodeWithName("chunk8")! as! Chunk
        let chunk5 = self.childNodeWithName("chunk5")! as! Chunk
        let chunk2 = self.childNodeWithName("chunk2")! as! Chunk
        
        chunk6.name = "chunk8"
        chunk3.name = "chunk5"
        chunk0.name = "chunk2"
        
        chunk8.name = "chunk7"
        chunk5.name = "chunk4"
        chunk2.name = "chunk1"
        
        chunk7.name = "chunk6"
        chunk4.name = "chunk3"
        chunk1.name = "chunk0"
    }
    
    func loadW() {
        /*
        6 7 8
        3 4 5
        0 1 2
        */
        let chunk0 = self.childNodeWithName("chunk0")! as! Chunk
        chunk0.removeAllChildren()
        chunk0.load(self.loadedRegionX - 1, regionY: self.loadedRegionY + 1)
        
        let chunk1 = self.childNodeWithName("chunk1")! as! Chunk
        chunk1.removeAllChildren()
        chunk1.load(self.loadedRegionX + 0, regionY: self.loadedRegionY + 1)
        
        let chunk2 = self.childNodeWithName("chunk2")! as! Chunk
        chunk2.removeAllChildren()
        chunk2.load(self.loadedRegionX + 1, regionY: self.loadedRegionY + 1)
        
        let chunk3 = self.childNodeWithName("chunk3")! as! Chunk
        let chunk4 = self.childNodeWithName("chunk4")! as! Chunk
        let chunk5 = self.childNodeWithName("chunk5")! as! Chunk
        
        let chunk6 = self.childNodeWithName("chunk6")! as! Chunk
        let chunk7 = self.childNodeWithName("chunk7")! as! Chunk
        let chunk8 = self.childNodeWithName("chunk8")! as! Chunk
        
        
        chunk0.name = "chunk6"
        chunk1.name = "chunk7"
        chunk2.name = "chunk8"
        
        chunk3.name = "chunk0"
        chunk4.name = "chunk1"
        chunk5.name = "chunk2"
        
        chunk6.name = "chunk3"
        chunk7.name = "chunk4"
        chunk8.name = "chunk5"
    }
}
