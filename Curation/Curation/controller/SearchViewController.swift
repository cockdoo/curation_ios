//
//  SerchViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, APIManagerDelegate, LocationManagerDelegate {
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiManager = APIManager()
    
    @IBOutlet weak var serchField: UITextField!
    @IBOutlet weak var cancelSerchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        refreshEveryViewWillApper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        serchField.delegate = self
        serchField.returnKeyType = UIReturnKeyType.search
        apiManager.delegate = self
    }
    
    func refreshEveryViewWillApper() {
        //デリゲート設定
        appDelegate.LManager.delegate = self
    }
    
    @IBAction func touchedCanselSerchButton(_ sender: Any) {
        
    }
    
    
    
    
    @IBAction func touchedSerchCurrentLocationButton(_ sender: Any) {
        appDelegate.LManager.startUpdatingLocation()
    }
    
    func locationManager(didUpdatingLocation message: String) {
        print("位置情報取得完了！")
        let lat = appDelegate.LManager.lat
        let lng = appDelegate.LManager.lng
        getArticlesWithLocation(lat: lat, lng: lng)
    }
    
    //キーボードのリターンボタンが押されたとき
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFromFieldContent()
        return true
    }
    
    func searchFromFieldContent() {
        if !serchField.text!.isEmpty {
            print("検索！")
        }
    }
    
    //画面がタップされたときキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getArticlesWithLocation(lat: Double, lng: Double) {
        let locations = [
            [
                "lat": "\(lat)",
                "lng": "\(lng)"
            ]
        ]
        apiManager.getArticles(locations as [AnyObject], num: Config().numberForGetArticles)
    }
    
    //記事を取得できたときに呼ばれる
    func apiManager(didGetArticles articles: [AnyObject]) {
        print(articles)
        if articles.count > 0 {
            appDelegate.global.searchResultArticles = articles
            transitionToSearchResultView()
        }else {
            print("検索結果がなかった！！")
        }
    }
    
    func transitionToSearchResultView() {
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
