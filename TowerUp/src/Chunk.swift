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
    
    static var maxChunkX = 0
    static var maxChunkY = 0
    
    //var type:String = MapManager.tower == -1 ? Towers.types[Int.random(Towers.types.count)].tileset : Towers.types[MapManager.tower].tileset
    var type:String = MapManager.tower == -1 ? Towers.types[MapManager.floor % Towers.types.count].tileset : Towers.types[MapManager.tower].tileset
    
    
    init(tower:Int, floor:Int, regionX:Int, regionY:Int) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSize(width: Chunk.sizeInPoints, height: Chunk.sizeInPoints))
        
        self.anchorPoint = CGPointZero
        self.load(tower, floor:floor, regionX: regionX, regionY: regionY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeAllChildren() {
        dispatch_async(dispatch_get_main_queue()) {
            super.removeAllChildren()
        }
    }
    
    func loadVisual(data: [AnyObject]) {
        var i = 0
        let tiles:NSMutableArray = NSMutableArray()
        for (var y = 0; y < Int(Chunk.sizeInTiles); y++) {
            for (var x = 0; x <  Int(Chunk.sizeInTiles); x++) {
                let id = data[i].integerValue
                if(id != 0) {
                    var tile:Tile!
                    
                    tile = VisualTile(id: id, x: x, y: y)
                    
                    //TODO: exportar função?
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
    
    func loadGround(data: [AnyObject]) {
        var floorData:FloorData!
        
        if (MapManager.tower >= 0) {
            floorData = MemoryCard.sharedInstance.currentFloor()
        }
        
        var i = 0
        let tiles:NSMutableArray = NSMutableArray()
        for (var y = 0; y < Int(Chunk.sizeInTiles); y++) {
            for (var x = 0; x <  Int(Chunk.sizeInTiles); x++) {
                let id = data[i].integerValue
                if(id != 0) {
                    var tile:Tile!
                    if(id > 64) {
                        switch(id) {
                        case Tile.specialTiles.coinTile.rawValue:
                            tile = Coin(type: "Gold", x: x, y: y)
                            break
                        case Tile.specialTiles.winTile.rawValue:
                            tile = WinTile(type: self.type, x: x, y: y)
                            break
                        case Tile.specialTiles.spikeTile.rawValue:
                            tile = Spike(x: x, y: y)
                            break
                            
                        case Tile.specialTiles.bomb.rawValue:
                            tile = Bomb(x: x, y: y)
                            break
                            
                        case Tile.specialTiles.boxCreate.rawValue:
                            tile = BoxCrate(x: x, y: y)
                            break
                            
                        case Tile.specialTiles.gem.rawValue:
                            if (MapManager.tower >= 0) {
                                if(floorData.gemAvailable == true) {
                                    tile = Gem(type: "Blue", x: x, y: y)
                                } else {
                                    tile = Coin(type: "Gold", x: x, y: y)
                                }
                            } else {
                                tile = Coin(type: "Gold", x: x, y: y)
                            }
                            break
                            
                        case Tile.specialTiles.spring.rawValue:
                            tile = Spring(x: x, y: y)
                            break
                            
                        case Tile.specialTiles.saw.rawValue:
                            tile = Saw(x: x, y: y)
                            break
                            
                        case Tile.specialTiles.woodenBridge.rawValue:
                            tile = Ground(type: self.type, imageName: "bridgeB", x: x, y: y)
                            break

                        default:
                            tile = Bug(x: x, y: y)
                            print("Tile \(id) inesperadamente encontrou nulo. s;")
                            break
                        }
                    } else {
                        tile = Ground(type: self.type, id: id, x: x, y: y)
                    }
                    
                    //TODO: exportar função?
                    //MapManager.loading é setado para true durante o update do MapManager. No carregamento inicial seu valor é false
                    if(MapManager.loading) {
                        tiles.addObject(tile)
                    } else {
                        self.addChild(tile)
                    }
                } else {
                    #if DEBUG //DEBUG com itens colocados aleatoriamente em espaços vazios.
//                    if(Int.random(101) <= 10) {
//                        let tile:Coin = Coin(type: "Gold", x: x, y: y)
//                        
//                        //TODO: exportar função?
//                        //MapManager.loading é setado para true durante o update do MapManager. No carregamento inicial seu valor é false
//                        if(MapManager.loading) {
//                            tiles.addObject(tile)
//                        } else {
//                            self.addChild(tile)
//                        }
//                    }
                    #endif
                }
                i++
            }
        }
        
        //TODO: let tempo, numero de moedas e numero de mortes
        
        if(MapManager.loading){
            dispatch_async(dispatch_get_main_queue()) {
                for tile in tiles {
                    self.addChild(tile as! SKNode)
                }
            }
        }
    }
    
    func clean() {
        //Remove obejetos que cairem para fora do cenario
        let coins = Coin.coinList
        if(coins.count > 0) {
            for(var i = coins.count - 1; i >= 0; i--) {
                if let coin = coins.objectAtIndex(i) as? Coin {
                    if(coin.position.y < -128) {
                        coin.removeFromParent()
                    }
                }
            }
        }
    }
    
    func load(tower:Int, floor:Int, regionX:Int, regionY:Int) {
        self.position = CGPoint(x: self.size.width * (CGFloat)(regionX), y: self.size.height * (CGFloat)(regionY))

        if let path = NSBundle.mainBundle().pathForResource("ground \(tower) \(floor) \(regionX) \(regionY)", ofType: "") {
            self
            let data = (try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)).componentsSeparatedByString(",")
            self.loadGround(data)
        }
        
        if let path = NSBundle.mainBundle().pathForResource("visual \(tower) \(floor) \(regionX) \(regionY)", ofType: "") {
            let data = (try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)).componentsSeparatedByString(",")
            self.loadVisual(data)
        }
    }
}
