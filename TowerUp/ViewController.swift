//
//  ViewController.swift
//
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    //static var memoryCard = MemoryCard()
    
    var teste : String?
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = true
        
        #if DEBUG
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsDrawCount = true
//            skView.showsFields = true
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            skView.showsPhysics = true
//            skView.showsQuadCount = true
        #endif
        
        //skView.showsPhysics = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        Config.skViewBoundsSize = skView.bounds.size
        Config.updateSceneSize()
        
       var scene: SKScene!
        
        if let abc = self.teste {
           print("variavel teste" + abc)
              //scene = PrivateLobbySceneSecondary(roomName: self.fbID)
        } else {
              scene = MainMenuScene()
        }
        
        
        skView.presentScene(scene)
        
        IAPHelper.sharedInstance.requestProducts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Configure the view.
        let skView = self.view as! SKView
        
        Config.skViewBoundsSize = skView.bounds.size
        
        skView.scene?.size = Config.updateSceneSize()
        Control.resetControls()
        
        if let gameScene = skView.scene as? GameScene {
            gameScene.blackSpriteNode.update()
            gameScene.setBackground()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .all
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

