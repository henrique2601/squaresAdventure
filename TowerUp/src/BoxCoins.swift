//
//  BoxCoins.swift
//  TowerUp
//
//  Created by Pablo Henrique on 30/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class BoxCoins: Control {
    
    var labelCoins:Label!
    var labelGems:Label!
    
    override init() {
        let texture = SKTexture(imageNamed: "boxCoins")
        
        super.init(texture: texture, x: 1058, y: 20, xAlign: .right, yAlign: .up)
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        self.labelCoins = Label(text: playerData.coins.description, x: 160, y: 33)
        self.labelGems = Label(text: playerData.gems.description, x: 160, y: 100)
        self.addChild(self.labelCoins)
        self.addChild(self.labelGems)
        
        self.zPosition = Config.HUDZPosition 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
