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
    var spacing:Int = 0
    
    static var scrollNodeList = Set<ScrollNode>()
    
    var cells = Array<SKNode>()
    
    var scrollType = scrollTypes.horizontal
    
    init(textureName:String, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center, count:Int = 1, spacing:Int =  10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000) {
        super.init()
        self.load(textureName, x:x, y:y, xAlign:xAlign, yAlign:yAlign, count:count, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance)
    }
    
    init(x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000, index:Int = 0) {
        super.init()
        self.load(x, y:y, xAlign:xAlign, yAlign:yAlign, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance, index:index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(textureName:String, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, count:Int, spacing:Int, scrollDirection:scrollTypes, scaleNodes:Bool, scaleDistance:Int) {
        
        self.spacing = spacing
        
        self.scrollType = scrollDirection
        
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        let texture = SKTexture(imageNamed: textureName)
        
        self.scaleDistance = CGFloat(scaleDistance)
        self.scaleNodes = scaleNodes
        
        for (var i = 0; i < count; i++) {
            //let spriteNode = SKSpriteNode(texture: texture, color: nil, size: texture.size())
            let spriteNode = SKSpriteNode(texture: texture, size: texture.size())
            switch(scrollDirection) {
            case scrollTypes.horizontal:
                spriteNode.position = CGPoint(x: (Int(spriteNode.size.width) + spacing) * i, y: 0)
                break
            case scrollTypes.vertical:
                spriteNode.position = CGPoint(x: 0, y: (Int(spriteNode.size.height) + spacing) * i)
                break
            }
            
            if(self.scaleNodes) {
                self.setCellScale(spriteNode)
            }
            self.cells.append(spriteNode)
            self.addChild(spriteNode)
        }
        
        ScrollNode.scrollNodeList.insert(self)
        self.canScroll = (self.cells.count > 1)
    }
    
    func load(x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, cells:Array<SKNode>, spacing:Int, scrollDirection:scrollTypes, scaleNodes:Bool, scaleDistance:Int, index:Int) {
        
        self.spacing = spacing
        
        self.scrollType = scrollDirection
        
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition
        
        self.scaleDistance = CGFloat(scaleDistance)
        self.scaleNodes = scaleNodes
        
        self.cells = cells
        var i = 0
        for spriteNode in self.cells {
            switch(scrollDirection) {
            case scrollTypes.horizontal:
                spriteNode.position = CGPoint(x: (Int(spriteNode.calculateAccumulatedFrame().width) + spacing) * (i - index), y: 0)
                break
            case scrollTypes.vertical:
                spriteNode.position = CGPoint(x: 0, y: (Int(spriteNode.calculateAccumulatedFrame().height) + spacing) * i)
                break
            }
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
                                            } else {
                                                scrollNode.setCellHidden(cell)
                                            }
                                        }
                                    } else {
                                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.x)
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x) - auxMove, y: Int(position.y))
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            } else {
                                                scrollNode.setCellHidden(cell)
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
                                            } else {
                                                scrollNode.setCellHidden(cell)
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
                    for touch in Control.touchesArray {
                        if let parent = scrollNode.parent {
                            let location = touch.locationInNode(parent)
                            
                            if scrollNode.containsPoint(location) {
                                var dy:Int = Int(location.y - touch.previousLocationInNode(parent).y)
                                if(dy == 0) {
                                    if(location.y - touch.previousLocationInNode(parent).y > 0) {
                                        dy++
                                    } else {
                                        dy--
                                    }
                                }
                                if(dy < 0) {
                                    //Moveu o toque para baixo???
                                    if(scrollNode.cells[scrollNode.cells.count - 1].position.y + CGFloat(dy) >= 0) {
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x), y: Int(position.y) + dy)
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            } else {
                                                scrollNode.setCellHidden(cell)
                                            }
                                        }
                                    } else {
                                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.y)
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x), y: Int(position.y) - auxMove)
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            } else {
                                                scrollNode.setCellHidden(cell)
                                            }
                                        }
                                    }
                                } else {
                                    //Moveu o toque para cima???
                                    if(scrollNode.cells[0].position.y + CGFloat(dy) <= 0) {
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x), y: Int(position.y) + dy)
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            } else {
                                                scrollNode.setCellHidden(cell)
                                            }
                                        }
                                    } else {
                                        let auxMove:Int = Int(scrollNode.cells[0].position.y)
                                        for cell in scrollNode.cells {
                                            let position = cell.position
                                            cell.position = CGPoint(x: Int(position.x), y: Int(position.y) - auxMove)
                                            if(scrollNode.scaleNodes) {
                                                scrollNode.setCellScale(cell)
                                            } else {
                                                scrollNode.setCellHidden(cell)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break
                }
            }
        }
    }
    
    private func setCellHidden(spriteNode:SKNode) {
        switch(self.scrollType) {
        case scrollTypes.horizontal:
            spriteNode.hidden = abs(spriteNode.position.x) > self.scaleDistance
            break
        case scrollTypes.vertical:
            spriteNode.setScale(max(0, 1 - abs(spriteNode.position.y/self.scaleDistance)))
            break
        }
        
    }
    
    private func setCellScale(spriteNode:SKNode) {
        switch(self.scrollType) {
        case scrollTypes.horizontal:
            spriteNode.setScale(max(0, 1 - abs(spriteNode.position.x/self.scaleDistance)))
            break
        case scrollTypes.vertical:
            spriteNode.setScale(max(0, 1 - abs(spriteNode.position.y/self.scaleDistance)))
            break
        }
        
    }
    
    class func resetScrollNodes() {
        for scrollNode in ScrollNode.scrollNodeList {
            scrollNode.resetPosition()
        }
    }
    
    func append(cell:SKNode) {
        
        var i = 0
        for _ in self.cells {
            i++
        }
        
        switch(self.scrollType) {
        case scrollTypes.horizontal:
            cell.position = CGPoint(x: (Int(cell.calculateAccumulatedFrame().width) + self.spacing) * i, y: 0)
            break
        case scrollTypes.vertical:
            cell.position = CGPoint(x: 0, y: (Int(cell.calculateAccumulatedFrame().height) + self.spacing) * i)
            break
        }
        
        self.cells.append(cell)
        self.addChild(cell)
    }
    
    override func removeFromParent() {
        ScrollNode.scrollNodeList.remove(self)
        super.removeFromParent()
    }
}
