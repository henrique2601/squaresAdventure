//
//  Chunk.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Chunk: SKSpriteNode, XMLParserDelegate {
    
    var layer = ""
    var height = ""
    var width = ""
    
    static var sizeInTilesX:CGFloat = 21
    static var sizeInTilesY:CGFloat = 21
    
    static var sizeInPointsX:CGFloat = Tile.sizeInPoints * sizeInTilesX
    static var sizeInPointsY:CGFloat = Tile.sizeInPoints * sizeInTilesY
    
    static var maxChunkX = 0
    static var maxChunkY = 0
    
    //var type:String = MapManager.tower == -1 ? Towers.types[Int.random(Towers.types.count)].tileset : Towers.types[MapManager.tower].tileset
    var type:String = MapManager.tower == -1 ? Towers.types[MapManager.floor % Towers.types.count].tileset : Towers.types[MapManager.tower].tileset
    
    static var lastType:String!
    
    
    init(tower:Int, floor:Int, regionX:Int, regionY:Int) {
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: Chunk.sizeInPointsX, height: Chunk.sizeInPointsY))
        
        self.anchorPoint = CGPoint.zero
        self.load(tower: tower, floor:floor, regionX: regionX, regionY: regionY)
    }
    
    init(tower:Int, floor:Int) {
        super.init(texture: nil, color: UIColor.clear, size: CGSize.zero)
        
        self.anchorPoint = CGPoint.zero
        self.load(tower: tower, floor:floor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeAllChildren() {
        DispatchQueue.main.async {
            super.removeAllChildren()
        }
    }
    
    func loadVisual(data: [AnyObject], width:CGFloat = Chunk.sizeInTilesX, height:CGFloat = Chunk.sizeInTilesY) {
        var i = 0
        let tiles:NSMutableArray = NSMutableArray()
        for y in 0..<Int(height) {
            for x in 0..<Int(width) {
                let aux = String(data[i]).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let id = Int(aux)!
                if(id != 0) {
                    var tile:Tile!
                    
                    tile = VisualTile(id: id, x: x, y: y)
                    
                    //TODO: exportar função?
                    //MapManager.loading é setado para true durante o update do MapManager. No carregamento inicial seu valor é false
                    if(MapManager.loading) {
                        tiles.add(tile)
                    } else {
                        self.addChild(tile)
                    }
                }
                i += 1
            }
        }
        
        if(MapManager.loading){
            DispatchQueue.main.async {
                for tile in tiles {
                    self.addChild(tile as! SKNode)
                }
            }
        }
    }
    
    func loadGround(data: [AnyObject], width:CGFloat = Chunk.sizeInTilesX, height:CGFloat = Chunk.sizeInTilesY) {
        var floorData:FloorData!
        
        if (MapManager.tower >= 0) {
            floorData = MemoryCard.sharedInstance.currentFloor()
        }
        var coinsInChunk = 0
        var i = 0
        let tiles:NSMutableArray = NSMutableArray()
        for y in 0 ..< Int(height) {
            for x in 0 ..<  Int(width) {
                let aux = String(data[i]).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let id = Int(aux)!
                if(id != 0) {
                    var tile:Tile!
                    if(id > 64) {
                        switch(id) {
                        case Tile.specialTiles.coinTile.rawValue:
                            tile = Coin(type: "Gold", x: x, y: y)
                            coinsInChunk += 1
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
                            
                        case Tile.specialTiles.slime.rawValue:
                            tile = Slime(x: x, y: y)
                            break
                            
                        case Tile.specialTiles.emitterLeft.rawValue:
                            tile = Emitter(x: x, y: y, specialTiles: id)
                            break
                            
                        case Tile.specialTiles.emitterUp.rawValue:
                            tile = Emitter(x: x, y: y, specialTiles: id)
                            break
                            
                        case Tile.specialTiles.emitterRight.rawValue:
                            tile = Emitter(x: x, y: y, specialTiles: id)
                            break
                            
                        case Tile.specialTiles.emitterDown.rawValue:
                            tile = Emitter(x: x, y: y, specialTiles: id)
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
                        tiles.add(tile)
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
                i += 1
            }
        }
        
        if ( MapManager.tower >= 0) {
            if(Towers.types[MapManager.tower].floorTypes[MapManager.floor].minCoins == 0) {
                Towers.types[MapManager.tower].floorTypes[MapManager.floor].minCoins = coinsInChunk
            }
        }
        
        if(MapManager.loading){
            DispatchQueue.main.async {
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
            for i in coins.count - 1 ... 0 {
                if let coin = coins.object(at: i) as? Coin {
                    if(coin.position.y < -128) {
                        coin.removeFromParent()
                    }
                }
            }
        }
    }
    
    func load(tower:Int, floor:Int, regionX:Int, regionY:Int) {
        self.position = CGPoint(x: self.size.width * (CGFloat)(regionX), y: self.size.height * (CGFloat)(regionY))

        if let path = Bundle.main.path(forResource: "ground \(tower) \(floor) \(regionX) \(regionY)", ofType: "") {
            let data = (try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)).components(separatedBy: ",")
            self.loadGround(data: data as [AnyObject])
            Chunk.maxChunkX = max(regionX, Chunk.maxChunkX)
            Chunk.maxChunkY = max(regionY, Chunk.maxChunkY)
            
            if(Chunk.sizeInTilesX * Chunk.sizeInTilesY != CGFloat(data.count)) {
                print("ERROR: ground \(tower) \(floor) \(regionX) \(regionY) data.count: " + data.count.description)
            }
        }
        
        if let path = Bundle.main.path(forResource: "visual \(tower) \(floor) \(regionX) \(regionY)", ofType: "") {
            let data = (try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)).components(separatedBy: ",")
            self.loadVisual(data: data as [AnyObject])
        }
    }
    
    func load(tower:Int, floor:Int) {
        
        if let url = Bundle.main.url(forResource: "\(tower) \(floor)", withExtension: "tmx") {
            
            let xmlParser = XMLParser.init(contentsOf: url)!
            xmlParser.delegate = self
            
            xmlParser.parse()
            
            
//            let data = (try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)).componentsSeparatedByString(",")
//            self.loadGround(data)
        }
        
//        if let path = NSBundle.mainBundle().pathForResource("visual \(tower) \(floor) \(regionX) \(regionY)", ofType: "") {
//            let data = (try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)).componentsSeparatedByString(",")
//            self.loadVisual(data)
//        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        print(elementName)
//        print(namespaceURI)
//        print(qName)
//        print(attributeDict)
        
        switch elementName {
        case "layer":
            self.layer = attributeDict["name"]!
            self.width = attributeDict["width"]!
            self.height = attributeDict["height"]!
            
            
            Chunk.sizeInTilesX = CGFloat(Int(self.width)!)
            Chunk.sizeInTilesY = CGFloat(Int(self.height)!)
            
            Chunk.sizeInPointsX = Tile.sizeInPoints * Chunk.sizeInTilesX
            Chunk.sizeInPointsY = Tile.sizeInPoints * Chunk.sizeInTilesY
            
            Chunk.maxChunkX = 0
            Chunk.maxChunkY = 0
            
            self.position = CGPoint(x: 0, y: 0)
            
            break
        case "tileset":
            if(attributeDict["firstgid"] == "1") {
                self.type = attributeDict["name"]!
                Chunk.lastType = self.type
            }
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.components(separatedBy: ",")
        
        if(data.count >= 441) {
            switch self.layer {
            case "ground":
                self.loadGround(data: data as [AnyObject], width:CGFloat(Int(self.width)!), height:CGFloat(Int(self.height)!))
                break
            case "visual":
                self.loadVisual(data: data as [AnyObject], width:CGFloat(Int(self.width)!), height:CGFloat(Int(self.height)!))
                break
            default:
                break
            }
        }
    }
}
