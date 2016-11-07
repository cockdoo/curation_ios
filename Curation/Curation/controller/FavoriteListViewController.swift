//
//  FavoriteListViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/11/07.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

protocol FavoriteListViewDelegate {
    func favoriteListView(touchedArticleButton message: String)
}

class FavoriteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: FavoriteListViewDelegate!
    
    @IBOutlet weak var favoritesTable: UITableView!
    let cellIdentifer = "FavoriteCell"
    let cellHeight: CGFloat = 95
    
    //Article
    var articles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        favoritesTable.dataSource = self
        favoritesTable.delegate = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        favoritesTable.register(nib, forCellReuseIdentifier: cellIdentifer)
    }
    
    func refreshEveryViewWillApper() {
        //お気に入り一覧を取得
        articles = appDelegate.DBManager.getFavoriteArticles()
        favoritesTable.reloadData()
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
        let media: String = article["media"] as! String
        
        let cell: FavoriteCell = favoritesTable.dequeueReusableCell(withIdentifier: cellIdentifer) as! FavoriteCell
        
        cell.setUpCell(title, imageUrl: imageUrl, media: media, index: (indexPath as NSIndexPath).row)
        return cell
    }
    
    //Cellが選択された際に呼び出される.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: \((indexPath as NSIndexPath).row)")
        appDelegate.global.selectedArticle = articles[(indexPath as NSIndexPath).row]
        delegate.favoriteListView(touchedArticleButton: "")
    }
}
