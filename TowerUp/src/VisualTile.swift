//
//  VisualTile.swift
//  TowerUp
//
//  Created by Pablo Henrique on 24/09/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class VisualTile: Tile {
    init(id:Int, x:Int, y:Int) {
        super.init(imageName: "visual" + String(id - (64*2)), x: x, y: y)
        self.zPosition = -1
  }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
