//
//  Config.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit

public class Config {
    //Google API key
    let googleAPIKey: String = "AIzaSyCxr-PIiE4MHC9ecytrq2hPbYVodrVU25k"
    
    //位置情報履歴を保存する期間（日）
    let timeIntervalHoldData: Double = 30
    
    //アプリ起動時に位置情報を取得するインターバル（秒）
    let timeIntervalUpdatingLocation: NSTimeInterval = 60
}



