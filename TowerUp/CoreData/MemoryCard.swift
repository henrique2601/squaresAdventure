//
//  MemoryCard.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/6/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import UIKit
import CoreData

public enum controlsConfig:Int {
    case none  = 0
    case useButtons = 2
    case useLeftSliderAndScreenRight = 1
}

class MemoryCard: NSObject {
    
    static let sharedInstance = MemoryCard()
    
    private var autoSave:Bool = false
    
    var playerData:PlayerData!
    
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
        
        self.playerData.tutorial = self.newTutorial()
        
        //Towers e Floors
        let tower = self.newTowerData()
        let floor = self.newFloorData()
        tower.addFloor(value: floor)
        
        self.playerData.addTower(value: tower)
        
        //PowerUps
        self.playerData.powerUpSlots = NSOrderedSet(array: [
            self.newPowerUpSlotData(),
            self.newPowerUpSlotData(),
            self.newPowerUpSlotData()
            ])// Fixado 3 slots
        
        for i in 0 ..< PowerUps.types.count {//Teste com todos os PowerUps desbloqueados no inicio do jogo
            let powerUp = self.newPowerUpData()
            powerUp.index = NSNumber(integer: i)
            powerUp.available = NSNumber(integer: 10)
            self.playerData.addPowerUp(powerUp)
        }
        
        
        //Skins
        let skin = self.newSkinData()
        skin.locked = NSNumber(value: false)
        skin.index = NSNumber(value:Int.random(n: 10))
        skin.available = NSNumber(value: 10)
        self.playerData.addSkin(value: skin)
        
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
                
                if(self.playerData.powerUps.count < PowerUps.types.count) {
                    for i in self.playerData.powerUps.count ..< PowerUps.types.count {//Teste com todos os PowerUps desbloqueados no inicio do jogo
                        let powerUp = self.newPowerUpData()
                        powerUp.index = NSNumber(integer: i)
                        powerUp.available = NSNumber(integer: 10)
                        self.playerData.addPowerUp(powerUp)
                    }
                }
                
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
            self.managedObjectContext!.delete(item as! NSManagedObject)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.newGame()
    }
    
    func fetchRequest() -> NSArray{
        let fetchRequest = self.managedObjectModel.fetchRequestTemplate(forName: "FetchRequest")!
        let fetchRequestData: NSArray! = try? self.managedObjectContext!.fetch(fetchRequest) as NSArray
        return fetchRequestData
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "PabloHenri91.TowerUp" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "TowerUp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("TowerUp.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
        
            let modelNames = Array<String>(arrayLiteral:
            "TowerUp",
            "TowerUp 2",
            "TowerUp 3")
            
            try! ALIterativeMigrator.iterativeMigrateURL(url, ofType: NSSQLiteStoreType, to: self.managedObjectModel, orderedModelNames: modelNames)
            
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            
            try! coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            
            return coordinator
            
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
        let playerData = NSEntityDescription.insertNewObject(forEntityName: "PlayerData", into: self.managedObjectContext!) as! PlayerData
        
        playerData.name = String.randomStringWithLength(len: 8)
        playerData.coins = NSNumber(value: 0)
        playerData.gems = NSNumber(value: 0)
        playerData.configControls = NSNumber(value: controlsConfig.useLeftSliderAndScreenRight.rawValue)
        
        playerData.soundEnabled = NSNumber(value: false)
        playerData.musicEnabled = NSNumber(value: false)
        
        return playerData
    }
    
    func newTutorial() -> TutorialData {
        let tutorial = NSEntityDescription.insertNewObject(forEntityName: "TutorialData", into: self.managedObjectContext!) as! TutorialData
        tutorial.tutorial0 = NSNumber(value: false)
        
        return tutorial
    }
    
    func newTowerData() -> TowerData {
        return NSEntityDescription.insertNewObject(forEntityName: "TowerData", into: self.managedObjectContext!) as! TowerData
    }
    
    func newFloorData() -> FloorData {
        let floorData = NSEntityDescription.insertNewObject(forEntityName: "FloorData", into: self.managedObjectContext!) as! FloorData
        floorData.bonus = NSNumber(value: false)
        floorData.deaths = NSNumber(value: false)
        floorData.time = NSNumber(value: false)
        floorData.gemAvailable = NSNumber(value: true)
        return floorData
    }
    
    func newPowerUpData() -> PowerUpData {
        return NSEntityDescription.insertNewObject(forEntityName: "PowerUpData", into: self.managedObjectContext!) as! PowerUpData
    }
    
    func newSkinData() -> SkinData {
        return NSEntityDescription.insertNewObject(forEntityName: "SkinData", into: self.managedObjectContext!) as! SkinData
    }
    
    func newSkinSlotData() -> SkinSlotData {
        return NSEntityDescription.insertNewObject(forEntityName: "SkinSlotData", into: self.managedObjectContext!) as! SkinSlotData
    }
    
    func newPowerUpSlotData() -> PowerUpSlotData {
        return NSEntityDescription.insertNewObject(forEntityName: "PowerUpSlotData", into: self.managedObjectContext!) as! PowerUpSlotData
    }
    
    func newInvitedFriend(id:String) -> InvitedFriendData {
        let invitedFriendData = NSEntityDescription.insertNewObject(forEntityName: "InvitedFriendData", into: self.managedObjectContext!) as! InvitedFriendData
        invitedFriendData.id = id
        return invitedFriendData
    }
}


