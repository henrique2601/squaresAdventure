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
    
    static var tower = 0 {
        didSet {
            if MapManager.tower >= 0 {
                
                MemoryCard.sharedInstance.playerData.lastPlayedTower = NSNumber(value: MapManager.tower)
            }
        }
    }
    static var floor = 0 {
        didSet {
            if MapManager.tower >= 0 {
                MemoryCard.sharedInstance.currentTower().lastPlayedFloor = NSNumber(value: MapManager.floor)
            }
        }
    }
    
    static var bodies = [SKPhysicsBody]()
    
    static var loading:Bool = false
    var lastUpdate:TimeInterval = 0
    
    func reloadMap(position:CGPoint) {
        Chunk.maxChunkX = 0
        Chunk.maxChunkY = 0
        
        self.removeAllChildren()
        
        self.updatePlayerRegion(position: position)
        
        self.loadPhysics()
        
        let chunk = Chunk(tower: MapManager.tower, floor:MapManager.floor)
        self.addChild(chunk)
        
//        var i = 0
//        for (var y = self.playerRegionY - 1; y <= self.playerRegionY + 1 ; y += 1) {
//            for (var x = self.playerRegionX - 1; x <= self.playerRegionX + 1 ; x += 1) {
//                let chunk = Chunk(tower: MapManager.tower, floor:MapManager.floor, regionX: x, regionY: y)
//                chunk.name = "chunk\(i)"
//                self.addChild(chunk)
//                i += 1
//            }
//        }
        
        self.loadedRegionX = self.playerRegionX
        self.loadedRegionY = self.playerRegionY
    }
    
    func loadPhysics() {
        MapManager.bodies = []
        
        //Preload de fisica dos cenário.
        for i in 0 ..< Ground.typeCount {
            let texture = SKTexture(imageNamed: "grass\(i + 1)")//TODO: tema do tile
            if #available(iOS 8.0, *) {
                MapManager.bodies.append(SKPhysicsBody(texture: texture, alphaThreshold: 0.7,  size: texture.size()))
            } else {
                // Fallback on earlier versions
                self.physicsBody = SKPhysicsBody(rectangleOf: texture.size())
            }
        }
    }
    
    func update(currentTime: TimeInterval, position:CGPoint) {
        if(!MapManager.loading) {
            if(currentTime - self.lastUpdate > 0.1) {
                self.updatePlayerRegion(position: position)
                if (self.playerRegionX != self.loadedRegionX || self.playerRegionY != self.loadedRegionY) {
                    MapManager.loading = true
                    DispatchQueue.global(qos: .userInteractive).async {
                        self.loadMap()
                        MapManager.loading = false
                        self.lastUpdate = currentTime
                    }
                }
            }
        }
    }
    
    func update(currentTime: TimeInterval) {
        if(!MapManager.loading) {
            if(currentTime - self.lastUpdate > 0.5) {
                MapManager.loading = true
                DispatchQueue.global(qos: .userInteractive).async {
                    //self.cleanChunks()
                    MapManager.loading = false
                    self.lastUpdate = currentTime
                }
            }
        }
    }
    
