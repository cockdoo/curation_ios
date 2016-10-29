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
            let alert: UIAlertController = UIAlertController(title: "位置情報サービスが無効です", message: "設定 > プライバシー > 位置情報サービス から\"My防災ノート\"による位置情報の利用を許可してください", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            target.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String?, message: String?, target: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        alert.addAction(defaultAction)
        target.present(alert, animated: true, completion: nil)
    }
}
