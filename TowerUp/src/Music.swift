//
//  Music.swift
//  TowerUp
//
//  Created by Pablo Henrique on 22/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import AVFoundation

class Music: NSObject {
    
    static let sharedInstance = Music()
    
    var audioPlayer:AVAudioPlayer!
    
    var musicName:String = ""
    
    func play(musicNamed name:String) {
        
        if (self.musicName != name) {
            self.musicName = name
            
            var auxName:[String] = name.components(separatedBy: ".")
            
            let backgroundMusicURL = Bundle.main.url(forResource: auxName[0], withExtension: auxName[1])
            
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOf: backgroundMusicURL!)
                self.audioPlayer.numberOfLoops = -1
                //self.audioPlayer.prepareToPlay()
                //self.play()
            } catch {
                #if DEBUG
                    fatalError()
                #endif
            }
        }
    }
    
    func play() {
        if(MemoryCard.sharedInstance.playerData.musicEnabled.boolValue == true) {
            self.audioPlayer.play()
        } else {
            self.audioPlayer.pause()
        }
    }
}
