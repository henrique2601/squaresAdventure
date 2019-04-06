//
//  CropBox.swift
//  SuperAwesomeGame
//
//  Created by Pablo Henrique Bertaco on 11/10/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class CropBox: Box {
    
    override var position: CGPoint  {
        set {
            self.cropNode.position = newValue
        }
        get {
            return self.cropNode.position
        }
    }
    
    override var zPosition: CGFloat  {
        set {
            self.cropNode.zPosition = newValue
        }
        get {
            return self.cropNode.zPosition
        }
    }
    
    override var isHidden: Bool  {
        set {
            self.cropNode.isHidden = newValue
        }
        get {
            return self.cropNode.isHidden
        }
    }
    
    var cropNode = SKCropNode()
    
    override init(name:String = "", textureName:String, x:Int = -1, y:Int = -1, z:Int = 0, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center) {
        
        super.init(name: name, textureName: textureName, x: x, y: y, z: z, xAlign: xAlign, yAlign: yAlign)
        
        let mask = SKSpriteNode(imageNamed: textureName)
        mask.anchorPoint = CGPoint.init(x: 0, y: 1)
        self.cropNode.maskNode = mask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addChild(_ node: SKNode) {
        self.cropNode.addChild(node)
    }
}

extension GameScene {
    
    override func addChild(_ node: SKNode) {
        if let box = node as? CropBox {
            super.addChild(box.cropNode)
        } else {
            super.addChild(node)
        }
    }
}
