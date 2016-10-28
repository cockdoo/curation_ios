//
//  Global.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit
//import SVProgressHUD

class Global: NSObject {
    var selectedArticle: AnyObject!
    var searchResultArticles: [AnyObject]!
    
    override init() {
        super.init()
        selectedArticle = () as AnyObject!
        searchResultArticles = [AnyObject]()
    }
}
