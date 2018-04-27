//
//  AppDelegate.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/03.
//  Copyright © 2018 David Somen. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        setupDatabase()
        setupAdMob()
        
        if !databaseExists()
        {
            seedDatabase()
        }
        
        if ProcessInfo().arguments.contains("-ui_testing")
        {
            seedDatabaseForScreenshots()
            UserDefaults.standard.set(0, forKey: "Theme")
        }
        
        switch UserDefaults.standard.integer(forKey: "Theme")
        {
        case 1:
            Style.themePurple()
            break
        case 2:
            Style.themeBlue()
            break
        case 3:
            Style.themeGreen()
            break
        default:
            Style.themeOrange()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func databaseExists() -> Bool
    {
        let path = Realm.Configuration.defaultConfiguration.fileURL?.path
        return FileManager.default.fileExists(atPath: path!)
    }
    
    func setupAdMob()
    {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4731939656577901~8000110574")
    }
    
    func setupDatabase()
    {
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock:
        {
            migration, oldSchemaVersion in
                
            if oldSchemaVersion < 2
            {
                let event = migration.create("Event")
                event["title"] = NSLocalizedString("event_title_seed_4", comment: "")
                event["date"] = Date()
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    func seedDatabase()
    {
        let realm = try! Realm()
        
        try! realm.write
        {
            var event = Event()
            event.title = NSLocalizedString("event_title_seed_1", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*2)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_seed_2", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*3)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_seed_3", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*4)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_seed_4", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*5)
            realm.add(event)
        }
    }
    
    func seedDatabaseForScreenshots()
    {
        let realm = try! Realm()
        
        try! realm.write
        {
            realm.deleteAll()
            
            var event = Event()
            event.title = NSLocalizedString("event_title_screenshot_seed_1", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*3)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_screenshot_seed_2", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*12)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_screenshot_seed_3", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*61)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_screenshot_seed_4", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*258)
            realm.add(event)
            
            event = Event()
            event.title = NSLocalizedString("event_title_screenshot_seed_5", comment: "")
            event.date = Date().addingTimeInterval(60*60*24*306)
            realm.add(event)
        }
    }
}
