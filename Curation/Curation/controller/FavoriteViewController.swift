//
//  FavoriteViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import PageMenu

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CAPSPageMenuDelegate {
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Table
    @IBOutlet weak var favoritesTable: UITableView!
    let cellIdentifer = "FavoriteCell"
    let cellHeight: CGFloat = 130
    
    //Article
    var articles = [AnyObject]()
    
    @IBOutlet weak var pageMenuCover: UIView!
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidLayoutSubviews() {
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        let list: UIViewController! = UIStoryboard(name: "FavoriteList", bundle: nil).instantiateInitialViewController()
        let map: UIViewController! = UIStoryboard(name: "FavoriteMap", bundle: nil).instantiateInitialViewController()
        list.title = "リスト"
        map.title = "マップ"
        controllerArray.append(list)
        controllerArray.append(map)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .scrollMenuBackgroundColor(Colors().lightgray),
            .menuHeight(44),
//            .menuItemSeparatorPercentageHeight(1),
            .selectedMenuItemLabelColor(Colors().mainBlack),
            .unselectedMenuItemLabelColor(Colors().subBlack),
            .selectionIndicatorColor(Colors().mainBlack),
            .bottomMenuHairlineColor(UIColor.lightGray),
            .selectionIndicatorHeight(1)
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect.init(x: 0, y: 0, width: pageMenuCover.frame.width, height: pageMenuCover.frame.height), pageMenuOptions: parameters)
        pageMenuCover.addSubview(pageMenu!.view)
        
        pageMenu?.delegate = self
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int){}
    
    func didMoveToPage(_ controller: UIViewController, index: Int){}
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        //ナビゲーションバーを隠す
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //テーブルの設定
//        favoritesTable.dataSource = self
//        favoritesTable.delegate = self
//        let nib = UINib(nibName: cellIdentifer, bundle: nil)
//        favoritesTable.register(nib, forCellReuseIdentifier: cellIdentifer)
    }
    
    func refreshEveryViewWillApper() {
        //お気に入り一覧を取得
        articles = appDelegate.DBManager.getFavoriteArticles()
//        favoritesTable.reloadData()
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
        
        let cell: FavoriteCell = favoritesTable.dequeueReusableCell(withIdentifier: cellIdentifer) as! FavoriteCell
        
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
