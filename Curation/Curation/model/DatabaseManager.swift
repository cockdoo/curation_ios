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
    dynamic var createdDate: Date = Date()
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
}

//緯度経度を地名と合わせた一定期間保存しておくテーブル
class CityName_Table: Object {
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
    dynamic var locality: String = ""
    dynamic var subLocality: String = ""
    dynamic var cityName: String = ""
}

//移動ログ用に永久的に保存しておくテーブル
class PermanentLocation_Table: Object {
    dynamic var createdDate: Date = Date()
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0
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

//お気に入りの記事のテーブル
class Favorite_Table: Object {
    dynamic var createdDate: Date = Date()
    dynamic var id: String = ""
    dynamic var url: String = ""
    dynamic var lat: String = ""
    dynamic var lng: String = ""
    dynamic var date: String = ""
    dynamic var media: String = ""
    dynamic var tag: String = ""
    dynamic var title: String = ""
    dynamic var imageUrl: String = ""
}

protocol DatabaseManagerDelegate {
    func databaseManager(didRefreshData message: String)
    func databaseManager(startRefreshData message: String)
}

class DatabaseManager: NSObject {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: DatabaseManagerDelegate!
    
    override init() {
        super.init()
//        showTableContent(Location_Table.self)
//        showTableContent(CityName_Table.self)
        showTableContent(CityFrequency_Table.self)
        showTableContent(Favorite_Table.self)
    }
    
    //指定したテーブルの中身を表示
    func showTableContent(_ tableObject: Object.Type) {
        let myRealm = try! Realm()
        let tableContents = myRealm.objects(tableObject)
        print("----- ▼ テーブルの中身 -----")
        print(tableContents)
        print("----- ▲ テーブルの中身 -----")
    }
    
    //指定したテーブルを削除
    func deleteTable(_ tableObject: Object.Type) {
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
    func insertLocationTable(_ lat: Double, lng: Double) {
        print("現在の位置情報を保存：\(lat), \(lng)")
        let myLocations = Location_Table()
        myLocations.createdDate = Date(timeIntervalSinceNow: TimeInterval(NSTimeZone.system.secondsFromGMT()))
        myLocations.lat = lat
        myLocations.lng = lng
        
        let perLocations = PermanentLocation_Table()
        perLocations.createdDate = Date(timeIntervalSinceNow: TimeInterval(NSTimeZone.system.secondsFromGMT()))
        perLocations.lat = lat
        perLocations.lng = lng
        
        let myRealm = try! Realm()
        try! myRealm.write {
            myRealm.add(myLocations)
            myRealm.add(perLocations)
        }
    }
    
    //一定期間より古い位置情報履歴を削除する
    func deleteOldDataFromCityNameTable() {
        print("CityNameTableから古い履歴を削除")
        let myRealm = try! Realm()
        
        let pastDate = Date(timeInterval: -60*60*24*(Config().timeIntervalHoldData), since: Date(timeIntervalSinceNow: TimeInterval(NSTimeZone.system.secondsFromGMT())))
        let rows = myRealm.objects(CityName_Table.self).filter("createdDate <= %@", pastDate)
    
        try! myRealm.write {
            myRealm.delete(rows)
        }
    }
    
    //緯度経度データに地名を付与して別テーブルに保存
    func addLocationDataToCityNameTable() {
        //位置情報履歴を取得
        let myRealm = try! Realm()
        let rows = myRealm.objects(Location_Table.self)
        
        for row in rows {
            let lat = row.lat
            let lng = row.lng
            appDelegate.LManager.revGeocoding(lat, lng: lng)
        }
        if rows.count > 0 {
            delegate.databaseManager(startRefreshData: "")
        }
        //中身を削除
        deleteTable(Location_Table.self)
    }
    
    var timer: Timer!
    //地名を取得したとき、テーブルに保存する
    func insertCityNameTable(_ cityName: String, locality: String, subLocality: String, lat: Double, lng: Double) {
        print("地名を保存：\(cityName)")
        let cityNames = CityName_Table()
    
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DatabaseManager.finishInsertCityName), userInfo: nil, repeats: false)
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
        deleteTable(CityFrequency_Table.self)
        
