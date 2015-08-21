//
//  PowerUp.swift
//  TowerUp
//
//  Created by Gabriel Prado Marcolino on 20/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import CoreData

class PowerUp: GameScene {
    
    enum states {
        case powerUp
        case mission
    }
    
    var state = states.powerUp
    var nextState = states.powerUp

    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(name: "beforeMissionBackground", x:0, y:0, align:.center))
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
    }
    
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        
    
        println("swiped right")
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        println("swiped left")
    }
    
    
    
    
    
    
    
    
}