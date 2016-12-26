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
        let ud = UserDefaults.standard
        let pushedTime = ud.object(forKey: "PUSHED_TIME") as! Date
        let pushedInterval = Date().timeIntervalSince(pushedTime)

//        if pushedInterval < Config().hourPushInterval * 60 * 60 {
//            return
//        }
      
        ud.set(Date(), forKey: "PUSHED_TIME")
        ud.synchronize()
        apiManager.getOneArticle(lat: lat, lng: lng)
    }
    
    func apiManager(didGetArticleFromId article: AnyObject) {
        let id = article["id"] as! String
        if appDelegate.DBManager.isAlreadyPushed(id) {
            return
        }
        appDelegate.DBManager.insertPushedTable(id)
        
        let application = UIApplication.shared
        let notification = UILocalNotification()
        notification.alertAction = "アプリを開く"
        notification.alertBody = article["title"] as? String
        notification.fireDate = Date(timeIntervalSinceNow: 3)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = article as? [AnyHashable : Any]
        application.scheduleLocalNotification(notification)
    }
    
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
