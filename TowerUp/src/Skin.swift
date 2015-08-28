//
//  Skin.swift
//  TowerUp
//
//  Created by Pablo Henrique on 28/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit

class Skin: NSObject {
    
}

class SkinType: NSObject {
    var image:String
    
    init(image:String) {
        self.image = image
    }
}

class Skins : NSObject {
    
    static var types = Array<SkinType>([
        SkinType(image:"elephant"), //0
        SkinType(image:"giraffe"), //1
        SkinType(image:"hippo"), //2
        SkinType(image:"monkey"), //3
        SkinType(image:"panda"), //4
        SkinType(image:"parrot"), //5
        SkinType(image:"penguin"), //6
        SkinType(image:"pig"), //7
        SkinType(image:"rabbit"), //8
        SkinType(image:"snake"), //9
        ])
}
