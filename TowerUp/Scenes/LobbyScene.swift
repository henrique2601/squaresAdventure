//
//  LobbyScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/7/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class LobbyScene: GameScene, UITextFieldDelegate {
    enum states {
        case lobby
        case multiplayerMission
        case mainMenu
    }
    
    var room: Int = 0
    var state = states.lobby
    var nextState = states.lobby
    let socket = SocketIOClient(socketURL: "179.232.86.110:3001", options: nil)

    var myTextField: UITextField!
    
    var labelName:Label!
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.addChild(Control(name: "mainMenuBackground", x:0, y:0, align:.center))
        
        
        
        
        self.addChild(Button(name: "buttonRoom0", textureName: "buttonYellow", text:"room0", x: 550, y: 289, align:.center))
        
        
        self.addChild(Button(name: "buttonRoom1", textureName: "buttonYellow", text:"room1", x: 550, y: 387, align:.center)) // y = 98
        self.addChild(Button(name: "buttonRoom2", textureName: "buttonYellow", text:"room2", x: 550, y: 485, align:.center))
        self.addChild(Button(name: "buttonRoom3", textureName: "buttonYellow", text:"room3", x: 550, y: 583, align:.center))
        
        self.addChild(Button(name: "buttonBack", textureName: "buttonGraySquareSmall", x: 20, y: 652, xAlign:.left, yAlign:.down))
        
        
        myTextField = UITextField(frame: CGRect(x: 290, y: 100, width: 130, height: 40.00))
        self.view?.addSubview(myTextField)
        myTextField.delegate = self
        myTextField.backgroundColor = GameColors.white
        myTextField.text = self.randomStringWithLength(8) as String
        myTextField.borderStyle = UITextBorderStyle.RoundedRect

        
    }
    
    // Called by tapping return on the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    

    
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.multiplayerMission:
                var nextScene  = MultiplayerGameScene()
                nextScene.room = self.room
                nextScene.localName = self.myTextField.text
                self.view!.presentScene(nextScene, transition: Config.defaultGoTransition)
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultBackTransition)
                break
                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.lobby:
                for touch in (touches as! Set<UITouch>) {
                    let location = touch.locationInNode(self)
                    
                    if (self.childNodeWithName("buttonRoom0")!.containsPoint(location)) {
                        room = 0
                        myTextField.removeFromSuperview()
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonRoom1")!.containsPoint(location)) {
                        room = 1
                        myTextField.removeFromSuperview()
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonRoom2")!.containsPoint(location)) {
                        room = 2
                        myTextField.removeFromSuperview()
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonRoom3")!.containsPoint(location)) {
                        room = 3
                        myTextField.removeFromSuperview()
                        self.nextState = .multiplayerMission
                        return
                    }
                    
                    if (self.childNodeWithName("buttonBack")!.containsPoint(location)) {
                        myTextField.removeFromSuperview()
                        self.nextState = .mainMenu
                        return
                    }
                    
                    
                }
                break
                
            default:
                break
            }
        }
    }
}
