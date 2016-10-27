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
}

class APIManager: NSObject {
    
    var delegate: APIManagerDelegate!
    
    override init() {
        super.init()
    }

    func getArticles(_ lat: Double, lng: Double, num: Int) {
        print("記事を取得")
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/curation/api/?lat=\(lat)&lng=\(lng)&num=\(num)"
        print("url: \(url)")
        let encodeURL: String! = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        manager.get(encodeURL, parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, responsobject: Any!) in
                print("取得に成功")
                
                let json = (try? JSONSerialization.jsonObject(with: responsobject as! Data, options: .mutableContainers)) as? NSArray
                
                print("JSON")
                print(json)
                
                //デリゲートメソッドを呼ぶ
                if json != nil {
                    self.delegate.apiManager!(didGetArticles: json as! [AnyObject])
                }
            },
            failure: {(operation: AFHTTPRequestOperation?, error: Error!) in
                print("エラー！")
                print(operation?.responseObject)
                print(operation?.responseString)
            }
        )
    }
    
    //同じURLのものがある場合は削除する
    func getUniqueArticles() {
        
    }
    
    
    //指定したIDの避難施設情報を取得
    func getFacilityDataFromId(_ id: Int) {
        print("ID:\(id) の避難施設情報を取得")
        
        //リクエスト
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        let serializer:AFHTTPResponseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer = serializer
        
        let url = "http://taigasano.com/mybousainote/api/facilities/get-from-id.php?id=\(id)"
        
        print(url)
        let encodeURL: String! = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        manager.get(encodeURL, parameters: nil,
                    success: {(operation: AFHTTPRequestOperation!, responsobject: Any!) in
                        print("取得に成功")
                        
                        let json = (try? JSONSerialization.jsonObject(with: responsobject as! Data, options: .mutableContainers))
                        
                        //デリゲートメソッドを呼ぶ
                        if json != nil {
                            
                        }
            },
                    failure: {(operation: AFHTTPRequestOperation?, error: Error!) in
                        print("エラー！")
                        print(operation?.responseObject)
                        print(operation?.responseString)
            }
        )
    }
}
