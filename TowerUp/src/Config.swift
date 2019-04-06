//
//  Config.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Config: NSObject {
    
    static var skViewBoundsSize:CGSize = CGSize.zero
    static var translate:CGPoint = CGPoint.zero
    static var translateInView:CGPoint = CGPoint.zero
    
    static var HUDZPosition:CGFloat = 1000
    
    static var currentSceneSize:CGSize!
    
    static var defaultTransition = SKTransition.crossFade(withDuration: 0.5)
    
    static let sceneSize:CGSize = CGSize(width: 1334/2, height: 750/2)
    
    static func updateSceneSize() -> CGSize {
        
        switch(Int(UIDevice.current.systemVersion[0] as String)!) {
            
        case 9:
            
            let xScale = skViewBoundsSize.width / sceneSize.width
            let yScale = skViewBoundsSize.height / sceneSize.height
            let scale = min(xScale, yScale)
            
            Config.translate = CGPoint(x: ((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
                y: ((skViewBoundsSize.height - (sceneSize.height * scale))/2)/scale)
            
            Config.translateInView = CGPoint(x: ((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
                y: ((skViewBoundsSize.height - (sceneSize.height * scale))/2))
            
            Config.currentSceneSize = CGSize(width: skViewBoundsSize.width / scale, height: skViewBoundsSize.height / scale)
            return Config.currentSceneSize
            
        case 8:
            let sceneSize:CGSize = CGSize(width: 1334/2, height: 750/2)
            
            let xScale = skViewBoundsSize.width / sceneSize.width
            let yScale = skViewBoundsSize.height / sceneSize.height
            let scale = min(xScale, yScale)
            
            Config.translate = CGPoint(x: ((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
                                       y: ((skViewBoundsSize.height - (sceneSize.height * scale))/2)/scale)
            
            Config.translateInView = CGPoint(x: ((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
                                        y: ((skViewBoundsSize.height - (sceneSize.height * scale))/2))
            
            Config.currentSceneSize = CGSize(width: skViewBoundsSize.width / scale, height: skViewBoundsSize.height / scale)
            return Config.currentSceneSize
            
        default:
            Config.translate = CGPoint.zero
            Config.currentSceneSize = CGSize(width: 1334/2, height: 750/2)
            return Config.currentSceneSize
        }
    }
}

public extension String {
    subscript (i: Int) -> Character {
        
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.startIndex)
        let end = index(startIndex, offsetBy: r.endIndex)
        let range = start..<end
        return String(self[range])
    }
}

public extension Int {
    /**
    Returns a random integer between 0 and n-1.
    */
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    /**
    Create a random num Ints
    - parameter lower: number Int
    - parameter upper: number Int
    :return: random number Int
    */
    public static func random(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    /**
    Create a random num Int
    - parameter lower: number CGFloat
    - parameter upper: number CGFloat
    :return: random number Int
    */
    public static func random(min: CGFloat, max: CGFloat) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + Int(min)
    }
}

public extension Double {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /**
    Create a random num Double
    - parameter lower: number Double
    - parameter upper: number Double
    :return: random number Double
    */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

public extension Float {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    /**
    Create a random num Float
    - parameter lower: number Float
    - parameter upper: number Float
    :return: random number Float
    */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}

public extension CGFloat {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

public extension String {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    public static  func randomStringWithLength (len : Int) -> String {
        
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
}
