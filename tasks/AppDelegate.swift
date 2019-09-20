//  AppDelegate.swift
//  TasksMe
//  1920x886
//  Created by Valeriy PETRENKO on 10/10/2017.
//  Copyright © 2017 Slavamax BVBA. All rights reserved.
//  App Store Promotions: SKPaymentTransactionObserver
// New com.slavamax.lifebooster001

import UIKit
//import StoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
   // let paymentTransactionObserver = PaymentTransactionObserver()
    
    override init()
    {
        let initialDefaults: NSDictionary =
            
            ["ListURLText": "ftp://ftp1.freebsd.org/pub/FreeBSD/",
             "KupitIliVosstanovit": "NO",
             "version": "1.1.1",
             "countdown": 0
        ]
        UserDefaults.standard.register(defaults: initialDefaults as! [String : Any])
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    //    SKPaymentQueue.default().add(paymentTransactionObserver)
        self.createEditableCopyOfDatabaseIfNeeded()
        
        
        
        
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
       // SKPaymentQueue.default().remove(paymentTransactionObserver)
    }
    
    
    //_________ start createEditableCopyOfDatabaseIfNeeded _____________________________________
    func createEditableCopyOfDatabaseIfNeeded() {
        // 1) Copy bookmarks
        let sourcePath = Bundle.main.path(forResource: "tasks", ofType: "plist")
        let destinationFile = "tasks.plist"
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destPath = (dir as NSString).appendingPathComponent(destinationFile)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: destPath) {
            do {
                try fileManager.copyItem(atPath: sourcePath!, toPath: destPath)
            } catch let error as NSError {
                print("Unable to copy task.plist file. ERROR: \(error.localizedDescription)")
            }
        } else {
            //print("tasks.plist fileExists")
        }
        
    }
    //_____finish createEditableCopyOfDatabaseIfNeeded _____________________________________
    
} // THE END
