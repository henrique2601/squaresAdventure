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
    
    static var scrollNodeList = Set<ScrollNode>()
    
    var cells = Array<SKSpriteNode>()
    
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
    
    init(name:String, x:Int, y:Int, cells:Array<SKSpriteNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, x: x, y: y, xAlign: .left, yAlign: .up, cells:cells, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, cells:Array<SKSpriteNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, x: x, y: y, xAlign: .left, yAlign: .up, cells:cells, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments, cells:Array<SKSpriteNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, x: x, y: y, xAlign: align, yAlign: .center, cells:cells, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKSpriteNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, cells:cells, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments, cells:Array<SKSpriteNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, x: x, y: y, xAlign: align, yAlign: .center, cells:cells, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKSpriteNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal) {
        super.init()
        self.load(name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, cells:cells, spacing:spacing, scrollDirection:scrollDirection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        fatalError("Parâmetro count:Int deve ser maior que um ou use a classe Control.")
    }
    
    func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int, scrollDirection:scrollTypes) {
        if(count <= 1) {
            fatalError("Parâmetro count:Int deve ser maior que um ou use a classe Control.")
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
            spriteNode.position = CGPoint(x: (Int(spriteNode.size.width) + spacing) * i, y: 0)
            self.cells.append(spriteNode)
            self.addChild(spriteNode)
        }
        ScrollNode.scrollNodeList.insert(self)
    }
    
    func load(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKSpriteNode>, spacing:Int, scrollDirection:scrollTypes) {
        if(cells.count <= 1) {
            fatalError("cells.count deve ser maior que um ou use a classe Control.")
        }
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        self.cells = cells
        var i = 0
        for spriteNode in self.cells {
            spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
            spriteNode.position = CGPoint(x: (Int(spriteNode.size.width) + spacing) * i, y: 0)
            self.addChild(spriteNode)
            i++
        }
        
        ScrollNode.scrollNodeList.insert(self)
    }
    
    class func update() {
        for scrollNode in ScrollNode.scrollNodeList {
            switch(scrollNode.scrollType) {
            case scrollTypes.horizontal:
                for touch in Control.touchesArray {
                    let location = touch.locationInNode(scrollNode.parent)
                    if scrollNode.containsPoint(location) {
                        var dx:Int = Int(location.x - touch.previousLocationInNode(scrollNode.parent).x)
                        if(dx < 0) {
                            //Moveu o toque para a esquerda
                            if(scrollNode.cells[scrollNode.cells.count - 1].position.x + CGFloat(dx) >= 0) {
                                for cell in scrollNode.cells {
                                    var position = cell.position
                                    cell.position = CGPoint(x: Int(position.x) + dx, y: Int(position.y))
                                }
                            } else {
                                var auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.x)
                                for cell in scrollNode.cells {
                                    var position = cell.position
                                    cell.position = CGPoint(x: Int(position.x) - auxMove, y: Int(position.y))
                                }
                            }
                        } else {
                            //Moveu o toque para a direita
                            if(scrollNode.cells[0].position.x + CGFloat(dx) <= 0) {
                                for cell in scrollNode.cells {
                                    var position = cell.position
                                    cell.position = CGPoint(x: Int(position.x) + dx, y: Int(position.y))
                                }
                            } else {
                                var auxMove:Int = Int(scrollNode.cells[0].position.x)
                                for cell in scrollNode.cells {
                                    var position = cell.position
                                    cell.position = CGPoint(x: Int(position.x) - auxMove, y: Int(position.y))
                                }
                            }
                        }
                    }
                }
                break
            case scrollTypes.vertical:
                //TODO: scrollTypes.vertical
//                for cell in scrollNode.cells {
//                    var position = cell.position
//                    cell.position = CGPoint(x: Int(position.x), y: Int(position.y) + dy)
//                }
                break
            default:
                #if DEBUG
                    fatalError("Algo saiu muito errado no update de ScrollNode")
                #endif
                break
            }
        }
    }
    
    class func resetScrollNodes() {
        for scrollNode in ScrollNode.scrollNodeList {
            scrollNode.resetPosition()
        }
    }
    
    override func removeFromParent() {
        ScrollNode.scrollNodeList.remove(self)
        super.removeFromParent()
    }
}
