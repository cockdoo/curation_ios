//
//  SerchResultViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Table
    @IBOutlet weak var articlesTable: UITableView!
    let cellIdentifer = "ArticleCell"
    let cellHeight: CGFloat = 240
    
    //Article
    var articles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        //テーブルの設定
        articlesTable.delegate = self
        articlesTable.dataSource = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        articlesTable.register(nib, forCellReuseIdentifier: cellIdentifer)
        
        articles = appDelegate.global.searchResultArticles
        articlesTable.reloadData()
        print(articles)
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
    
    @IBAction func touchedBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
