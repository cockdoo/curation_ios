//
//  DatabaseManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import RealmSwift

//一時的に緯度経度だけ保存しておくテーブル
class Location_Table: Object {
    dynamic var createdDate: NSDate = NSDate()
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
}

//緯度経度を地名と合わせた一定期間保存しておくテーブル
class CityName_Table: Object {
    dynamic var createdDate: NSDate = NSDate()
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
    dynamic var locality: String = ""
    dynamic var subLocality: String = ""
    dynamic var cityName: String = ""
}

//各地域の滞在頻度のテーブル
class CityFrequency_Table: Object {
    dynamic var cityName: String = ""
    dynamic var locality: String = ""
    dynamic var subLocality: String = ""
    dynamic var frequency: Int = 0
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
}

protocol DatabaseManagerDelegate {
    func databaseManager(didRefreshData message: String)
}

class DatabaseManager: NSObject {
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var delegate: DatabaseManagerDelegate!
    
    override init() {
        super.init()
        showTableContent(Location_Table)
        showTableContent(CityName_Table)
        showTableContent(CityFrequency_Table)
    }
    
    //指定したテーブルの中身を表示
    func showTableContent(tableObject: Object.Type) {
        let myRealm = try! Realm()
        let tableContents = myRealm.objects(tableObject)
        print("----- ▼ テーブルの中身 -----")
        print(tableContents)
        print("----- ▲ テーブルの中身 -----")
    }
    
    //指定したテーブルを削除
    func deleteTable(tableObject: Object.Type) {
        let myRealm = try! Realm()
        let table = myRealm.objects(tableObject)
        try! myRealm.write {
            myRealm.delete(table)
        }
    }
    
    //全テーブルを削除する
    func deleteAllTable() {
        let myRealm = try! Realm()
        try! myRealm.write {
            myRealm.deleteAll()
        }
    }
    
    //取得した位置情報をDBに保存する
    func insertLocationTable(lat: Double, lng: Double) {
        let myLocations = Location_Table()
        
        myLocations.createdDate = NSDate()
        myLocations.lat = lat
        myLocations.lng = lng
        
        print("現在地データ追加　緯度：\(lat) 経度：\(lng)")
        
        let myRealm = try! Realm()
        try! myRealm.write {
            myRealm.add(myLocations)
        }
    }
    
    //一定期間より古い位置情報履歴を削除する
    func deleteOldDataFromCityNameTable() {
        print("古い履歴を削除")
        let myRealm = try! Realm()
        
        let pastDate = NSDate(timeInterval: -60*60*24*(Config().timeIntervalHoldData), sinceDate: NSDate())
        let rows = myRealm.objects(CityName_Table).filter("createdDate <= %@", pastDate)
    
        try! myRealm.write {
            myRealm.delete(rows)
        }
    }
    
    
    
    //緯度経度データに地名を付与して別テーブルに保存
    func addCityName() {
        //位置情報履歴を取得
        let myRealm = try! Realm()
        let rows = myRealm.objects(Location_Table)
        
        for row in rows {
            let lat = row.lat
            let lng = row.lng
            appDelegate.LManager.revGeocoding(lat, lng: lng)
        }
        //中身を削除
        deleteTable(Location_Table)
    }
    
    
    var timer: NSTimer!
    
    //地名を取得したとき、テーブルに保存する
    func insertCityNameTable(cityName: String, locality: String, subLocality: String, lat: Double, lng: Double) {
        let cityNames = CityName_Table()
    
        cityNames.createdDate = NSDate()
        cityNames.lat = lat
        cityNames.lng = lng
        cityNames.locality = locality
        cityNames.subLocality = subLocality
        cityNames.cityName = cityName
        
        let myRealm = try! Realm()
        try! myRealm.write {
            myRealm.add(cityNames)
        }
        
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "finishInsertCityName", userInfo: nil, repeats: false)
    }
    
    //地名取得＆保存完了
    func finishInsertCityName() {
        //古いデータを削除
        deleteOldDataFromCityNameTable()
        //頻度を更新
        refreshCityFrequency()
    }
    
    //頻度を更新する
    func refreshCityFrequency() {
        print("頻度を更新")
        
        //既存のテーブルを削除
        deleteTable(CityFrequency_Table)
        
        //位置情報履歴を取得
        let myRealm = try! Realm()
        let rows = myRealm.objects(CityName_Table)
        
        for row in rows {
            let lat = row.lat
            let lng = row.lng
            let cityName = row.cityName
            let locality = row.locality
            let subLocality = row.subLocality
            
            insertFrequencyTable(cityName, locality: locality, subLocality: subLocality, lat: lat, lng: lng)
        }
        //デリゲート
        delegate.databaseManager(didRefreshData: "更新完了")
    }
    
    //地名と頻度をテーブルに保存
    func insertFrequencyTable(cityName: String, locality: String, subLocality: String, lat: Double, lng: Double) {
        let myRealm = try! Realm()
        
        //指定した地名がある場合は頻度を取り出す
        let rows = myRealm.objects(CityFrequency_Table).filter("cityName = '\(cityName)'")
        
        var frequency = 0
        
        for row in rows {
            frequency = row.frequency
            
            //行を削除
            try! myRealm.write {
                myRealm.delete(row)
            }
        }
        
        //市町名と頻度をテーブルに保存
        let myFrequencies = CityFrequency_Table()
        myFrequencies.cityName = cityName
        myFrequencies.frequency = frequency + 1
        myFrequencies.locality = locality
        myFrequencies.subLocality = subLocality
        myFrequencies.lat = lat
        myFrequencies.lng = lng
        
        try! myRealm.write {
            myRealm.add(myFrequencies)
        }
//        print("【保存】地名：\(cityName) 頻度：\(frequency)")
    }
}




