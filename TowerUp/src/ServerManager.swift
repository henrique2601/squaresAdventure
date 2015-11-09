//
//  ServerManager.swift
//  Squares Adventure
//
//  Created by Paulo Henrique dos Santos on 15/10/15.
//  Copyright © 2015 WTFGames. All rights reserved.
//

import UIKit

class ServerManager: NSObject, GBPingDelegate {
    
    
    
    let ping = GBPing()
    var responseTime: Int = 0
    var numResponses: Int = 0
    var servers = ["181.41.197.181", "https://squaregame.mybluemix.net"]
    var serversSocket = ["181.41.197.181:8081", "https://squaregame.mybluemix.net"]
    var count: Int = 0
    var minTime: Int = 999999
    var minServer: String!
    var server: String!
    
    static let sharedInstance = ServerManager()
    
    func bestServer(returnBlock: (String) -> ()){
        self.server = servers[self.count]
        self.ping.host = self.server
        //print("pinging " + self.count.description + " " + self.ping.host)
        self.ping.delegate = self
        self.ping.timeout = 1.0
        self.ping.pingPeriod = 0.9
        self.ping.setupWithBlock({ success, error in
            if success {
                
                self.ping.startPinging()
                
                dispatch_after(
                    dispatch_time(DISPATCH_TIME_NOW,
                        numericCast(UInt64(1 *
                            Double(NSEC_PER_SEC)))),
                    dispatch_get_global_queue(
                        DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                    {
                        do {
                            try self.stopPing()
                            
//                            print(self.count)
//                            print(self.servers.count)
                            
                            self.count++
                            print("self.count " + self.count.description)
                            print("self.servers.count " + self.servers.count.description)
                            if (self.count < self.servers.count ) {
                                self.bestServer(returnBlock)
                            } else {
                                
                                self.count = 0
                                
                                print("fim")
                                
                                if let _ = self.minServer {
                                  returnBlock(self.minServer)
                                } else {
                                    print("erro fim")
                                    returnBlock("erro")
                                }
                                
                                
                                
                            }
                            
                        }
                        catch {
                            print("Error during async execution")
                            print(error)
                        }
                    }
                )

            }
            
        })
        
    }
    
    func stopPing(){
        
        self.ping.stop()
//        print("stoped")
//        print("num responses " + self.numResponses.description)
//        print("response time " + self.responseTime.description)
//        print("count" + self.count.description)
        if (self.numResponses > 0) {
            
            var avg = (self.responseTime / self.numResponses)
//            print("avg" + avg.description)
//            print("minTime" + self.minTime.description)
            if (avg < self.minTime)
            {
                //print("menor" + self.servers[self.count])
                self.minTime = avg
                self.minServer = self.serversSocket[self.count]
            }
        }
        
        

    }
    

    //ping protocol
    
    func ping(pinger: GBPing!, didReceiveReplyWithSummary summary: GBPingSummary!) {
        //print(summary)
        self.responseTime = self.responseTime + Int(summary.rtt * 1000)
        self.numResponses = self.numResponses + 1
    }
    
    //    func ping(pinger: GBPing!, didFailToSendPingWithSummary summary: GBPingSummary!, error: NSError!) {
    //        print(summary)
    //        print(error)
    //    }
    //
    //    func ping(pinger: GBPing!, didFailWithError error: NSError!) {
    //        //print(error)
    //    }
    //
    //    func ping(pinger: GBPing!, didReceiveUnexpectedReplyWithSummary summary: GBPingSummary!) {
    //        print(summary)
    //    }
    //
    //    func ping(pinger: GBPing!, didSendPingWithSummary summary: GBPingSummary!) {
    //        print(summary)
    //    }
    //
    //    func ping(pinger: GBPing!, didTimeoutWithSummary summary: GBPingSummary!) {
    //        print(summary)
    //    }
    
    
    

}
