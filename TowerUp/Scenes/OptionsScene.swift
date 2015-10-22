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
        case invite
        case soundConfig
    }
    
    var state = states.options
    var nextState = states.options
    
    var blackSpriteNode:SKSpriteNode!
    
    var chooseControlsScrollNode:ScrollNode!
    
    var labelLoading:Label!
    var labelScale: CGFloat! = 1
    var growing : Bool = true
    
    var buttonDeleteSavedGame:Button!
    var buttonChooseControls:Button!
    var buttonBack:Button!
    var buttonInvite:Button!
    var buttonSoundConfig:Button!
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    //facebook Request
    var after:String = ""
    var idFriendArray = NSMutableArray()
    var blockedArray = NSMutableArray()
    var nameFriendArray = NSMutableArray()
    var loadingImage:SKSpriteNode!
    
    lazy var deathEffect:SKAction = {
        return SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI * 2), duration: 1))
        }()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.backgroundColor = GameColors.blue
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.buttonInvite = Button(textureName: "buttonBlueSmall", text:"INVITE", x: 20, y: 406)
        self.addChild(self.buttonInvite)
        
        self.buttonDeleteSavedGame = Button(textureName: "buttonBlueSmall", text:"DELETE", x: 20, y: 202)
        self.addChild(self.buttonDeleteSavedGame)
        
        self.buttonChooseControls = Button(textureName: "buttonBlueSmall", text:"CONTROLS", x: 20, y: 304)
        self.addChild(self.buttonChooseControls)
        
        self.buttonSoundConfig = Button(textureName: "buttonBlueSmall", icon:"music", x: 274, y: 202)
        self.addChild(self.buttonSoundConfig)
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", text:"<", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.buttonBack.zPosition = Config.HUDZPosition * 2 + 1
        self.addChild(self.buttonBack)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if(self.state == self.nextState){
            switch (self.state) {
                
            case states.invite:
                
                break
                
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
                
                if let teste = self.loadingImage {
                    teste.removeFromParent()
                }
                break
                
            case states.chooseControls:
                
                var controlsArray = Array<SKSpriteNode>()
                
                var spriteNode = SKSpriteNode(imageNamed: "useButtons")
                controlsArray.append(spriteNode)
                
                spriteNode = SKSpriteNode(imageNamed: "useLeftSliderAndScreenRight")
                controlsArray.append(spriteNode)
                
                self.chooseControlsScrollNode = ScrollNode(x: 667, y: 466, cells:controlsArray, spacing:1, scaleNodes:true, scaleDistance:1334/4 + 100, index:self.playerData.configControls.integerValue - 1)
                self.addChild(self.chooseControlsScrollNode)
                
                let size = self.size.width > self.size.height ? self.size.width : self.size.height
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: CGSize(width: size * 2, height: size * 2))
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.chooseControlsScrollNode.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.invite:
                
                let size = self.size.width > self.size.height ? self.size.width : self.size.height
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: 1334/4, y: -750/4)
                self.addChild(self.loadingImage)
                
                self.loadingImage.runAction(self.deathEffect)
                
                self.blackSpriteNode = SKSpriteNode(color: GameColors.black, size: CGSize(width: size * 2, height: size * 2))
                self.blackSpriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(self.blackSpriteNode)
                
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.inviteFriends(nil, limit: 50)
                
                break
                
            case states.soundConfig:
                
                let box = SoundConfigBox()
                
                let buttonOk = Button(textureName: "buttonBlueSmall", text: "Ok", x: 53, y: 253)
                buttonOk.addHandler({
                    self.nextState = .options
                    if let parent = buttonOk.parent {
                        parent.removeFromParent()
                    }
                })
                
                self.addChild(box)
                box.addChild(buttonOk)
                
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
                
            case states.invite:
                
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .options
                        return
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

                    if (self.buttonInvite.containsPoint(location)) {
                        //self.inviteFriends(nil, limit: 50)
                        self.nextState = .invite
                        return
                    }
                    
                    if (self.buttonSoundConfig.containsPoint(location)) {
                        self.nextState = .soundConfig
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
        
        
        if (self.idFriendArray.count == 50 || after == "end"){
        
            for value in self.nameFriendArray
            {
                self.playerData.addInvitedFriend(MemoryCard.sharedInstance.newInvitedFriend(value as! String))
            }
            
            self.playerData.coins = NSNumber(integer: self.playerData.coins.integerValue + self.nameFriendArray.count )
            
            
            
            self.idFriendArray.removeAllObjects()
            self.nameFriendArray.removeAllObjects()
            
            if ( after != "end"){
                self.inviteFriends(after, limit: 50)
            }
            
        }
        
        else {
            
            if (after != ""){
                //print(self.after)
                self.inviteFriends(self.after, limit: 50 - self.idFriendArray.count)
            }
        
        }
        
        
        
        
        
        
    }
    
    func inviteFriends(nextCursor : String? , limit: Int){
        
        
        var params: NSMutableDictionary = ["fields": "name" ]
        
        if nextCursor != nil {
            params.setObject(nextCursor!, forKey: "after")
        }
        
        
        for friend in self.playerData.invitedFriends as! Set<InvitedFriendData> {
        
            self.blockedArray.addObject(friend.id)
        }

       
        let request: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me/invitable_friends?limit=\(limit)", parameters: params as [NSObject : AnyObject], HTTPMethod: "GET")
        
        request.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            
            if (result != nil && error == nil){
                
                //print (result)
                let resultdict = result as! NSDictionary
                let friendArray = result.objectForKey("data") as! Array<NSDictionary>
            
                for item in friendArray
                {
                    var needInvite = true
                    for invitedFriendData in self.playerData.invitedFriends as! Set<InvitedFriendData> {
                        if invitedFriendData.id == item.objectForKey("name") as! String {
                            needInvite = false
                            break
                        }
                    }
                    
                    if(needInvite) {
                        if let idFriend = item.objectForKey("id"){
                            self.idFriendArray.addObject(idFriend)
                            self.nameFriendArray.addObject(item.objectForKey("name")!)
                            //self.playerData.addInvitedFriend(MemoryCard.sharedInstance.newInvitedFriend(item.objectForKey("name") as! String))
                        }
                    }
                }
                
                print(self.idFriendArray.count.description + "amigos")
                
                
                if let test = ((resultdict.objectForKey("paging") as? NSDictionary)?.objectForKey("cursors") as? NSDictionary)?.objectForKey("after") as? String {
                    self.after = test
                }
                
                if let _ = ((resultdict.objectForKey("paging") as? NSDictionary)?.objectForKey("next") as? String){
                    
                }
                    
                    
                else {
                    self.after = "end"
                    print("fim")
                }
                
                if (self.idFriendArray.count == 50 || self.after == "end" ){
                    
                    if (self.idFriendArray.count > 0){
                        //print(idFriendArray.description)
                        
                        
                        var gameRequestContent : FBSDKGameRequestContent = FBSDKGameRequestContent()
                        gameRequestContent.message = "Venha jogar este divertido jogo comigo e ganhar muitos diamantes"
                        gameRequestContent.title = "TowerUP"
                        gameRequestContent.recipients = self.idFriendArray as [AnyObject]
                        gameRequestContent.actionType = FBSDKGameRequestActionType.Turn
                        
                        
                        var dialog : FBSDKGameRequestDialog = FBSDKGameRequestDialog()
                        dialog.frictionlessRequestsEnabled = true
                        dialog.content = gameRequestContent
                        dialog.delegate = self
                        
                        if dialog.canShow(){
                            dialog.show()
                        }
                    }
                    
                    else {
                        print("assistir video")
                        //assitir video aqui
                        self.nextState = .options
                    }
                    

                    
                }
                
                else {
                    
                    
                    self.inviteFriends(self.after, limit: 50 - self.idFriendArray.count)
                    
                }
                
            } else if (result == nil){
                self.loginFromInvite()
            }
            
        })
    }
    
    
    func loginFromInvite()
    {
        var permissions = [ "public_profile", "email", "user_friends" ]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                self.inviteFriends(nil, limit: 50)
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
        return
    }
    

}


