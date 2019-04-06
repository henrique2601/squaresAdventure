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
    
    var firstCellPositionX:CGFloat = 0
    var firstCellPositionY:CGFloat = 0
    
    let force = 1
    var width = 0
    var height = 0
    
    init(x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center, cells:Array<SKNode>, spacing:Int = 10, scrollDirection:scrollTypes = scrollTypes.horizontal, scaleNodes:Bool = false, scaleDistance:Int = 1000, index:Int = 0) {
        super.init()
        self.load(x: x, y:y, xAlign:xAlign, yAlign:yAlign, cells:cells, spacing:spacing, scrollDirection:scrollDirection, scaleNodes:scaleNodes, scaleDistance:scaleDistance, index:index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            let size = spriteNode.calculateAccumulatedFrame()
            self.width = Int(size.width)
            self.height = Int(size.height)
            
            switch(scrollDirection) {
            case scrollTypes.horizontal:
                spriteNode.position = CGPoint(x: (self.width + spacing) * (i - index), y: 0)
                break
            case scrollTypes.vertical:
                spriteNode.position = CGPoint(x: 0, y: -(self.height + spacing) * i)
                break
            }
            if(self.scaleNodes) {
                self.setCellScale(spriteNode: spriteNode)
            }
            
            self.initPhysics(node: spriteNode)
            
            self.addChild(spriteNode)
            i += 1
        }
        
        ScrollNode.scrollNodeList.insert(self)
        self.canScroll = (self.cells.count > 1)
    }
    
    func initPhysics(node:SKNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.categoryBitMask = physicsCategory.scrollNodeCell.rawValue
        node.physicsBody!.contactTestBitMask = physicsCategory.none.rawValue
        node.physicsBody!.collisionBitMask = physicsCategory.none.rawValue
        node.physicsBody!.linearDamping = 4
    }
    
    class func update() {
        
        for scrollNode in ScrollNode.scrollNodeList {
            
            for cell in scrollNode.cells {
                if(scrollNode.scaleNodes) {
                    scrollNode.setCellScale(spriteNode: cell)
                }
            }
            
            var containsPoins = false
            
            for touch in Control.touchesArray {
                if scrollNode.contains(touch.location(in: scrollNode.parent!)) {
                    containsPoins = true
                    break
                }
            }
            
            if (scrollNode.canScroll == true) {
                
                switch scrollNode.scrollType {
                    
                case scrollTypes.horizontal:
                    
                    var outOfBounds = false
                    
                    if !(scrollNode.cells[scrollNode.cells.count - 1].position.x >= scrollNode.firstCellPositionX) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.x - scrollNode.firstCellPositionX)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: -auxMove * scrollNode.force/10, dy: 0))
                        }
                    }
                    
                    if !(scrollNode.cells[0].position.x <= scrollNode.firstCellPositionX) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[0].position.x - scrollNode.firstCellPositionX)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: -auxMove * scrollNode.force/10, dy: 0))
                        }
                    }
                    
                    if(!outOfBounds && !containsPoins) {
                        
                        if(abs(scrollNode.cells[0].physicsBody!.velocity.dx) < 20) {
                            
                            let i = round((scrollNode.firstCellPositionX - scrollNode.cells[0].position.x) / CGFloat(scrollNode.width + scrollNode.spacing/2))
                            
                            var auxMove:CGFloat = 0
                            
                            auxMove = scrollNode.firstCellPositionX - scrollNode.cells[Int(i)].position.x
                            
                            for cell in scrollNode.cells {
                                cell.physicsBody!.applyForce(CGVector(dx: auxMove, dy: 0))
                                if(scrollNode.scaleNodes) {
                                    scrollNode.setCellScale(spriteNode: cell)
                                }
                            }
                        }
                    }
                    
                    break
                    
                case scrollTypes.vertical:
                    
                    var outOfBounds = false
                    
                    if !(scrollNode.cells[0].position.y >= scrollNode.firstCellPositionY) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[0].position.y - scrollNode.firstCellPositionY)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: 0, dy: -auxMove * scrollNode.force/10))
                        }
                    }
                    if !(scrollNode.cells[scrollNode.cells.count - 1].position.y <= scrollNode.firstCellPositionY) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.y - scrollNode.firstCellPositionY)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: 0, dy: -auxMove * scrollNode.force/10))
                        }
                    }
                    
                    if(!outOfBounds && !containsPoins) {
                        
                        if(abs(scrollNode.cells[0].physicsBody!.velocity.dy) < 20) {
                            
                            let i = round((scrollNode.cells[0].position.y - scrollNode.firstCellPositionY) / CGFloat(scrollNode.height + scrollNode.spacing/2))
                            
                            let auxMove = scrollNode.firstCellPositionY - scrollNode.cells[Int(i)].position.y
                            
                            for cell in scrollNode.cells {
                                cell.physicsBody!.applyForce(CGVector(dx: 0, dy: auxMove))
                                if(scrollNode.scaleNodes) {
                                    scrollNode.setCellScale(spriteNode: cell)
                                }
                            }
                        }
                    }
                    
                    break
                }
            }
        }
    }
    
    class func updateOnTouchesMoved() {
        
        for scrollNode in ScrollNode.scrollNodeList {
            
            if (scrollNode.canScroll == true) {
                
                switch scrollNode.scrollType {
                    
                case scrollTypes.horizontal:
                    
                    var canMove = true
                    
                    if(Control.dx > 0) {
                        if !(scrollNode.cells[0].position.x <= scrollNode.firstCellPositionX) {
                            canMove = false
                        }
                    } else {
                        if !(scrollNode.cells[scrollNode.cells.count - 1].position.x >= scrollNode.firstCellPositionX) {
                            canMove = false
                        }
                    }
                    
                    if(canMove) {
                        
                        for touch in Control.touchesArray {
                            if scrollNode.contains(touch.location(in: scrollNode.parent!)) {
                                for cell in scrollNode.cells {
                                    let position = cell.position
                                    cell.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                                    cell.position = CGPoint(x: position.x + Control.dx, y: position.y)
                                    cell.physicsBody!.applyForce(CGVector(dx: Control.dx * CGFloat(scrollNode.force * 5), dy: 0))
                                    if(scrollNode.scaleNodes) {
                                        scrollNode.setCellScale(spriteNode: cell)
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                case scrollTypes.vertical:
                    
                    for touch in Control.touchesArray {
                        
                        var canMove = true
                        
                        if(Control.dy > 0) {
                            if !(scrollNode.cells[scrollNode.cells.count - 1].position.y <= scrollNode.firstCellPositionY) {
                                canMove = false
                            }
                        } else {
                            if !(scrollNode.cells[0].position.y >= scrollNode.firstCellPositionY) {
                                canMove = false
                            }
                        }
                        
                        if(canMove) {
                            if scrollNode.contains(touch.location(in: scrollNode.parent!)) {
                                
                                for cell in scrollNode.cells {
                                    let position = cell.position
                                    cell.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                                    cell.position = CGPoint(x: position.x, y: position.y + Control.dy)
                                    cell.physicsBody!.applyForce(CGVector(dx: 0, dy: Control.dy * CGFloat(scrollNode.force * 5)))
                                    if(scrollNode.scaleNodes) {
                                        scrollNode.setCellScale(spriteNode: cell)
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
    
    class func updateOnTouchesEnded() {
        
        for scrollNode in ScrollNode.scrollNodeList {
            
            if (scrollNode.canScroll == true) {
                
                switch scrollNode.scrollType {
                    
                case scrollTypes.horizontal:
                    
                    for touch in Control.touchesArray {
                        if scrollNode.contains(touch.location(in: scrollNode.parent!)) {
                            
                            for cell in scrollNode.cells {
                                let position = cell.position
                                cell.position = CGPoint(x: position.x + Control.dx, y: position.y)
                                cell.physicsBody!.applyForce(CGVector(dx: Control.dx * CGFloat(scrollNode.force * 10), dy: 0))
                                if(scrollNode.scaleNodes) {
                                    scrollNode.setCellScale(spriteNode: cell)
                                }
                            }
                        }
                    }
                    
                    break
                    
                case scrollTypes.vertical:
                    
                    for touch in Control.touchesArray {
                        if scrollNode.contains(touch.location(in: scrollNode.parent!)) {
                            
                            for cell in scrollNode.cells {
                                let position = cell.position
                                cell.position = CGPoint(x: position.x, y: position.y + Control.dy)
                                cell.physicsBody!.applyForce(CGVector(dx: 0, dy: Control.dy * CGFloat(scrollNode.force * 10)))
                                if(scrollNode.scaleNodes) {
                                    scrollNode.setCellScale(spriteNode: cell)
                                }
                            }
                        }
                    }
                    
                    break
                }
            }
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
        
        let size = cell.calculateAccumulatedFrame()
        self.width = Int(size.width)
        self.height = Int(size.height)
        
        var i = 0
        for _ in self.cells {
            i += 1
        }
        
        switch(self.scrollType) {
        case scrollTypes.horizontal:
            cell.position = CGPoint(x: (Int(width) + self.spacing) * i, y: 0)
            break
        case scrollTypes.vertical:
            cell.position = CGPoint(x: 0, y: -(Int(height) + self.spacing) * i)
            break
        }
        
        self.cells.append(cell)
        self.canScroll = (self.cells.count > 1)
        self.addChild(cell)
        
        self.initPhysics(node: cell)
    }
    
    override func removeFromParent() {
        ScrollNode.scrollNodeList.remove(self)
        super.removeFromParent()
    }
}
