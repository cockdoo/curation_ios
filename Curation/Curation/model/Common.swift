//
//  Common.swift
//  Curation
//
//  Created by menteadmin on 2016/10/29.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

open class Common: NSObject {
    func checkLocationAuthorize(target: UIViewController) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: "LOCATION_AUTHORIZED") == false {
            let alert: UIAlertController = UIAlertController(title: "位置情報サービスが無効です", message: "設定 > プライバシー > 位置情報サービス から\"Ékocca\"による位置情報の利用を許可してください", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
            })
            alert.addAction(defaultAction)
            target.present(alert, animated: true, completion: nil)
        }
    }
    
    func isLocationAuthorize() -> Bool {
        let ud = UserDefaults.standard
        if ud.bool(forKey: "LOCATION_AUTHORIZED") == false {
            return false
        }else {
            return true
        }
    }
    
    func showAlert(title: String?, message: String?, target: UIViewController, popView: Bool) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            if popView {
                target.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(defaultAction)
        target.present(alert, animated: true, completion: nil)
    }
        
    func isInteger(n: Double) -> Bool {
        if round(n) == n {
            return true
        }else {
            return false
        }
    }
    
    func trackingScreen(vc: UIViewController) {
        let className = NSStringFromClass(type(of: vc)).components(separatedBy: ".").last!
        let tracker = GAI.sharedInstance().defaultTracker
        let build = GAIDictionaryBuilder.createScreenView().set(className, forKey: kGAIScreenName).build() as Dictionary
        tracker?.send(build as [NSObject : AnyObject])
    }
    
    func trackingEvent(category: String?, action: String?, label: String?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let build = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil).build() as Dictionary
        tracker?.send(build as [NSObject : AnyObject])
    }
}
