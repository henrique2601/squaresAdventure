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
    
    var scaleNodes = false
    var scaleDistance:CGFloat = 1000
    var canScroll:Bool!
    
    static var scrollNodeList = Set<ScrollNode>()
    
    var cells = Array<SKNode>()
    
    var scrollType = scrollTypes.horizontal
    
    init(name:String, x:Int, y:Int, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: .left, yAlign: .up, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: align, yAlign: .center, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, textureName: name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: align, yAlign: .center, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 100) {
        super.init()
        self.load(name, textureName: textureName, x: x, y: y, xAlign: xAlign, yAlign: yAlign, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, x:Int, y:Int, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, x: x, y: y, xAlign: .left, yAlign: .up, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, x: x, y: y, xAlign: .left, yAlign: .up, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, x:Int, y:Int, align:Control.xAlignments, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, x: x, y: y, xAlign: align, yAlign: .center, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, align:Control.xAlignments, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, x: x, y: y, xAlign: align, yAlign: .center, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(name, x: x, y: y, xAlign: xAlign, yAlign: yAlign, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        fatalError("Parâmetro count:Int deve ser maior que um ou use a classe Control.")
    }
    
    func load(name:String, textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int, scrollDirection:scrollTypes, scaleNodes:Bool, scaleDistance:Int) {
        
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: textureName)
        
        self.scaleDistance = CGFloat(scaleDistance)
        self.scaleNodes = scaleNodes
        
        for (var i = 0; i < count; i++) {
            //let spriteNode = SKSpriteNode(texture: texture, color: nil, size: texture.size())
            let spriteNode = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: texture.size())
            spriteNode.position = CGPoint(x: (Int(spriteNode.size.width) + spacing) * i, y: 0)
            if(self.scaleNodes) {
                self.setCellScale(spriteNode)
            }
            self.cells.append(spriteNode)
            self.addChild(spriteNode)
        }
        
        ScrollNode.scrollNodeList.insert(self)
        self.canScroll = (self.cells.count > 1)
    }
    
    func load(name:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKNode>, spacing:Int, scrollDirection:scrollTypes, scaleNodes:Bool, scaleDistance:Int) {
        
        self.name = name
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        self.scaleDistance = CGFloat(scaleDistance)
        self.scaleNodes = scaleNodes
        
        self.cells = cells
        var i = 0
        for spriteNode in self.cells {
            spriteNode.position = CGPoint(x: (Int(spriteNode.calculateAccumulatedFrame().width) + spacing) * i, y: 0)
            if(self.scaleNodes) {
                self.setCellScale(spriteNode)
            }
            self.addChild(spriteNode)
            i++
        }
        
        ScrollNode.scrollNodeList.insert(self)
        self.canScroll = (self.cells.count > 1)
    }
    
    class func update() {
        for scrollNode in ScrollNode.scrollNodeList {
            if(scrollNode.canScroll == true) {
                switch(scrollNode.scrollType) {
                case scrollTypes.horizontal:
                    for touch in Control.touchesArray {
                        if let parent = scrollNode.parent {
                            let location = touch.locationInNode(parent)
                            
                            if scrollNode.containsPoint(location) {
                                var dx:Int = Int(location.x - touch.previousLocationInNode(parent).x)
                                if(dx == 0) {
                                    if(location.x - touch.previousLocationInNode(parent).x > 0){
                                        dx++
                                    } else {
                                        dx--
                                    }
                                }
                                if(dx < 0) {
                                    //Moveu o toque para a esquerda
                                    if(scrollNode.cells[scrollNode.cells.count - 1].position.x + CGFloat(dx) >= 0) {
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x) + dx, y: Int(position.y))
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            }
                                        }
                                    } else {
                                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.x)
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x) - auxMove, y: Int(position.y))
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            }
                                        }
                                    }
                                } else {
                                    //Moveu o toque para a direita
                                    if(scrollNode.cells[0].position.x + CGFloat(dx) <= 0) {
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x) + dx, y: Int(position.y))
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            }
                                        }
                                    } else {
                                        let auxMove:Int = Int(scrollNode.cells[0].position.x)
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x) - auxMove, y: Int(position.y))
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            }
                                        }
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
//                default:
//                    #if DEBUG
//                        fatalError("Algo saiu muito errado no update de ScrollNode")
//                    #endif
//                    break
                }
            }
        }
    }
    
    private func setCellScale(spriteNode:SKNode) {
        spriteNode.setScale(max(0, 1 - abs(spriteNode.position.x/self.scaleDistance)))
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
