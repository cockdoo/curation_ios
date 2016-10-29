//
//  SerchViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, APIManagerDelegate, LocationManagerDelegate, UISearchBarDelegate {
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiManager = APIManager()
    
    @IBOutlet weak var searchField: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        refreshEveryViewWillApper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        searchField.delegate = self
        searchField.layer.borderWidth = 0
        searchField.layer.borderColor = UIColor.clear.cgColor
        apiManager.delegate = self
    }
    
    func refreshEveryViewWillApper() {
        appDelegate.LManager.delegate = self
        searchField.becomeFirstResponder()
        searchField.showsCancelButton = true
    }
    
    //MARK: Search Bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEdit()
        searchField.text = ""
    }
    
    //キーボードのリターンボタンが押されたとき
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEdit()
        searchFromFieldContent()
    }
    
    func searchFromFieldContent() {
        if !searchField.text!.isEmpty {
            print("検索！")
        }
    }
    
    //画面がタップされたときキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEdit()
    }
    
    func endEdit() {
        searchField.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    //MARK: 現在地から検索
    
    @IBAction func touchedSerchCurrentLocationButton(_ sender: Any) {
        endEdit()
        appDelegate.LManager.startUpdatingLocation()
        Common().checkLocationAuthorize(controller: self)
    }
    
    func locationManager(didUpdatingLocation message: String) {
        print("位置情報取得完了！")
        let lat = appDelegate.LManager.lat
        let lng = appDelegate.LManager.lng
        getArticlesWithLocation(lat: lat, lng: lng)
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
