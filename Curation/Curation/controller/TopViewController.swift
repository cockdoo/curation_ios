//
//  TopViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/03.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, LocationManagerDelegate, DatabaseManagerDelegate, APIManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let ud = NSUserDefaults.standardUserDefaults()
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
        
        //とりあえず取得
        apiManager.getArticles(32.0, lng: 131.0, length: Config().boundForGetArticles)
    }
    
    func initialize() {
        //初回画面からの画面遷移の判定用
        appDelegate.LManager.isTopView = true
        
        //ナビゲーションバーを隠す
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //デリゲート設定
        appDelegate.LManager.delegate = self
        appDelegate.DBManager.delegate = self
        apiManager.delegate = self
        
        //テーブルの設定
        articlesTable.dataSource = self
        articlesTable.delegate = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        articlesTable.registerNib(nib, forCellReuseIdentifier: cellIdentifer)
        
        //データベースを更新する
        appDelegate.DBManager.addCityName()
        
        //現在地を取得
        appDelegate.LManager.locationManager.startUpdatingLocation()
        
        checkLocationAuthorize()
    }
    
    //位置情報が許可されてない場合アラートを表示する
    func checkLocationAuthorize() {
        if ud.boolForKey("LOCATION_AUTHORIZED") == false {
            let alert: UIAlertController = UIAlertController(title: "位置情報サービスが無効です", message: "設定 > プライバシー > 位置情報サービス から\"My防災ノート\"による位置情報の利用を許可してください", preferredStyle:  UIAlertControllerStyle.Alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func databaseManager(didRefreshData message: String) {
        print("DB更新完了")
    }
    
    func locationManager(didUpdatingLocation message: String) {
        print("位置情報取得できた")
    }
    
    func apiManager(didGetArticles articles: [AnyObject]) {
        print(articles)
        for article in articles {
            self.articles.append(article)
        }
//        self.articles = articles
        articlesTable.reloadData()
    }

    
    
    //MARK: - TABLE
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    //Cellが選択された際に呼び出される.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Num: \(indexPath.row)")
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let article = articles[indexPath.row] as AnyObject
        let title: String = article["title"] as! String
        let imageUrl: String = article["imageUrl"] as! String
        
        let cell: ArticleCell = articlesTable.dequeueReusableCellWithIdentifier(cellIdentifer) as! ArticleCell
        
        cell.setUpCell(title, imageUrl: imageUrl)
        
        return cell
    }
}
