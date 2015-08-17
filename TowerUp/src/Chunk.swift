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
    static var sizeInPoints:CGFloat = Tile.sizeInPoints * sizeInTiles
    
    var type = "dirt" //TODO 
    
    init(regionX:Int, regionY:Int) {
        super.init(texture: nil, color: nil, size: CGSize(width: Chunk.sizeInPoints, height: Chunk.sizeInPoints))
        
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
                    var tile = Ground(type: self.type, id: data[i].integerValue, x: x, y: y)
                    
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
        self.position = CGPoint(x: self.size.width * (CGFloat)(regionX), y: self.size.height * (CGFloat)(regionY))
        
        switch ("\(regionX) \(regionY)") {
            
        case "0 0":
            self.loadData([
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,20,
                19,0,6,17,17,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,16,17,18,0,0,0,0,0,20,
                19,0,0,0,0,0,0,0,16,17,18,0,0,0,0,0,1,0,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,16,17,18,0,0,0,0,0,0,0,0,0,0,1,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,0,16,17,18,0,0,0,0,0,0,16,17,18,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,20,
                19,0,0,0,0,0,0,0,0,0,16,17,18,0,0,0,0,16,17,9,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,16,17,18,0,0,0,0,0,0,0,16,17,18,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,16,17,18,0,0,0,0,0,0,6,7,0,0,16,17,18,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,16,17,18,0,0,0,0,0,16,17,18,0,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,0,0,0,0,16,17,18,0,0,0,0,0,0,0,20,
                19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,
                8,17,0,16,17,18,0,16,17,17,18,0,16,18,0,16,17,17,17,17,9
])
            break
            
        default:
            break
        }
    }
}
