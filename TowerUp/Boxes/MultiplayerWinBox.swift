//
//  MultiplayerWinBox.swift
//  TowerUp
//
//  Created by Pablo Henrique on 28/08/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class MultiplayerWinBox: Box {
    

    var buttonExit:Button!
    
    init(background: String, winPlayersList: Array<String>) {
        super.init(textureName: background)
        
        var nodesList = Array<WinCell>()
        
        for (var i = 0; i < winPlayersList.count; i++) {
            var playerArray = winPlayersList[i].characters.split{$0 == ","}.map(String.init)
            let skin = Int(playerArray[0])
            let name = playerArray[1]
            let time = Int(playerArray[2])
            let cell = WinCell(position: i, skin: skin!, name: name, time: time!)
            nodesList.append(cell)
//            nodesList.append(WinCell(position: 1, skin: 1, name: "teste1", time: 20))
//            nodesList.append(WinCell(position: 2, skin: 2, name: "teste2", time: 30))
//            nodesList.append(WinCell(position: 3, skin: 3, name: "teste3", time: 40))
//            nodesList.append(WinCell(position: 4, skin: 4, name: "teste4", time: 50))
//            nodesList.append(WinCell(position: 5, skin: 5, name: "teste5", time: 60))
//            nodesList.append(WinCell(position: 6, skin: 6, name: "teste6", time: 70))
//            nodesList.append(WinCell(position: 7, skin: 7, name: "teste7", time: 80))
        }
        
        
        let rola = ScrollNode(x: 400, y: 288, xAlign: .center, yAlign: .center, cells: nodesList, spacing: 0, scrollDirection: ScrollNode.scrollTypes.vertical, scaleNodes: false)
        self.addChild(rola)
        
        
        
        
        self.buttonExit = Button(textureName: "buttonGraySquare", text:"X", x: 650, y: 436)
        self.addChild(self.buttonExit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if (self.buttonExit.containsPoint(location)) {
                if let scene = self.scene as? MultiplayerMissionScene {
                    scene.socket.disconnect()
                    PlayerOnline.playerOnlineList = Set<PlayerOnline>()
                    scene.view!.presentScene(LobbyScene(), transition: Config.defaultTransition)
                }
                
                if let scene = self.scene as? LocalGameScene {
                    scene.view!.presentScene(MainMenuScene(), transition: Config.defaultTransition)
                }
                
                return
            }
        }
    }
}
