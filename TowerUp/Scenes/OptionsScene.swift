//
//  OptionsScene.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit
import ParseFacebookUtilsV4

class OptionsScene: GameScene, FBSDKGameRequestDialogDelegate {
    enum states {
        case options
        case deleteSavedGame
        case chooseControls
        case mainMenu
    }
    
    var state = states.options
    var nextState = states.options
    
    var blackSpriteNode:SKSpriteNode!
    
    var chooseControlsScrollNode:ScrollNode!
    
    var buttonDeleteSavedGame:Button!
    var buttonChooseControls:Button!
    var buttonBack:Button!
    var buttonFacebook:Button!
    var buttonInvite:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        self.buttonFacebook = Button(textureName: "buttonBlueSmall", text:"FACEBOOK", x: 20, y: 406, xAlign:.center, yAlign:.center)
        self.addChild(self.buttonFacebook)
        
        self.buttonInvite = Button(textureName: "buttonBlueSmall", text:"INVITE", x: 20, y: 508, xAlign:.center, yAlign:.center)
        self.addChild(self.buttonInvite)
        
        self.buttonDeleteSavedGame = Button(textureName: "buttonBlueSmall", text:"DELETE", x: 20, y: 202)
        self.addChild(self.buttonDeleteSavedGame)
        
        self.buttonChooseControls = Button(textureName: "buttonBlueSmall", text:"CONTROLS", x: 20, y: 304)
        self.addChild(self.buttonChooseControls)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.buttonBack.zPosition = Config.HUDZPosition * 2 + 1
        self.addChild(self.buttonBack)
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
                
            case states.options:
                if let teste = self.chooseControlsScrollNode {
                    teste.removeFromParent()
                }
                if let teste = self.blackSpriteNode {
                    teste.removeFromParent()
                }
                break
                
            case states.chooseControls:
                
                var controlsArray = Array<SKSpriteNode>()
                
                var spriteNode = SKSpriteNode(imageNamed: "useButtons")
                controlsArray.append(spriteNode)
                
                spriteNode = SKSpriteNode(imageNamed: "useLeftSliderAndScreenRight")
                controlsArray.append(spriteNode)
                
                self.chooseControlsScrollNode = ScrollNode(x: 667, y: 466, cells:controlsArray, spacing:1, scaleNodes:true, scaleDistance:1334/4 + 100)
                self.addChild(self.chooseControlsScrollNode)
                
                let size = self.size.width > self.size.height ? self.size.width : self.size.height
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: CGSize(width: size * 2, height: size * 2))
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.chooseControlsScrollNode.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.deleteSavedGame:
                let box = Box(background: "messegeBox")
                
                let buttonOk = Button(textureName: "buttonRedSmall", text: "Ok", x: 266, y: 162)
                buttonOk.addHandler({
                    MemoryCard.sharedInstance.reset()
                    self.nextState = .options
                    if let parent = buttonOk.parent {
                        parent.removeFromParent()
                    }
                })
                
                let buttonCancel = Button(textureName: "buttonGraySmall", text: "Cancel", x: 12, y: 162)
                buttonCancel.addHandler({
                    self.nextState = .options
                    if let parent = buttonCancel.parent {
                        parent.removeFromParent()
                    }
                })
                
                self.addChild(box)
                box.addChild(buttonCancel)
                box.addChild(buttonOk)
                
                break
                
            case states.mainMenu:
                self.view!.presentScene(MainMenuScene(), transition: Config.defaultBackTransition)
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.chooseControls:
                
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .options
                        return
                    }
                    
                    if(touch.tapCount > 0) {
                        if (self.chooseControlsScrollNode.containsPoint(location)) {
                            
                            var i = 1
                            let locationInScrollNode = touch.locationInNode(self.chooseControlsScrollNode)
                            
                            for cell in self.chooseControlsScrollNode.cells {
                                if(cell.containsPoint(locationInScrollNode)) {
                                    let playerData = MemoryCard.sharedInstance.playerData
                                    playerData.configControls = NSNumber(integer: i)
                                    self.nextState = .options
                                    return
                                }
                                i++
                            }
                        } else {
                            self.nextState = .options
                        }
                    }
                }
                
                break
            case states.options:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonDeleteSavedGame.containsPoint(location)) {
                        self.nextState = .deleteSavedGame
                        return
                    }
                    
                    if (self.buttonChooseControls.containsPoint(location)) {
                        self.nextState = .chooseControls
                        return
                    }
                    
                    if (self.buttonFacebook.containsPoint(location)) {
                        var permissions = [ "public_profile", "email", "user_friends" ]
                        
                        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
                            if let user = user {
                                if user.isNew {
                                    print("User signed up and logged in through Facebook!")
                                } else {
                                    print("User logged in through Facebook!")
                                }
                            } else {
                                print("Uh oh. The user cancelled the Facebook login.")
                            }
                        })
                        return
                    }
                    
                    
                    
                    if (self.buttonInvite.containsPoint(location)) {

                        var idFriendArray = NSMutableArray()
                        
                        let params = ["fields": "name" ]
                        
                        var request: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me/invitable_friends", parameters: params, HTTPMethod: "GET")
                        
                        request.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
                            print(result)
                            
                            var friendArray = result.objectForKey("data") as! Array<NSDictionary>
                            
                            for item in friendArray
                            {
                                if let idFriend = item.objectForKey("id"){
                                    idFriendArray.addObject(idFriend)
                                }
                            }
                            print(idFriendArray.description)
                            
                            
                            var gameRequestContent : FBSDKGameRequestContent = FBSDKGameRequestContent()
                            gameRequestContent.message = "Venha jogar este divertido jogo comigo e ganhar muitos diamantes"
                            gameRequestContent.title = "TowerUP"
                            gameRequestContent.recipients = idFriendArray as [AnyObject]
                            gameRequestContent.actionType = FBSDKGameRequestActionType.Turn
                            
                            var dialog : FBSDKGameRequestDialog = FBSDKGameRequestDialog()
                            dialog.frictionlessRequestsEnabled = true
                            dialog.content = gameRequestContent
                            dialog.delegate = self
                            
                            if dialog.canShow(){
                                dialog.show()
                            }
                            
                        })
                        
                        
                        
//                        NSArray *friendArray = [result objectForKey:@"data"];
//                        
//                        for (NSDictionary* friendDict in friendArray) {
//                            
//                            FContact* contact = [[FContact alloc] initWithFaceBookID:friendDict[@"id"] name:friendDict[@"name"] avatarURL:friendDict[@"picture"][@"data"][@"url"]];
//                            contact.hasMyGameInstalled = !invitable;
//                            [[FStorage sharedInstance].friends addObject:contact];
//                        }
  

                        
                        
                        
                        
                        
                        
                        
                        

                        

                        
                        return
                    }
                    
                    if (self.buttonBack.containsPoint(location)) {
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
    

    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!){
        print("complete, result:")
        
    }
    

    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!){
        print("fail")
        print(error)
    }
    
    /*!
    @abstract Sent to the delegate when the game request dialog is cancelled.
    @param gameRequestDialog The FBSDKGameRequestDialog that completed.
    */
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!){
        print("cancel")
    }
    

}
