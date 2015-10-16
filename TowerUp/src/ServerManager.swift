//
//  ServerManager.swift
//  Squares Adventure
//
//  Created by Paulo Henrique dos Santos on 15/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit

class ServerManager: NSObject, GBPingDelegate {
    
    static let sharedInstance = ServerManager()
    
    let ping = GBPing()
    var responseTime: Int = 0
    var numResponses: Int = 0
    var servers = ["181.41.197.181", ""]
    
    func bestServer() -> String {
        
        
        self.ping.host = "181.41.197.181"
        self.ping.delegate = self
        self.ping.timeout = 1.0
        self.ping.pingPeriod = 0.9
        self.ping.setupWithBlock({ success, error in
            if success {
                self.ping.startPinging()
                let ns = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("stopPing"), userInfo: nil, repeats: false)
            }
            
        })
        
        return "foda-se"
    }
    
    func stopPing(){
        print("stoped")
        self.ping.stop()
        print(self.numResponses)
        print(self.responseTime)
        print("avg time = " + (self.responseTime / self.numResponses).description)
    }
    
    
    

}
