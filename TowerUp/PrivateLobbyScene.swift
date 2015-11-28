//
//  PrivateLobbyScene.swift
//  TowerUp
//
//  Created by Paulo Henrique Bertaco on 18/11/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit
import ParseFacebookUtilsV4



class PrivateLobbyScene: GameScene, FBSDKGameRequestDialogDelegate, UIApplicationDelegate {
    enum states {
        case loading
        case lobby
        case invite
        case returnLobby
    }
    
  
    var playerData = MemoryCard.sharedInstance.playerData
    
    var buttonInvite:Button!
    var buttonGo:Button!
    var buttonBack:Button!
    
    var state = states.loading
    var nextState = states.lobby
    
    var boxCoins:BoxCoins!
    
    var cropBox:CropBox!
    var friendsScroll:ScrollNode!
    var picNodes = Array<Control>()
    
    //facebook Request
    var after:String = ""
    var idFriendArray = NSMutableArray()
    var idFriendPushArray = NSMutableArray()
    var blockedArray = NSMutableArray()
    var nameFriendArray = NSMutableArray()
    var picsArray = NSMutableArray()
    var loadingImage:SKSpriteNode!
    
    lazy var deathEffect:SKAction = {
        return SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI * 2), duration: 1))
    }()
    

    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.addChild(Control(textureName: "background", x:-49, y:-32, z: -1001, xAlign: .center, yAlign: .center))
        
        Music.sharedInstance.play(musicNamed: "som de fundo do menu.wav")
        
        self.cropBox = CropBox(textureName: "lobby1", z: -1000, xAlign: .center, yAlign: .center)
        self.friendsScroll = ScrollNode(x: 793, y: 288, cells: Array<SKNode>(), spacing: 16, scrollDirection: .vertical)
        self.cropBox.addChild(self.friendsScroll)
        
        self.addChild(self.cropBox)
        self.backgroundColor = GameColors.blue
        
        self.buttonInvite = Button(textureName: "buttonPink", text:"INVITE FRIENDS", x: 229, y: 325, xAlign: .center, yAlign: .center, fontColor:.white)
        self.addChild(self.buttonInvite)
        
        self.buttonGo = Button(textureName: "buttonPink", text:"GO", x: 229, y: 476, xAlign: .center, yAlign: .center, fontColor:.white)
        self.addChild(self.buttonGo)
        
    
        

        
        
        self.boxCoins = BoxCoins()
        self.addChild(boxCoins)
        
        
        self.buttonBack = Button(textureName: "buttonGraySquareSmall", icon:"return", x: 20, y: 652, xAlign:.left, yAlign:.down)
        self.addChild(self.buttonBack)
        
        

        
        self.loadFriends()
        
    }
    
    
    func loadFriends(){
        
        let params: NSMutableDictionary = ["fields": "name" ]
        
        var friendCell:FriendCell!
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: params as [NSObject : AnyObject], HTTPMethod: "GET")
        
        
        
        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    
                    
                    let resultDictionary = result as? NSDictionary
                    
                    print(resultDictionary)
                    let user = PFUser.currentUser()
                    user?.setObject((resultDictionary?.objectForKey("id"))!.description, forKey: "fbID")
                    user?.setObject((resultDictionary?.objectForKey("name"))!.description, forKey: "name")
                    user?.saveInBackground()
                    
                    let installation = PFInstallation.currentInstallation()
                    installation.setObject(user!, forKey: "user")
                    installation.setObject((resultDictionary?.objectForKey("id"))!.description, forKey: "userFbID")
                    
                    installation.saveInBackground()
                    
                }
            })
        }
        
        
        
        
        request.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
            
            if (result != nil && error == nil){
                
                //print("request rodado")
                
                //print (result)
    
                let friendArray = result.objectForKey("data") as! Array<NSDictionary>
                
                //print(friendArray)
                
                for item in friendArray
                {
                    let facebookID = item["id"] as! String
                    self.idFriendPushArray.addObject(facebookID)
                    
                    let pictureURL = NSURL(string: String("https://graph.facebook.com/" + facebookID + "/picture?height=50&return_ssl_resources=1"))
                    
                    //print("https://graph.facebook.com/" + facebookID + "/picture?height=50&return_ssl_resources=1")
                    self.picsArray.addObject(pictureURL!)
                    

                }
                
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    
                    
                    for picURL in self.picsArray {
                        
                       // print("assinc loop picurl")
                        
                        let url = picURL as! NSURL
                        
                        if let imageData = NSData(contentsOfURL: url) {
                            //print("carregando imagem")
                            let image = UIImage(data: imageData)
                            
                        
                                
                                let spriteNode = SKSpriteNode(texture: SKTexture(image: image!))
                                
                                let control = Control(spriteNode: spriteNode)
                                
                                self.picNodes.append(control)
                                
                                if (self.picNodes.count == 3) {
                                    //print("3 imagens, mandei para o scroll")
                                    
                                    dispatch_async(dispatch_get_main_queue()) {
                                        
                                        //adicona no scroll
                                        friendCell = FriendCell(friends: self.picNodes)
                                        self.picNodes.removeAll()
                                        self.friendsScroll.append(friendCell)
                                        
                                    }
                                    
                                }
                                
                        
                            
                            
                            
                        }
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if (self.picNodes.count > 0 ){
                            
                            //adicona no scroll
                            friendCell = FriendCell(friends: self.picNodes)
                            self.picNodes.removeAll()
                            self.friendsScroll.append(friendCell)
                            
                        }
                        

                    }
 
                    
                }
                

                
            } else if (result == nil){
                self.login()
            }
            
        })
        
        
        
        
        
        
        
    }
    
    

    

    func initializeNotificationServices() -> Void {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        // Success = didRegisterForRemoteNotificationsWithDeviceToken
        // Fail = didFailToRegisterForRemoteNotificationsWithError
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
        
        
    }
    


    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        if(self.state == self.nextState){
            switch (self.state) {
                
                
                
                
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            switch (self.nextState) {
                
            case states.invite:
                
                self.loadingImage = SKSpriteNode(imageNamed: "circleLoading")
                self.loadingImage.position = CGPoint(x: 1334/4, y: -750/4)
                self.addChild(self.loadingImage)
                
                self.loadingImage.runAction(self.deathEffect)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = Config.HUDZPosition * 2
                self.loadingImage.zPosition = self.blackSpriteNode.zPosition + 1
                
                self.inviteFriends(nil, limit: 50)
                
                break
      
                case states.lobby:
                self.blackSpriteNode.hidden = true
                
                if let teste = self.loadingImage {
                    teste.removeFromParent()
                }
                
                break
                
                
            case states.returnLobby:
                self.view!.presentScene(LobbyScene(), transition: Config.defaultTransition)
                break
                
                
                
                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if (self.state == self.nextState) {
            switch (self.state) {
            case states.lobby:
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonInvite.containsPoint(location)) {
                        self.nextState = .invite
                        return
                    }
                    
                    if (self.buttonGo.containsPoint(location)) {
                        //faz algo
                        
                        self.sendPush()
                        
                        return
                    }
                    
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .returnLobby
                        return
                    }
                    
                    if(self.boxCoins.containsPoint(location)) {
                        self.boxCoins.containsPoint()
                    }
                    
                    
                    
                }
                break
                
                
            case states.invite:
                
                for touch in (touches ) {
                    let location = touch.locationInNode(self)
                    
                    if (self.buttonBack.containsPoint(location)) {
                        self.nextState = .lobby
                        return
                    }
                }
                
                break
                
                
            default:
                break
            }
        }
    }
    
    
    func sendPush(){
        
//        // Find users near a given location
//        let userQuery = PFUser.query()
//        userQuery!.whereKey("fbID", equalTo: "1028250087225308")
//        
        // Find devices associated with these users
        let pushQuery = PFInstallation.query()
        //print(self.idFriendPushArray)
        pushQuery!.whereKey("userFbID", containedIn: self.idFriendPushArray as [AnyObject])
    
        
        let user = PFUser.currentUser()
        print(user)
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage( user!.objectForKey("name")!.description + " invited you to play")
        
        let data = [
            "alert" : user!.objectForKey("name")!.description + " invited you to play",
            "roomID" : user!.objectForKey("fbID")!.description]
        
        push.setData(data)
        push.sendPushInBackground()
        
        
        
        
        print("mandei")
        //print(userQuery)
        
    }
    
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didCompleteWithResults results: [NSObject : AnyObject]!){
        //print("complete, result:")
        
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
    
    
    func gameRequestDialog(gameRequestDialog: FBSDKGameRequestDialog!, didFailWithError error: NSError!){
        print("fail")
        print(error)
        self.idFriendArray.removeAllObjects()
        self.nameFriendArray.removeAllObjects()

    }
    
    /*!
    @abstract Sent to the delegate when the game request dialog is cancelled.
    @param gameRequestDialog The FBSDKGameRequestDialog that completed.
    */
    func gameRequestDialogDidCancel(gameRequestDialog: FBSDKGameRequestDialog!){
        print("cancel")
        self.idFriendArray.removeAllObjects()
        self.nameFriendArray.removeAllObjects()
        self.nextState = .lobby
        
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
                
                //print(self.idFriendArray.count.description + "amigos")
                
                
                if let test = ((resultdict.objectForKey("paging") as? NSDictionary)?.objectForKey("cursors") as? NSDictionary)?.objectForKey("after") as? String {
                    self.after = test
                }
                
                if let _ = ((resultdict.objectForKey("paging") as? NSDictionary)?.objectForKey("next") as? String){
                    
                }
                    
                    
                else {
                    self.after = "end"
                    //print("fim")
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
                        //TODO: assitir video aqui
                        self.nextState = .lobby
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
    
    func login(){
        
        var permissions = [ "public_profile", "email", "user_friends" ]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                

                
                
                self.initializeNotificationServices()
                self.loadFriends()
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
        
    }

    
}
