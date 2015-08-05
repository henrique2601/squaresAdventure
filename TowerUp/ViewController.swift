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
        skView.showsFPS = true
        skView.showsNodeCount = true
        
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
        Control.resetControls(skView.scene!)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
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

