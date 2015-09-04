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
    var imageName:String
    var price:Int
    
    init(imageName:String, price:Int) {
        self.imageName = imageName
        self.price = price
    }
}

class Skins : NSObject {
    
    static var types = Array<SkinType>([
        SkinType(imageName:"elephant", price:0), //0
        SkinType(imageName:"giraffe", price:0), //1
        SkinType(imageName:"hippo", price:0), //2
        SkinType(imageName:"monkey", price:0), //3
        SkinType(imageName:"panda", price:0), //4
        SkinType(imageName:"parrot", price:0), //5
        SkinType(imageName:"penguin", price:0), //6
        SkinType(imageName:"pig", price:0), //7
        SkinType(imageName:"rabbit", price:10), //8
        SkinType(imageName:"snake", price:0), //9
        ])
}
