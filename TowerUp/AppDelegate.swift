//
//  AppDelegate.swift
//
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import Bolts
import Parse
import CoreData
import ParseFacebookUtilsV4
import AdSupport
import Fabric
import Crashlytics

// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable storing and querying data from Local Datastore. 
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        

        
        Fabric.with([Crashlytics.self])
        Parse.enableLocalDatastore()

        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        // Uncomment and fill in with your Parse credentials:
        Parse.setApplicationId("IvYhNIyO7wyJsDF4181S9iddoTg1QmrjUGcoPPnD", clientKey: "L3muupUM7rmO6BLmfNVZ6kymNYdYY3JCJmGVsmti")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside TowerUp-Bridging-Header and the following line here:
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        // ****************************************************************************

        PFUser.enableAutomaticUser()
        
        //Configure AdColony once on app launch
        AdColony.configureWithAppID("app5d136cde2e2547ad9f", zoneIDs: ["vz8a4089d331e742a9a1"], delegate: nil, logging: true)

        let defaultACL = PFACL()

        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)

        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)

        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
                print("lauch por notificacao 1")
                print(pushPayload)
        
                
            }
        }

        
        // Extract the notification data
        if let notificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            
            
            let roomID = notificationPayload["roomID"] as? NSString
            
            
            NSNotificationCenter.defaultCenter().postNotificationName("privateGameInvite", object: roomID)
            
            return true
            
        }
        
        //Delay the fade of the HYDRA LOGO
        
        //sleep(1 as UInt32)

        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        MemoryCard.sharedInstance.saveGame()
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation["user"] = PFUser.currentUser()
        

        
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    


    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == UIApplicationState.Inactive {
            
       
            let roomID = userInfo["roomID"] as? NSString
            
            print("recebi push quando tava inativo ")
            //print(userInfo)
            
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            
            NSNotificationCenter.defaultCenter().postNotificationName("privateGameInvite", object: roomID)
        } else {
            
            let roomID = userInfo["roomID"] as? NSString
            
            print("recebi push quando tava ativo")
            //print(userInfo)
    
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            
            print("Room da notification" + (roomID! as String))
            
            
            completionHandler(UIBackgroundFetchResult.NoData)
            NSNotificationCenter.defaultCenter().postNotificationName("privateGameInvite", object: roomID)
            
        }
        
        
        
    }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
}
