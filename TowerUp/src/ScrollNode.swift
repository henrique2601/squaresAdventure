//
//  ScrollNode.swift
//  TowerUp
//
//  Created by Pablo Henrique on 31/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class ScrollNode: Control {
    
    enum scrollTypes {
        case horizontal
        case vertical
    }
    
    static var scrollNodeList:Set<ScrollNode> = Set<ScrollNode>()
    
    var cells:Set<SKSpriteNode> = Set<SKSpriteNode>()
    
    var scrollType = scrollTypes.horizontal
    
    init(name:String, x:Int, y:Int, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up, count:count, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up, count:count, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center, count:count, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, count:count, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center, count:count, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign, count:count, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        NSException.raise("Parâmetro count:Int deve ser maior que um ou use a classe Control.", format: "", arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer<Void>()))
    }
    
    func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int, scrollDirection:scrollTypes) {
        if(count <= 1){
            NSException.raise("Parâmetro count:Int deve ser maior que um ou use a classe Control.", format: "", arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer<Void>()))
        }
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        let texture = SKTexture(imageNamed: textureName)
        
        for (var i = 0; i < count; i++) {
            let spriteNode = SKSpriteNode(texture: texture, color: nil, size: texture.size())
            spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
            spriteNode.name = name + i.description
            spriteNode.position = CGPoint(x: (Int(spriteNode.size.width) + spacing) * i, y: 0)
            self.cells.insert(spriteNode)
            self.addChild(spriteNode)
        }
        ScrollNode.scrollNodeList.insert(self)
    }
    
    class func update(scene: SKNode) {
        for scrollNode in ScrollNode.scrollNodeList {
            switch(scrollNode.scrollType) {
            case scrollTypes.horizontal:
                for cell in scrollNode.cells {
                    var position = cell.position
                    cell.position = CGPoint(x: Int(position.x) + Control.dx, y: Int(position.y))
                }
                break
            case scrollTypes.vertical:
                for cell in scrollNode.cells {
                    var position = cell.position
                    cell.position = CGPoint(x: Int(position.x), y: Int(position.y) + Control.dy)
                }
                break
            default:
                #if !DEBUG
                    NSException.raise("Algo saiu muito errado no update de ScrollNode", format: "", arguments: CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer<Void>()))
                #endif
                break
            }
        }
    }
    
    class func resetScrollNodes(scene: SKScene) {
        for scrollNode in ScrollNode.scrollNodeList {
            scrollNode.resetPosition()
        }
    }
    
    override func removeFromParent() {
        ScrollNode.scrollNodeList.remove(self)
        super.removeFromParent()
    }
}
