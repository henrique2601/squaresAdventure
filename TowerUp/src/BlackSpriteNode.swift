//
//  BlackSpriteNode.swift
//  Squares Adventure
//
//  Created by Pablo Henrique on 28/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BlackSpriteNode: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: GameColors.black, size: Config.currentSceneSize)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.zPosition = Config.HUDZPosition
        self.isHidden = true
    }
    
    func update() {
        self.size = Config.currentSceneSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
