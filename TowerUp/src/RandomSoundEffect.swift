//
//  RandomSoundEffect.swift
//  TowerUp
//
//  Created by Pablo Henrique on 05/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class RandomSoundEffect: NSObject {
    
    enum filePrefix : String {
        case teste = "teste"
    }
    
    var soundList = Array<SoundEffect>()
    
    init(soundFilePrefix:filePrefix, count:Int, node:SKNode) {
        super.init()
        
        for i in 0 ..< count {
            self.soundList.append(SoundEffect(soundFile: soundFilePrefix.rawValue + i.description, node: node))
        }
    }
    
    func play() {
        if(MemoryCard.sharedInstance.playerData.soundEnabled.boolValue == true) {
            self.soundList[Int.random(n: soundList.count)].play()
        }
    }
}
