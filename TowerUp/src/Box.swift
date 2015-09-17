//
//  Box.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/20/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Box: Control {
    
    init(background:String) {
        let texture = SKTexture(imageNamed: background)
        let position = CGPoint(x: 1334/2 - texture.size().width,
                               y: 750/2  - texture.size().height)
        super.init(name: "box", texture: texture, x: Int(position.x), y: Int(position.y), align:.center)
        
        self.zPosition = Config.HUDZPosition * CGFloat(2)
        
        self.hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesBegan(touches )
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesMoved()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesEnded(touches )
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        Control.touchesEnded(touches! as Set<UITouch>)
    }
    
    override var hidden: Bool {
        didSet {
            self.userInteractionEnabled = !hidden
        }
    }
}
