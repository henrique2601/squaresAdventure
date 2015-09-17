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
    
    static var skViewBoundsSize:CGSize = CGSizeZero
    static var translate:CGPoint = CGPointZero
    static var translateInView:CGPoint = CGPointZero
    
    static var HUDZPosition:CGFloat = 1000
    
    static var currentSceneSize:CGSize!
    
    static var defaultGoTransition:SKTransition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0)
    static var defaultBackTransition:SKTransition = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0)
    
    static func sceneSize() -> CGSize {
        
        switch(Int(UIDevice.currentDevice().systemVersion[0] as String)!) {
            
        case 9:
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
            let scale = 1
            Config.translate = CGPoint.zero
            Config.currentSceneSize = CGSize(width: 1334/2, height: 750/2)
            return Config.currentSceneSize
        }
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
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
    Create a random num Int
    - parameter lower: number Int
    - parameter upper: number Int
    :return: random number Int
    */
    public static func random(min min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    /**
    Create a random num Int
    - parameter lower: number CGFloat
    - parameter upper: number CGFloat
    :return: random number Int
    */
    public static func random(min min: CGFloat, max: CGFloat) -> Int {
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
    public static func random(min min: Double, max: Double) -> Double {
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
    public static func random(min min: Float, max: Float) -> Float {
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
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

//extension NSSet: ArrayLiteralConvertible {
//    public class func convertFromArrayLiteral(elements: AnyObject...) -> Self {
//        return self.init(array: elements)
//    }
//}
