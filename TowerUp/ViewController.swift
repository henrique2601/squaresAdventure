//
//  ViewController.swift
//
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import Parse
import SpriteKit

class ViewController: UIViewController {
    
    //static var memoryCard = MemoryCard()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.multipleTouchEnabled = true
        
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
        
        let scene = MainMenuScene()
        skView.presentScene(scene)
        
        IAPHelper.sharedInstance.requestProducts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Configure the view.
        let skView = self.view as! SKView
        
        Config.skViewBoundsSize = skView.bounds.size
        
        skView.scene?.size = Config.sceneSize()
        Control.resetControls()
        
        if let gameScene = skView.scene as? GameScene {
            gameScene.blackSpriteNode.update()
            gameScene.setBackground()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.All
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    static func triggerVideo()
    {
        AdColony.playVideoAdForZone("vzcc126525fc244e9da4", withDelegate: nil)
    }

}

