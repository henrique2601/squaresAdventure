//
//  Camera.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class Camera: SKNode {
    func update(newPosition:CGPoint) {
        self.position = CGPoint(x: newPosition.x - self.scene!.size.width/2 , y: newPosition.y + self.scene!.size.height/2)
        self.scene!.centerOnNode(self)
    }
}
