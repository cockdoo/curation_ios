//
//  TopViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/03.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, LocationManagerDelegate, DatabaseManagerDelegate, APIManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let ud = UserDefaults.standard
    let apiManager = APIManager()
    
    //Table
    @IBOutlet weak var articlesTable: UITableView!
    let cellIdentifer = "ArticleCell"
    let cellHeight: CGFloat = 240
    
    //Article
    var articles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        refreshEveryViewWillApper()
        
        //現在地を取得
        appDelegate.LManager.locationManager.startUpdatingLocation()
        
        getArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        apiManager.delegate = self
        
        //初回画面からの画面遷移の判定用
        appDelegate.LManager.isTopView = true
        
        //ナビゲーションバーを隠す
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //テーブルの設定
        articlesTable.dataSource = self
        articlesTable.delegate = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        articlesTable.register(nib, forCellReuseIdentifier: cellIdentifer)
        
        //データベースを更新する
        appDelegate.DBManager.addCityName()
        
        Common().checkLocationAuthorize(target: self)
    }
    
    func refreshEveryViewWillApper() {
        //デリゲート設定
        appDelegate.LManager.delegate = self
        appDelegate.DBManager.delegate = self
    }
    
    func getArticles() {
        let livingAreaList = appDelegate.DBManager.getLivingAreaList()
        var locations = [AnyObject]()
        for area in livingAreaList {
            let location = [
                "lat": "\(area["lat"] as! Double)",
                "lng": "\(area["lng"] as! Double)"
            ]
            locations.append(location as AnyObject)
        }
        if locations.count > 0 {
            apiManager.getArticles(locations, num: Config().numberForGetArticles)
        }
    }
        
    func databaseManager(didRefreshData message: String) {
        print("DB更新完了")
    }
    
    func locationManager(didUpdatingLocation message: String) {
        print("位置情報取得できた")
//        apiManager.getArticles(appDelegate.LManager.lat, lng: appDelegate.LManager.lng, num: Config().numberForGetArticles)
    }
    
    //記事を取得できたときに呼ばれる
    func apiManager(didGetArticles articles: [AnyObject]) {
//        print(articles)
        self.articles = articles
        articlesTable.reloadData()
    }

    
    //MARK: - TABLE
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[(indexPath as NSIndexPath).row] as AnyObject
        let title: String = article["title"] as! String
        let imageUrl: String = article["imageUrl"] as! String
        
        let cell: ArticleCell = articlesTable.dequeueReusableCell(withIdentifier: cellIdentifer) as! ArticleCell
        
        cell.setUpCell(title, imageUrl: imageUrl, index: (indexPath as NSIndexPath).row)
        return cell
    }
    
    //Cellが選択された際に呼び出される.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: \((indexPath as NSIndexPath).row)")
        
        appDelegate.global.selectedArticle = articles[(indexPath as NSIndexPath).row]
        transitionToArticleView()
    }
    
    func transitionToArticleView() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
