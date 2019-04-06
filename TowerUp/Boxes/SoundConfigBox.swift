//
//  SoundConfigBox.swift
//  TowerUp
//
//  Created by Pablo Henrique on 07/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class SoundConfigBox: Box {
    
    var switchMusic:Switch!
    var switchSound:Switch!
    
    var playerData = MemoryCard.sharedInstance.playerData!
    
    init() {
        super.init(textureName: "box340x355")
        
        self.switchMusic = Switch(textureName: "music", on:self.playerData.musicEnabled.boolValue, x:20, y:20)
        self.addChild(self.switchMusic)
        
        self.switchSound = Switch(textureName: "sound", on:self.playerData.soundEnabled.boolValue, x:20, y:133)
        self.addChild(self.switchSound)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            if (self.switchMusic.contains(location)) {
                self.playerData.musicEnabled = NSNumber(value: self.switchMusic.on)
                Music.sharedInstance.play()
                return
            }
            
            if (self.switchSound.contains(location)) {
                self.playerData.soundEnabled = NSNumber(value: self.switchSound.on)
                return
            }
        }
    }
}