//    func cleanChunks() {
//        for(var i = 0; i < 9; i += 1) {
//            let chunk = self.childNodeWithName("chunk\(i)")! as! Chunk
//            //chunk.clean()
//        }
//    }
    
    func updatePlayerRegion(position:CGPoint) {
        
        let positionX = position.x
        let positionY = position.y
        
        self.playerRegionX = Int(positionX / Chunk.sizeInPointsX)
        self.playerRegionY = Int(positionY / Chunk.sizeInPointsY)
        
        if (self.playerRegionY <= 0) {
            if (position.y / CGFloat(Chunk.sizeInPointsY) < 0) {
                self.playerRegionY -= 1
            }
        }
        
        if (self.playerRegionX <= 0) {
            if (position.x / CGFloat(Chunk.sizeInPointsX) < 0) {
                self.playerRegionX -= 1
            }
        }
    }
    
    func loadMap() {
        
        if (self.playerRegionX < self.loadedRegionX)
        {
            self.loadedRegionX -= 1
            self.loadA()
            return
        }
        if (self.playerRegionY < self.loadedRegionY)
        {
            self.loadedRegionY -= 1
            self.loadS()
            return
        }
        if (self.playerRegionX > self.loadedRegionX)
        {
            self.loadedRegionX += 1
            self.loadD()
            return
        }
        if (self.playerRegionY > self.loadedRegionY)
        {
            self.loadedRegionY += 1
            self.loadW()
            return
        }
    }
    
    func loadA() {
        /*
        6 7 8
        3 4 5
        0 1 2
        */
        let chunk8 = self.childNode(withName: "chunk8")! as! Chunk
        chunk8.removeAllChildren()
        chunk8.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX - 1, regionY: self.loadedRegionY + 1)
        
        let chunk5 = self.childNode(withName: "chunk5")! as! Chunk
        chunk5.removeAllChildren()
        chunk5.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX - 1, regionY: self.loadedRegionY + 0)
        
        let chunk2 = self.childNode(withName: "chunk2")! as! Chunk
        chunk2.removeAllChildren()
        chunk2.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX - 1, regionY: self.loadedRegionY - 1)
        
        let chunk7 = self.childNode(withName: "chunk7")! as! Chunk
        let chunk4 = self.childNode(withName: "chunk4")! as! Chunk
        let chunk1 = self.childNode(withName: "chunk1")! as! Chunk
        
        let chunk6 = self.childNode(withName: "chunk6")! as! Chunk
        let chunk3 = self.childNode(withName: "chunk3")! as! Chunk
        let chunk0 = self.childNode(withName: "chunk0")! as! Chunk
        
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
        let chunk6 = self.childNode(withName: "chunk6")! as! Chunk
        chunk6.removeAllChildren()
        chunk6.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX - 1, regionY: self.loadedRegionY - 1)
        
        let chunk7 = self.childNode(withName: "chunk7")! as! Chunk
        chunk7.removeAllChildren()
        chunk7.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 0, regionY: self.loadedRegionY - 1)
        
        let chunk8 = self.childNode(withName: "chunk8")! as! Chunk
        chunk8.removeAllChildren()
        chunk8.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 1, regionY: self.loadedRegionY - 1)
        
        let chunk0 = self.childNode(withName: "chunk0")! as! Chunk
        let chunk1 = self.childNode(withName: "chunk1")! as! Chunk
        let chunk2 = self.childNode(withName: "chunk2")! as! Chunk
        
        let chunk3 = self.childNode(withName: "chunk3")! as! Chunk
        let chunk4 = self.childNode(withName: "chunk4")! as! Chunk
        let chunk5 = self.childNode(withName: "chunk5")! as! Chunk
        
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
        let chunk6 = self.childNode(withName: "chunk6")! as! Chunk
        chunk6.removeAllChildren()
        chunk6.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 1, regionY: self.loadedRegionY + 1)
        
        let chunk3 = self.childNode(withName: "chunk3")! as! Chunk
        chunk3.removeAllChildren()
        chunk3.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 1, regionY: self.loadedRegionY + 0)
        
        let chunk0 = self.childNode(withName: "chunk0")! as! Chunk
        chunk0.removeAllChildren()
        chunk0.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 1, regionY: self.loadedRegionY - 1)
        
        let chunk7 = self.childNode(withName: "chunk7")! as! Chunk
        let chunk4 = self.childNode(withName: "chunk4")! as! Chunk
        let chunk1 = self.childNode(withName: "chunk1")! as! Chunk
        
        let chunk8 = self.childNode(withName: "chunk8")! as! Chunk
        let chunk5 = self.childNode(withName: "chunk5")! as! Chunk
        let chunk2 = self.childNode(withName: "chunk2")! as! Chunk
        
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
        let chunk0 = self.childNode(withName: "chunk0")! as! Chunk
        chunk0.removeAllChildren()
        chunk0.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX - 1, regionY: self.loadedRegionY + 1)
        
        let chunk1 = self.childNode(withName: "chunk1")! as! Chunk
        chunk1.removeAllChildren()
        chunk1.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 0, regionY: self.loadedRegionY + 1)
        
        let chunk2 = self.childNode(withName: "chunk2")! as! Chunk
        chunk2.removeAllChildren()
        chunk2.load(tower: MapManager.tower, floor: MapManager.floor, regionX: self.loadedRegionX + 1, regionY: self.loadedRegionY + 1)
        
        let chunk3 = self.childNode(withName: "chunk3")! as! Chunk
        let chunk4 = self.childNode(withName: "chunk4")! as! Chunk
        let chunk5 = self.childNode(withName: "chunk5")! as! Chunk
        
        let chunk6 = self.childNode(withName: "chunk6")! as! Chunk
        let chunk7 = self.childNode(withName: "chunk7")! as! Chunk
        let chunk8 = self.childNode(withName: "chunk8")! as! Chunk
        
        
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
    
    func getRegionsX()->(Int){
        return(loadedRegionX)
    }
    
    func getRegionsY()->(Int){
        return(loadedRegionY)
    }
}
