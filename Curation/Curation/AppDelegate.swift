//
//  AppDelegate.swift
//  Curation
//
//  Created by menteadmin on 2016/09/21.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var DBManager: DatabaseManager!
    var LManager: LocationManager!
    var global: Global!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        createGlobalClass()
        
        //GoogleMaps API 認証
        GMSServices.provideAPIKey(Config().googleAPIKey);
        
        //最初の起動画面
        let firstView: UIViewController! = getFirstViewController()
        window?.rootViewController = firstView
        
        //Background fetch
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }
    
    func getFirstViewController() -> UIViewController {
        let ud = UserDefaults.standard
        
        //初期値を設定
        let defaults: [String: NSObject] = ["FIRST_LAUNCH": true as NSObject]
        ud.register(defaults: defaults)
        
        
        var firstSb: UIStoryboard!
        
        //初回起動かどうかの判定
        print("初回起動判定：\(ud.bool(forKey: "FIRST_LAUNCH"))")
        if ud.bool(forKey: "FIRST_LAUNCH") {
            firstSb = UIStoryboard(name: "Tutorial", bundle: nil)
        }
        else {
            firstSb = UIStoryboard(name: "Top", bundle: nil)
        }
        return firstSb.instantiateInitialViewController()!
    }
    
    func createGlobalClass() {
        LManager = LocationManager.init()
        DBManager = DatabaseManager.init()
        global = Global.init()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // ここに処理内容
        print("Background fetch foo")
        LManager.locationManager.startUpdatingLocation()
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

