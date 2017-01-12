//
//  NotificationManager.swift
//  Curation
//
//  Created by menteadmin on 2016/12/25.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

@objc protocol NotificationManagerDelegate {
    func notificationManager(deniedAuthorization message: String)
}

class NotificationManager: NSObject, APIManagerDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiManager = APIManager()
    var delegate: NotificationManagerDelegate!
    
    override init() {
        super.init()
        initialize()
    }
    
    func initialize() {
        apiManager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationManager.didGetNotification), name: NSNotification.Name(rawValue: "article_push"), object: nil)
    }
    
    func registerUserNotificationSettings() {
        let application = UIApplication.shared
        if #available(iOS 8.0, *) {
            let notiSettings = UIUserNotificationSettings.init(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(notiSettings)
            application.registerForRemoteNotifications()
        } else{
            application.registerForRemoteNotifications()
        }
    }
    
    func prepareGetArticle(lat: Double, lng: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        let currentDate = Date()
        let currentHour = formatter.string(from: currentDate)
        
        if Int(currentHour)! > 21 || Int(currentHour)! < 8 {
            return
        }
        
        let ud = UserDefaults.standard
        let pushedTime = ud.object(forKey: "PUSHED_TIME") as! Date
        let pushedInterval = Date().timeIntervalSince(pushedTime)
        
        if pushedInterval < Config().hourPushInterval * 60 * 60 {
            return
        }
        apiManager.getOneArticle(lat: lat, lng: lng)
    }
    
    func apiManager(didGetArticleFromId article: AnyObject) {
        let id = article["id"] as! String
        if appDelegate.DBManager.isAlreadyPushed(id) { 
            return
        }
        appDelegate.DBManager.insertPushedTable(id)
        
        let ud = UserDefaults.standard
        ud.set(Date(), forKey: "PUSHED_TIME")
        ud.synchronize()
        
        let application = UIApplication.shared
        let notification = UILocalNotification()
        notification.alertAction = "アプリを開く"
        notification.alertBody = article["title"] as? String
        notification.fireDate = Date(timeIntervalSinceNow: 3)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = article as? [AnyHashable : Any]
        application.scheduleLocalNotification(notification)
    }
    
    func apiManager(failedGetArticleFromId messege: String?) {}
    
//    func alreadyPushedArticle(id: String) -> Bool {
//        
//    }
//    
//    func spanMinuteFromAfterPushed() -> Int {
//        
//    }
    
    func didGetNotification() {
        delegate.notificationManager(deniedAuthorization: "")
    }
}
