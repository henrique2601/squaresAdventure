//
//  Slider.swift
//  TowerUp
//
//  Created by Pablo Henrique on 22/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Slider: Control {
    
    static var sliderList = Set<Slider>()
    
    var thumbSpriteNode:SKSpriteNode!
    
    var touch:UITouch!
    
    var limit:Int = 0
    
    override init() {
        super.init()
        self.zPosition = Config.HUDZPosition/2
        
        let sliderTexture = SKTexture(imageNamed: "sliderYellow")
        let sliderSpriteNode = SKSpriteNode(texture: sliderTexture, size: sliderTexture.size())
        self.addChild(sliderSpriteNode)
        
        let thumbTexture = SKTexture(imageNamed: "thumbRed")
        self.thumbSpriteNode = SKSpriteNode(texture: thumbTexture, size: thumbTexture.size())
        sliderSpriteNode.addChild(self.thumbSpriteNode)
        
        thumbSpriteNode.zPosition = sliderSpriteNode.zPosition + CGFloat(1)
        
        self.limit = Int(self.calculateAccumulatedFrame().width/2)
        
        Slider.sliderList.insert(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromParent() {
        Slider.sliderList.remove(self)
        super.removeFromParent()
    }
}
