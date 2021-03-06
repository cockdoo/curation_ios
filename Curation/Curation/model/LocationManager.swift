//
//  LocationManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocationManagerDelegate {
    @objc optional func locationManager(deniedAuthorization message: String)
    @objc optional func locationManager(acceptAuthorization message: String)
    @objc optional func locationManager(didUpdatingLocation message: String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let ud = UserDefaults.standard
    
    var delegate: LocationManagerDelegate!

    var lat: CLLocationDegrees = 0
    var lng: CLLocationDegrees = 0
    let locationManager: CLLocationManager
    
    //位置情報許可時の画面遷移の判定用
    var isTopView: Bool = false
    
    //
    var canInsertData: Bool = true
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        //位置情報の精度
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    //位置情報許可のリクエスト
    func requestAuthorization() {
        print("位置情報許可のリクエスト")        
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined) {
            if #available(iOS 8.0, *) {
                locationManager.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
            }
        }
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    //位置情報の取得を開始する
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var statusStr = "";
        switch (status) {
        case .notDetermined:
            statusStr = "NotDetermined"
            
        case .restricted:
            statusStr = "Restricted"
            
        case .denied:
            statusStr = "Denied"
            ud.set(false, forKey: "LOCATION_AUTHORIZED")
            ud.synchronize()
            if  isTopView == false {
                self.delegate.locationManager!(deniedAuthorization: "")
            }
            
        case .authorizedAlways:
            statusStr = "AuthorizedAlways"
            ud.set(true, forKey: "LOCATION_AUTHORIZED")
            ud.synchronize()
            if isTopView == false {
                self.delegate.locationManager!(acceptAuthorization: "")
            }
            
        case .authorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print("位置情報許可認証状態(CLAuthorizationStatus): \(statusStr)")
    }
    
    // 位置情報が取得できたとき
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            
            if let currentLocation = locations.last {
                lat = currentLocation.coordinate.latitude
                lng = currentLocation.coordinate.longitude
                //print("緯度:\(lat) 経度:\(lng)")
                
                if appDelegate.global.isNotification! {
                    appDelegate.global.isNotification = false
                    appDelegate.NManager.prepareGetArticle(lat: lat, lng: lng)
                }
                
                //データベースに保存（緯度経度取得時 複数のデータが来るので1個だけ保存されるようにする）
                if canInsertData == true {
                    //データベースに保存する
                    appDelegate.DBManager.insertLocationTable(lat, lng: lng)
                    
                    //一旦停止する
                    locationManager.stopMonitoringSignificantLocationChanges()
                    
                    canInsertData = false
                    
                    //一定時間後に再び取得する
                    Timer.scheduledTimer(timeInterval: Config().timeIntervalUpdatingLocation, target: self, selector: #selector(LocationManager.restartUpdatingLocation), userInfo: nil, repeats: false)
                    
                    //Topviewcontorollerに緯度経度を取得したことを知らせる
                    self.delegate.locationManager!(didUpdatingLocation: "")
                }
            }
        }

    }
    
    func restartUpdatingLocation() {
        canInsertData = true
        locationManager.startUpdatingLocation()
    }
    
    // 位置情報取得に失敗したとき
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("locationManager error：", terminator: "")
    }
    
    //緯度経度から地名取得
    func revGeocoding(_ lat: Double, lng: Double) {
        
        let location = CLLocation(latitude: lat, longitude: lng)
        
        var locality: String = ""
        var subLocality: String = ""
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            if error != nil {
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                //stop updating location to save battery life
//                print("Country = \(placemark.country)")
//                print("Postal Code = \(placemark.postalCode)")
//                print("Administrative Area = \(placemark.administrativeArea)")
//                print("Sub Administrative Area = \(placemark.subAdministrativeArea)")
//                print("Locality = \(placemark.locality)")
//                print("Sub Locality = \(placemark.subLocality)")
//                print("Throughfare = \(placemark.thoroughfare)")
                
                locality = placemark.locality!
                if placemark.subLocality != nil {
                    subLocality = placemark.subLocality!
                }
                
                //取得した地名をDatabaseManagerの方で保存する
                self.appDelegate.DBManager.insertCityNameTable(locality+subLocality, locality: locality, subLocality: subLocality, lat: lat, lng: lng)
                
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    
    
}
