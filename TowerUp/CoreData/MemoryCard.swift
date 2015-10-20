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
    
    internal enum controlsConfig:Int {
        case none  = 0
        case useButtons = 1
        case useLeftSliderAndScreenRight = 2
    }
    
    override init() {
        super.init()
        self.loadGame()
    }
    
    func currentTower() -> TowerData {
        return MemoryCard.sharedInstance.playerData.towers[MapManager.tower < 0 ? 0 : MapManager.tower] as! TowerData
    }
    
    func currentFloor() -> FloorData {
        let towerData = self.currentTower()
        return towerData.floors[MapManager.floor] as! FloorData
    }
    
    func newGame() {
        print("Creating new game...")
        
        //Player
        self.playerData = self.newPlayerData()
        
        //Towers e Floors
        let tower = self.newTowerData()
        let floor = self.newFloorData()
        tower.addFloor(floor)
        
        self.playerData.addTower(tower)
        
        //PowerUps
        self.playerData.powerUpSlots = NSOrderedSet(array: [
            self.newPowerUpSlotData(),
            self.newPowerUpSlotData(),
            self.newPowerUpSlotData()
            ])// Fixado 3 slots
        
        for (var i = 0; i < PowerUps.types.count; i++) {//Teste com todos os PowerUps desbloqueados no inicio do jogo
            let powerUp = self.newPowerUpData()
            powerUp.index = NSNumber(integer: i)
            powerUp.available = NSNumber(integer: 10)
            self.playerData.addPowerUp(powerUp)
        }
        
        
        //Skins
        let skin = self.newSkinData()
        skin.locked = NSNumber(bool: false)
        skin.index = Int.random(10)
        skin.available = NSNumber(integer: 10)
        self.playerData.addSkin(skin)
        
        self.playerData.skinSlot = self.newSkinSlotData()
        self.playerData.skinSlot.skin = skin
        
        

        
        self.autoSave = true
        
        self.saveGame()
    }
    
    func saveGame() {
        if(self.autoSave) {
            self.autoSave = false
            print("Saving game...")
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func loadGame() {
        
        if let _ = self.playerData {
            print("Game already loaded.")
        } else {
            let fetchRequestData:NSArray = fetchRequest()
            
            if(fetchRequestData.count > 0){
                print("Loading game...")
                self.playerData = (fetchRequestData.lastObject as! PlayerData)
                self.autoSave = true
            } else {
                self.newGame()
            }
        }
    }
    
    func reset(){
        print("MemoryCard.reset()")
        
        let fetchRequestData:NSArray = fetchRequest()
        
        for item in fetchRequestData {
            self.managedObjectContext!.deleteObject(item as! NSManagedObject)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.newGame()
    }
    
    func fetchRequest() -> NSArray{
        let fetchRequest = self.managedObjectModel.fetchRequestTemplateForName("FetchRequest")!
        let fetchRequestData: NSArray! = try? self.managedObjectContext!.executeFetchRequest(fetchRequest)
        return fetchRequestData
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PabloHenri91.TowerUp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
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
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
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
            print("Deleta o App e teste de novo. =}")
            //abort()
        } catch {
            fatalError()
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
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    func newPlayerData() -> PlayerData {
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: self.managedObjectContext!) as! PlayerData
        
        playerData.name = String.randomStringWithLength(8)
        playerData.coins = NSNumber(int: 100)
        playerData.gems = NSNumber(int: 0)
        playerData.configControls = NSNumber(integer: controlsConfig.useLeftSliderAndScreenRight.rawValue)
        
        playerData.soundEnabled = NSNumber(bool: false)
        playerData.musicEnabled = NSNumber(bool: false)
        
        return playerData
    }
    
    func newTowerData() -> TowerData {
        return NSEntityDescription.insertNewObjectForEntityForName("TowerData", inManagedObjectContext: self.managedObjectContext!) as! TowerData
    }
    
    func newFloorData() -> FloorData {
        let floorData = NSEntityDescription.insertNewObjectForEntityForName("FloorData", inManagedObjectContext: self.managedObjectContext!) as! FloorData
        floorData.bonus = NSNumber(bool: false)
        floorData.deaths = NSNumber(bool: false)
        floorData.time = NSNumber(bool: false)
        floorData.gemAvailable = NSNumber(bool: true)
        return floorData
    }
    
    func newPowerUpData() -> PowerUpData {
        return NSEntityDescription.insertNewObjectForEntityForName("PowerUpData", inManagedObjectContext: self.managedObjectContext!) as! PowerUpData
    }
    
    func newSkinData() -> SkinData {
        return NSEntityDescription.insertNewObjectForEntityForName("SkinData", inManagedObjectContext: self.managedObjectContext!) as! SkinData
    }
    
    func newSkinSlotData() -> SkinSlotData {
        return NSEntityDescription.insertNewObjectForEntityForName("SkinSlotData", inManagedObjectContext: self.managedObjectContext!) as! SkinSlotData
    }
    
    func newPowerUpSlotData() -> PowerUpSlotData {
        return NSEntityDescription.insertNewObjectForEntityForName("PowerUpSlotData", inManagedObjectContext: self.managedObjectContext!) as! PowerUpSlotData
    }
    
    func newInvitedFriend(id:String) -> InvitedFriendData {
        let invitedFriendData = NSEntityDescription.insertNewObjectForEntityForName("InvitedFriendData", inManagedObjectContext: self.managedObjectContext!) as! InvitedFriendData
        invitedFriendData.id = id
        return invitedFriendData
    }
}


