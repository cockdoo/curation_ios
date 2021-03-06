//
//  DisasterInformationManager.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/05/02.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol APIManagerDelegate {
    @objc optional func apiManager(didGetArticles articles: [AnyObject])
    @objc optional func apiManager(failedGetArticles messege: String?)
    @objc optional func apiManager(didGetArticleFromId article: AnyObject)
    @objc optional func apiManager(failedGetArticleFromId messege: String?)
}

class APIManager: NSObject {
    
    var delegate: APIManagerDelegate!
    
    override init() {
        super.init()
    }

    func getArticles(_ locations: [AnyObject], escapeIds: [String], min: Int, max: Int) {
        print("記事を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        var latText = ""
        var lngText = ""
        for location in locations {
            latText = latText + (location["lat"] as! String) + ","
            lngText = lngText + (location["lng"] as! String) + ","
        }
        latText = latText.substring(to: latText.index(latText.startIndex, offsetBy: latText.characters.count-1))
        lngText = lngText.substring(to: lngText.index(lngText.startIndex, offsetBy: lngText.characters.count-1))
        
        var escapeText = ""
        for escapeId in escapeIds {
            escapeText = escapeText + escapeId + ","
        }
        if escapeIds.count != 0 {
            escapeText = escapeText.substring(to: escapeText.index(escapeText.startIndex, offsetBy: escapeText.characters.count-1))
        }
        
        let url = Config().baseURL+"?lat=\(latText)&lng=\(lngText)&escapeids=\(escapeText)&min=\(min)&max=\(max)"
        print("記事を取得：\(url)")
        let encodeURL: String! = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        manager.get(encodeURL, parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responsobject: Any!) in                
                let json = (try? JSONSerialization.jsonObject(with: responsobject as! Data, options: .mutableContainers)) as? NSArray
                
                //デリゲートメソッドを呼ぶ
                if json != nil {
                    self.delegate.apiManager!(didGetArticles: json as! [AnyObject])
                }
            },
            failure: {(operation: AFHTTPRequestOperation?, error: Error!) in
                print("エラー！")
                print(operation?.responseObject ?? "")
                print(operation?.responseString ?? "")
                self.delegate.apiManager!(failedGetArticles: nil)
            }
        )
    }
    
    func getOneArticle(lat: Double, lng: Double) {
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = Config().baseURL+"?lat=\(lat)&lng=\(lng)&escapeids=&min=1&max=1"
        let encodeURL: String! = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        manager.get(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: Any!) in
                        let json = (try? JSONSerialization.jsonObject(with: responsobject as! Data, options: .mutableContainers)) as? NSArray
                        if json != nil {
                            self.delegate.apiManager!(didGetArticleFromId: json?[0] as AnyObject)
                        }
        },
                    failure: {(operation: AFHTTPRequestOperation?, error: Error!) in
                        print("エラー！")
                        print(operation?.responseObject ?? "")
                        print(operation?.responseString ?? "")
                        self.delegate.apiManager!(failedGetArticleFromId: nil)
        }
        )
    }
}
