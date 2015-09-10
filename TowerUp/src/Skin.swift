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
        //self.name = name
        self.imageName = imageName
        self.price = price
    }
}

class Skins : NSObject {
    
    static var types = Array<SkinType>([
        SkinType(imageName:"elephant", price:100), //0
        SkinType(imageName:"giraffe", price:100), //1
        SkinType(imageName:"hippo", price:100), //2
        SkinType(imageName:"monkey", price:100), //3
        SkinType(imageName:"panda", price:100), //4
        SkinType(imageName:"parrot", price:100), //5
        SkinType(imageName:"penguin", price:100), //6
        SkinType(imageName:"pig", price:100), //7
        SkinType(imageName:"rabbit", price:200), //8
        SkinType(imageName:"snake", price:100), //9
        
        SkinType(imageName:"skin1", price:200),
        SkinType(imageName:"skin2", price:200),
        SkinType(imageName:"skin3", price:300),
        SkinType(imageName:"skin4", price:200),
        SkinType(imageName:"skin5", price:500),
        SkinType(imageName:"skin6", price:200),
        SkinType(imageName:"skin7", price:200),
        SkinType(imageName:"skin8", price:200),
        SkinType(imageName:"skin9", price:400),
        SkinType(imageName:"skin10", price:300)
        
        ])
}
