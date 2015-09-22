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
            
            let backgroundMusicURL = NSBundle.mainBundle().URLForResource(name, withExtension: "mp3")
            
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL!)
                self.audioPlayer.numberOfLoops = -1
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            } catch {
                #if DEBUG
                    fatalError()
                #endif
            }
        }
    }
}
