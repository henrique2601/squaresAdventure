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
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            skView.showsFields = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            skView.showsQuadCount = true
        #endif
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        Config.skViewBoundsSize = skView.bounds.size
        
        let scene = MainMenuScene()
        skView.presentScene(scene)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Configure the view.
        let skView = self.view as! SKView
        
        Config.skViewBoundsSize = skView.bounds.size
        
        skView.scene?.size = Config.sceneSize()
        Control.resetControls()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.Landscape
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
}

