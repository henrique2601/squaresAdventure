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
    var buyWithCoins:Bool
    
    init(imageName:String, price:Int, buyWithCoins:Bool) {
        //self.name = name
        self.imageName = imageName
        self.price = price
        self.buyWithCoins = buyWithCoins
    }
}

class Skins : NSObject {
    
    static var types = Array<SkinType>([
        SkinType(imageName:"elephant", price:100, buyWithCoins:true), //0
        SkinType(imageName:"giraffe", price:100, buyWithCoins:true), //1
        SkinType(imageName:"hippo", price:100, buyWithCoins:true), //2
        SkinType(imageName:"monkey", price:100, buyWithCoins:true), //3
        SkinType(imageName:"panda", price:100, buyWithCoins:true), //4
        SkinType(imageName:"parrot", price:100, buyWithCoins:true), //5
        SkinType(imageName:"penguin", price:100, buyWithCoins:true), //6
        SkinType(imageName:"pig", price:100, buyWithCoins:true), //7
        SkinType(imageName:"rabbit", price:200, buyWithCoins:true), //8
        SkinType(imageName:"snake", price:100, buyWithCoins:true), //9
        
        SkinType(imageName:"skin1", price:2, buyWithCoins:false),
        SkinType(imageName:"skin2", price:2, buyWithCoins:false),
        SkinType(imageName:"skin3", price:3, buyWithCoins:false),
        SkinType(imageName:"skin4", price:2, buyWithCoins:false),
        SkinType(imageName:"skin5", price:5, buyWithCoins:false),
        SkinType(imageName:"skin6", price:2, buyWithCoins:false),
        SkinType(imageName:"skin7", price:2, buyWithCoins:false),
        SkinType(imageName:"skin8", price:2, buyWithCoins:false),
        SkinType(imageName:"skin9", price:4, buyWithCoins:false),
        SkinType(imageName:"skin10", price:3, buyWithCoins:false)
        
        ])
}
