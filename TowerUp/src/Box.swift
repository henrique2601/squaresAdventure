//
//  Box.swift
//  SuperAwesomeGame
//
//  Created by Pablo Henrique Bertaco on 11/1/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Box: Control {
    
    init(name:String = "", textureName:String, x:Int = -1, y:Int = -1, z:Int = 0, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center) {
        
        let texture = SKTexture(imageNamed: textureName)
        
        let position = CGPoint(
            x: x == -1 ? Config.sceneSize.width - texture.size().width : CGFloat(x),
            y: y == -1 ? Config.sceneSize.height  - texture.size().height : CGFloat(y))
        
        super.init(spriteNode: SKSpriteNode(texture: texture), x: Int(position.x), y: Int(position.y), xAlign:.center, yAlign:.center)
        
        self.zPosition = Config.HUDZPosition * 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
