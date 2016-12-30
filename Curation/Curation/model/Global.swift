//
//  Global.swift
//  iot-project
//
//  Created by TaigaSano on 2015/11/01.
//  Copyright © 2015年 Shinnosuke Komiya. All rights reserved.
//

import UIKit
import SVProgressHUD

class Global: NSObject {
    var selectedArticle: AnyObject!
    var searchResultArticles: [AnyObject]!
    var isBackFromSearchResultView: Bool!
    var searchedPlaceName: String!
    var isNotification: Bool!
    
    override init() {
        super.init()
        selectedArticle = () as AnyObject!
        searchResultArticles = [AnyObject]()
        isBackFromSearchResultView = false
        searchedPlaceName = ""
        isNotification = false
    }
    
    var blackView: UIView?
    func showLoadingView(view: UIView, messege: String?) {
        if blackView != nil {
            return
        }
        let rect = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        blackView = UIView.init(frame: rect)
        blackView?.backgroundColor = UIColor.black
        blackView?.alpha = 0.1
        view.addSubview(blackView!)
        
        if messege != nil {
            SVProgressHUD.show(withStatus: messege)
        }else {
            SVProgressHUD.show()
        }
    }
    
    func removeLoadingView() {
        if blackView != nil {
            blackView?.removeFromSuperview()
            blackView = nil
        }
        blackView?.removeFromSuperview()
        SVProgressHUD.dismiss()
    }
}
