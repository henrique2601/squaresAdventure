//
//  winCell.swift
//  Squares Adventure
//
//  Created by Paulo Henrique dos Santos on 21/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class WinCell: SKNode {
    
    var medal: SKSpriteNode?
    var skin: SKSpriteNode!
    var playerName: Label!
    var timeIcon: SKSpriteNode!
    var time: Label!
    
    
    init(position:Int, skin:Int, name:String, time:Int) {
        super.init()
        
        
        if (position==0) {
             self.medal = SKSpriteNode(imageNamed: "goldMedal")
             self.addChild(self.medal!)
            
        } else if (position==1) {
            self.medal = SKSpriteNode(imageNamed: "silverMedal")
            self.addChild(self.medal!)
            
        } else if (position==2) {
            self.medal = SKSpriteNode(imageNamed: "bronzeMedal")
            self.addChild(self.medal!)
            
        }
        
        self.medal?.position = CGPoint(x: -357/2, y: -30/2)
        
        let skinType = Skins.types[skin]
        self.skin = SKSpriteNode(imageNamed: skinType.imageName)
        self.skin.position = CGPoint(x: -281/2, y: -30/2)
        self.addChild(self.skin)
        
        self.playerName = Label(text: name,  horizontalAlignmentMode: .Left)
        self.playerName.position = CGPoint(x: -198/2, y: -30/2)
        self.addChild(self.playerName)
        
        
        self.timeIcon = SKSpriteNode(imageNamed: "timer")
        self.timeIcon.position = CGPoint(x: 207/2, y: -30/2)
        self.addChild(self.timeIcon)
        
        self.time = Label(text: time.description)
        self.time.position = CGPoint(x: 278/2, y: -30/2)
        self.addChild(self.time)
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
