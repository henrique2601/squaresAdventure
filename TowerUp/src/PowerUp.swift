//
//  PowerUp.swift
//  TowerUp
//
//  Created by Pablo Henrique on 28/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit

class PowerUp: NSObject {
    
}

class PowerUpType: NSObject {
    var image:String
    
    init(image:String) {
        self.image = image
    }
}

class PowerUps :NSObject {
    static var types = Array<PowerUpType>([
        PowerUpType(image:"bubble"), //0
        PowerUpType(image:"bubbleUp"), //1
        PowerUpType(image:"bunny"), //2
        PowerUpType(image:"carrotGold"), //3
        PowerUpType(image:"carrotNormal"), //4
        PowerUpType(image:"doubleLife"), //5
        PowerUpType(image:"empty"), //6
        PowerUpType(image:"gold"), //7
        PowerUpType(image:"jetPack"), //8
        PowerUpType(image:"player"), //9
        PowerUpType(image:"portalOranje"), //10
        PowerUpType(image:"wings"), //11
        PowerUpType(image:"bubbleUp")  //12
        ])
}