//func getFBTaggableFriends(nextCursor : String?, failureHandler: (error: NSError) -> Void) {
//    var qry : String = "me/taggable_friends"
//    var parameters = Dictionary<String, String>() as? Dictionary
//    if nextCursor == nil {
//        parameters = nil
//    } else {
//        parameters!["after"] = nextCursor
//    }
//    // Facebook: get taggable friends with pictures
//    var request = FBSDKGraphRequest(graphPath: qry, parameters: parameters)
//    request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//        if ((error) != nil)
//        {
//            // Process error
//            print("Error: \(error)")
//        }
//        else
//        {
//            //println("fetched user: \(result)")
//            var resultdict = result as! NSDictionary
//            var data : NSArray = resultdict.objectForKey("data") as! NSArray
//            
//            for i in 0..<data.count {
//                let valueDict : NSDictionary = data[i] as! NSDictionary
//                let id = valueDict.objectForKey("id") as! String
//                let name = valueDict.objectForKey("name") as! String
//                let pictureDict = valueDict.objectForKey("picture") as! NSDictionary
//                let pictureData = pictureDict.objectForKey("data") as! NSDictionary
//                let pictureURL = pictureData.objectForKey("url") as! String
//                print("Name: \(name)")
//                //println("ID: \(id)")
//                //println("URL: \(pictureURL)")
//            }
//            if let after = ((resultdict.objectForKey("paging") as? NSDictionary)?.objectForKey("cursors") as? NSDictionary)?.objectForKey("after") as? String {
//                self.getFBTaggableFriends(after, failureHandler: {(error) in
//                    println("error")})
//            } else {
//                print("Can't read next!!!")
//            }
//        }
//    }

//}
