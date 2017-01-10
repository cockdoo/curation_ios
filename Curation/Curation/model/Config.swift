//
//  Config.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit

open class Config {
    //Google API key
    let googleAPIKey: String = "AIzaSyCxr-PIiE4MHC9ecytrq2hPbYVodrVU25k"
    
    //位置情報履歴を保存する期間（日）
    let timeIntervalHoldData: Double = 30
    
    //アプリ起動時に位置情報を取得するインターバル（秒）
    let timeIntervalUpdatingLocation: TimeInterval = 60
    
    //取得できれば満足する記事の個数
    let minGetArticlesNum = 30
    let maxGetArticlesNum = 120
    
    //仮想ペルソナの生活圏データを表示するか否か
    let isVirtualPersona: Bool = false
    
    //次の記事の通知を出す最低時間
    let hourPushInterval: TimeInterval = 8
    
    let isTrackingAnalytics: Bool = true
    
    let anketURL: String = "https://docs.google.com/forms/d/1DSU7cL-tYr4ASLA40VJHGkdAoYbRA0v6sNqw8yHNgRY"
    
    let baseURL = "http://taigasano.com/curation/api/"
    
    //仮想ペルソナの生活圏
    let virtualLivingArea = [
        [
            "cityName": "鎌倉市大船", //自宅
            "subLocality": "大船",
            "lat": 35.317931,
            "lng": 139.499904
        ],
        [
            "cityName": "鎌倉市津西", //勤務地
            "subLocality": "津西",
            "lat": 35.353113,
            "lng": 139.538310
        ],
        [
            "cityName": "鎌倉市鎌倉山", //よく行くカフェ
            "subLocality": "鎌倉山",
            "lat": 35.318271,
            "lng": 139.514939
        ],
        [
            "cityName": "鎌倉市小町", //スポーツクラブ
            "subLocality": "小町",
            "lat": 35.318734,
            "lng": 139.552864
        ]
    ]
}



