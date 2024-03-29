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
        
        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.clear, size: texture.size())
        
        super.init(spriteNode: spriteNode, x: 1058, y: 20, xAlign: .right, yAlign: .up)
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        self.labelCoins = Label(text: playerData!.coins.description, x: 160, y: 33)
        self.labelGems = Label(text: playerData!.gems.description, x: 160, y: 100)
        self.addChild(self.labelCoins)
        self.addChild(self.labelGems)
        
        self.zPosition = Config.HUDZPosition 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func containsPoint() {
        
        if let gameScene = self.parent as? GameScene {
            
            let box = MessageBox(text: "Watch a video ad and get free coins.", textureName: "boxWhite", type: MessageBox.messageType.OKCancel)
            
            self.parent?.addChild(box)
            
            gameScene.blackSpriteNode.isHidden = false
            gameScene.blackSpriteNode.zPosition = box.zPosition - 1
            box.buttonOK.addHandler {
                gameScene.blackSpriteNode.isHidden = true
            }
            
            box.buttonCancel.addHandler {
                gameScene.blackSpriteNode.isHidden = true
            }
        }
        
    }
    
    func onAdColonyAdAttemptFinished(shown: Bool, inZone zoneID: String) {
        if(shown) {
            let playerData = MemoryCard.sharedInstance.playerData!
            playerData.coins = NSNumber(value: playerData.coins.intValue + 100)
            self.labelCoins.setText(playerData.coins.description)
        }
    }
}
