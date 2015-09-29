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
    
    func load(textureName: String, x: Int, y: Int, xAlign: Control.xAlignments, yAlign: Control.yAlignments) {
        self.sketchPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
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
    
    override func removeFromParent() {
        Slider.sliderList.remove(self)
        super.removeFromParent()
    }
}