        //位置情報履歴を取得
        let myRealm = try! Realm()
        let rows = myRealm.objects(CityName_Table.self)
        
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
    func insertFrequencyTable(_ cityName: String, locality: String, subLocality: String, lat: Double, lng: Double) {
        let myRealm = try! Realm()
        
        //指定した地名がある場合は頻度を取り出す
        let rows = myRealm.objects(CityFrequency_Table.self).filter("cityName = '\(cityName)'")
        
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
    }
    
    //上位の地域の情報を取得
    func getLivingAreaList() -> [AnyObject] {
        
        let myRealm = try! Realm()
        let tableContents = myRealm.objects(CityFrequency_Table.self).sorted(byProperty: "frequency", ascending: false)
        
        let livingAreas = NSMutableArray()
        
        for row in tableContents {
            let livingArea = [
                "cityName": row.cityName,
                "subLocality": row.subLocality,
                "lat": row.lat,
                "lng": row.lng,
                ] as [String : Any]
            livingAreas.add(livingArea)
        }
        if Config().isVirtualPersona == true {
            //仮想ペルソナの生活圏をセット
            return Config().virtualLivingArea as [AnyObject]
        }
        else {
            return (livingAreas as [AnyObject])
        }
    }
    
    //MARK: - Favorite
    
    //お気に入りに追加
    func insertFavoriteTable(_ obj: AnyObject) {
        let myRealm = try! Realm()
        
        //市町名と頻度をテーブルに保存
        let myFavorite = Favorite_Table()
        myFavorite.createdDate = Date(timeIntervalSinceNow: TimeInterval(NSTimeZone.system.secondsFromGMT()))
        myFavorite.id = obj["id"] as! String
        myFavorite.lat = obj["lat"] as! String
        myFavorite.lng = obj["lng"] as! String
        myFavorite.url = obj["url"] as! String
        myFavorite.title = obj["title"] as! String
        myFavorite.imageUrl = obj["imageUrl"] as! String
        myFavorite.tag = obj["tag"] as! String
        myFavorite.date = obj["date"] as! String
        myFavorite.media = obj["media"] as! String
        
        try! myRealm.write {
            myRealm.add(myFavorite)
        }
    }
    
    //お気に入りから削除
    func removeFromFavoriteTable(_ id: String) {
        let myRealm = try! Realm()
        let rows = myRealm.objects(Favorite_Table.self).filter("id = %@", id)
        try! myRealm.write {
            myRealm.delete(rows)
        }
    }
    
    //お気に入り一覧を取得
    func getFavoriteArticles() -> [AnyObject] {
        let myRealm = try! Realm()
        let rows = myRealm.objects(Favorite_Table.self).sorted(byProperty: "createdDate", ascending: false)
        
        var articles = [AnyObject]()
        for row in rows {
            let article = [
                "createdDate": row.createdDate,
                "id": row.id,
                "lat": row.lat,
                "lng": row.lng,
                "url": row.url,
                "title": row.title,
                "imageUrl": row.imageUrl,
                "tag": row.tag,
                "date": row.date,
                "media": row.media
            ] as AnyObject
            articles.append(article)
        }
        return articles
    }
    
    //指定したIDのお気に入りを取得
    func getFavoriteArticleFromId(_ id: String) -> [String: Any] {
        let myRealm = try! Realm()
        let rows = myRealm.objects(Favorite_Table.self).filter("id = %@", id)
        var article = [String: Any]()
        for row in rows {
            article = [
                "createdDate": row.createdDate,
                "id": row.id,
                "lat": row.lat,
                "lng": row.lng,
                "url": row.url,
                "title": row.title,
                "imageUrl": row.imageUrl,
                "tag": row.tag,
                "date": row.date,
                "media": row.media
                ]
        }
        return article
    }
    
    func getLocationLog(from: Date, to: Date) -> [AnyObject] {
        let myRealm = try! Realm()
        let tableContents = myRealm.objects(PermanentLocation_Table.self).filter("createdDate => %@ AND createdDate <= %@", from, to)
        
        var locations = [AnyObject]()
        
        for row in tableContents {
            let location = [
                "createdDate": row.createdDate,
                "lat": row.lat,
                "lng": row.lng
            ] as [String : Any]
            locations.append(location as AnyObject)
        }
        return locations
    }
}




