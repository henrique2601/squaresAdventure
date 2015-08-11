//
//  Chunk.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Chunk: SKSpriteNode {
    
    static var sizeInTiles:CGFloat = 21
    static var size:CGFloat = Tile.size * sizeInTiles
    
    var type = "dirt"
    
    init(regionX:Int, regionY:Int) {
        
        #if DEBUG
            let texture = SKTexture(imageNamed: "chunkBackground")
        #else
            let texture = nil
        #endif
        
        super.init(texture: texture, color: nil, size: CGSize(width: Chunk.size, height: Chunk.size))
        self.anchorPoint = CGPointZero
        self.load(regionX, regionY: regionY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeAllChildren() {
        dispatch_async(dispatch_get_main_queue()) {
            super.removeAllChildren()
        }
    }
    
    func loadData(data: NSArray){
        var i = 0
        var tiles:NSMutableArray = NSMutableArray()
        for (var y = 0; y < Int(Chunk.sizeInTiles); y++) {
            for (var x = 0; x <  Int(Chunk.sizeInTiles); x++) {
                if(data[i].integerValue != 0) {
                    var tile = Ground(imageName: self.type + data[i].stringValue, x:x, y:y)
                    
                    //MapManager.loading é setado para true durante o update do MapManager. No carregamento inicial seu valor é false
                    if(MapManager.loading) {
                        tiles.addObject(tile)
                    } else {
                        self.addChild(tile)
                    }
                }
                i++
            }
        }
        
        if(MapManager.loading){
            dispatch_async(dispatch_get_main_queue()) {
                for tile in tiles {
                    self.addChild(tile as! SKNode)
                }
            }
        }
    }
    
    func load(regionX:Int, regionY:Int) {
        
        self.position = CGPoint(x: self.size.width * (CGFloat)(regionX),
            y: self.size.height * (CGFloat)(regionY))
        
        
        switch ("\(regionX) \(regionY)") {
            
            //        case "0 0":
            //            self.loadData([0,0])
            //            break
            
        default:
            break
        }
    }
}
