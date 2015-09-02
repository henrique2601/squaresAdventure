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
    
    static var HUDZPosition:CGFloat = 1000
    
    static var currentSceneSize:CGSize!
    
    static var defaultGoTransition:SKTransition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 0)
    static var defaultBackTransition:SKTransition = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0)
    
    static func sceneSize() -> CGSize {
        
        switch(UIDevice.currentDevice().systemVersion[0] as String) {
        case "8":
            let sceneSize:CGSize = CGSize(width: 1334/2, height: 750/2)
            
            let xScale = skViewBoundsSize.width / sceneSize.width
            let yScale = skViewBoundsSize.height / sceneSize.height
            var scale = min(xScale, yScale)
            
            Config.translate = CGPoint(x: ((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
                y: ((skViewBoundsSize.height - (sceneSize.height * scale))/2)/scale)
            
            Config.currentSceneSize = CGSize(width: skViewBoundsSize.width / scale, height: skViewBoundsSize.height / scale)
            return Config.currentSceneSize
            
        default:
            var scale = 1
            Config.translate = CGPoint.zeroPoint
            Config.currentSceneSize = CGSize(width: 1334/2, height: 750/2)
            return Config.currentSceneSize
        }
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
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
    :param: lower number Int
    :param: upper number Int
    :return: random number Int
    */
    public static func random(#min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    /**
    Create a random num Int
    :param: lower number CGFloat
    :param: upper number CGFloat
    :return: random number Int
    */
    public static func random(#min: CGFloat, max: CGFloat) -> Int {
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
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    */
    public static func random(#min: Double, max: Double) -> Double {
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
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    */
    public static func random(#min: Float, max: Float) -> Float {
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
    public static func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

extension NSSet: ArrayLiteralConvertible {
    public class func convertFromArrayLiteral(elements: AnyObject...) -> Self {
        return self(array: elements)
    }
}
