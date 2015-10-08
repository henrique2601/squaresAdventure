//
//  SoudEffect.swift
//  TowerUp
//
//  Created by Pablo Henrique on 05/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class SoundEffect: NSObject {
    
    enum files : String {
        case boom = "boom4.wav"
        case coin = "Coin.wav"
        case jump = "jump_01.wav"
        case player_Spike = "qubodupImpactMeat01.wav"
    }
    
    var sound:SKAction!
    var node:SKNode!
    
    init(soundFile:String, node:SKNode) {
        super.init()
        self.sound = SKAction.playSoundFileNamed(soundFile, waitForCompletion: true)
        self.node = node
    }
    
    func play() {
        if(MemoryCard.sharedInstance.playerData.soundEnabled.boolValue == true) {
            self.node.runAction(self.sound)
        }
    }
}
