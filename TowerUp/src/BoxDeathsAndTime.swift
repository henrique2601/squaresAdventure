//
//  boxDeathsAndTime.swift
//  TowerUp
//
//  Created by Paulo Henrique dos Santos on 04/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BoxDeathsAndTime: Control {
    
    var labelDeaths:Label!
    var labelTime:Label!
    var time:Int = 0 {
        didSet {
            self.labelTime.setText(self.time.description + "s")
        }
    }
    
    override init() {
        let texture = SKTexture(imageNamed: "boxDeathsAndTime")
        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        super.init(spriteNode: spriteNode, x: 462, y: 20, xAlign: .right, yAlign: .up)
        
        
        self.labelDeaths = Label(text: "0", x: 131, y: 39)
        self.labelTime = Label(text: "0s", x: 346, y: 39)
        self.addChild(self.labelDeaths)
        self.addChild(self.labelTime)
        
        self.zPosition = Config.HUDZPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset()
    {
        self.labelTime.setText("0")
        self.labelDeaths.setText("0")
        self.time = 0 
        
    }

}
