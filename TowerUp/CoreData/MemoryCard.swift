//
//  MemoryCard.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import CoreData

class MemoryCard: NSObject {
    
    static let sharedInstance = MemoryCard()
    
    private var autoSave:Bool = false
    
    var playerData:PlayerData!
    
    func newGame() {
        println("Creating new game...")
        
        //Player
        self.playerData = self.newPlayerData()
        self.playerData.coins = NSNumber(int: 1000)
        self.playerData.name = String.randomStringWithLength(8)

        
        //Towers e Floors
        var tower = self.newTowerData()
        var floor = self.newFloorData()
        tower.addFloor(floor)
        
        self.playerData.addTower(tower)
        
        //PowerUps
        var powerUp = self.newPowerUpData()
        powerUp.index = 0
        powerUp.available = NSNumber(integer: 10)
        self.playerData.addPowerUp(powerUp)
        
        //Skins
        var skin = self.newSkinData()
        skin.locked = NSNumber(bool: false)
        skin.index = Int.random(10)
        skin.available = NSNumber(bool: true)
        self.playerData.addSkin(skin)
        
        self.playerData.currentSkin = skin
        
        self.autoSave = true
        
        self.saveGame()
    }
    
    func saveGame() {
        if(self.autoSave){
            println("Saving game...")
            self.saveContext()
        }
    }
    
    func loadGame() {
        
        if let playerData = self.playerData {
            println("Game already loaded.")
        } else {
            let fetchRequestData:NSArray = fetchRequest()
            
            if(fetchRequestData.count > 0){
                println("Loading game...")
                self.playerData = (fetchRequestData.lastObject as! PlayerData)
                self.autoSave = true
            } else {
                self.newGame()
            }
        }
    }
    
    func reset(){
        println("MemoryCard.reset()")
        
        let fetchRequestData:NSArray = fetchRequest()
        
        for item in fetchRequestData {
            self.managedObjectContext!.deleteObject(item as! NSManagedObject)
        }
        
        self.playerData = nil
        
        self.autoSave = false
    }
    
    func fetchRequest() -> NSArray{
        let fetchRequest = self.managedObjectModel.fetchRequestTemplateForName("FetchRequest")!
        let fetchRequestData: NSArray! = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)
        return fetchRequestData
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PabloHenri91.TowerUp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("TowerUp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("TowerUp.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func newPlayerData() -> PlayerData {
        return NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: self.managedObjectContext!) as! PlayerData
    }
    
    func newTowerData() -> TowerData {
        return NSEntityDescription.insertNewObjectForEntityForName("TowerData", inManagedObjectContext: self.managedObjectContext!) as! TowerData
    }
    
    func newFloorData() -> FloorData {
        return NSEntityDescription.insertNewObjectForEntityForName("FloorData", inManagedObjectContext: self.managedObjectContext!) as! FloorData
    }
    
    func newPowerUpData() -> PowerUpData {
        return NSEntityDescription.insertNewObjectForEntityForName("PowerUpData", inManagedObjectContext: self.managedObjectContext!) as! PowerUpData
    }
    
    func newSkinData() -> SkinData {
        return NSEntityDescription.insertNewObjectForEntityForName("SkinData", inManagedObjectContext: self.managedObjectContext!) as! SkinData
    }
}
