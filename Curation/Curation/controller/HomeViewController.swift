//
//  TopViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/03.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class HomeViewController: UIViewController, LocationManagerDelegate, DatabaseManagerDelegate, APIManagerDelegate, NotificationManagerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITabBarControllerDelegate {
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let ud = UserDefaults.standard
    let apiManager = APIManager()
    var sw: CGFloat!
    var sh: CGFloat!
    
    //Collection
    @IBOutlet weak var articleCollectionView: UICollectionView!
    let cellIdentifer = "ArticleCollectionCell"
    let firstCellIdentifer = "FirstArticleCollectionCell"
    
    //Article
    var articles = [AnyObject]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sidemenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        //現在地を取得
        appDelegate.LManager.locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        sw = self.view.bounds.width
        sh = self.view.bounds.height
        
        apiManager.delegate = self
        appDelegate.LManager.delegate = self
        appDelegate.DBManager.delegate = self
        appDelegate.NManager.delegate = self
        
        //初回画面からの画面遷移の判定用
        appDelegate.LManager.isTopView = true
        
        //ナビゲーションバーを隠す
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        //CollectionCellの設定
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        let nib2 = UINib(nibName: firstCellIdentifer, bundle: nil)
        articleCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifer)
        articleCollectionView.register(nib2, forCellWithReuseIdentifier: firstCellIdentifer)
        
        //位置情報履歴のデータベースを更新する
        appDelegate.DBManager.addLocationDataToCityNameTable()
        
        Common().checkLocationAuthorize(target: self)
    }
        
    func refreshEveryViewWillApper() {
        //デリゲート設定
        appDelegate.LManager.delegate = self
        appDelegate.DBManager.delegate = self
        appDelegate.NManager.delegate = self
        self.tabBarController?.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.navigationController {
            articleCollectionView.setContentOffset(CGPoint(x: 0, y: -articleCollectionView.contentInset.top), animated: true)
        }
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
    
    func databaseManager(startRefreshData message: String) {
        print("DB更新開始")
        appDelegate.global.showLoadingView(view: self.view, messege: nil)
    }
        
    func databaseManager(didRefreshData message: String) {
        print("DB更新完了")
        getArticles()
    }
    
    func locationManager(didUpdatingLocation message: String) {
        print("位置情報取得できた @HomeViewController")
        let livingAreaList = appDelegate.DBManager.getLivingAreaList()
        if livingAreaList.count == 0 {
            appDelegate.DBManager.addLocationDataToCityNameTable()
        }
    }
    
    //記事を取得できたときに呼ばれる
    func apiManager(didGetArticles articles: [AnyObject]) {
        print("記事取得完了")
        appDelegate.global.removeLoadingView()
        self.articles = articles
        if self.articles.count % 2 == 0 {
            self.articles.removeLast()
        }
        articleCollectionView.reloadData()
    }
    

    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        if indexPath.section == 0 {
            size = CGSize.init(width: sw, height: (sw-20)/1.618)
        }else {
            if sw == 320 {
                size = CGSize.init(width: (sw-1)/2, height: (sw-1)/2*1.25)
            }else if sw == 375 {
                size = CGSize.init(width: (sw-1)/2, height: (sw-1)/2*1.18)
            }else {
                size = CGSize.init(width: (sw-1)/2, height: (sw-1)/2*1.12)
            }
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var inset: UIEdgeInsets!
        switch section {
        case 0:
            inset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            break
        case 1:
            inset = UIEdgeInsets.init(top: 1, left: 0, bottom: 0, right: 0)
            break
        default:
            inset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            break
        }
        return inset
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if articles.count == 0 {
            return 0
        }
        switch section {
        case 0:
            return 1
        case 1:
            return articles.count - 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var index: Int!
        if indexPath.section == 0 {
            index = 0
        }else {
            index = indexPath.row + 1
        }
        let article = articles[index] as AnyObject
        let title: String = article["title"] as! String
        let imageUrl: String = article["imageUrl"] as! String
        let imageName: String = article["media"] as! String
        let cityName: String = (article["locality"] as! String) + (article["sublocality"] as! String)
        
        if indexPath.section == 0 {
            let cell: FirstArticleCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: firstCellIdentifer, for: indexPath) as! FirstArticleCollectionCell
            cell.setUpCell(title, imageUrl: imageUrl, mediaName: imageName, cityName: cityName, index: index)
            return cell
        }else {
            let cell: ArticleCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! ArticleCollectionCell
            cell.setUpCell(title, imageUrl: imageUrl, mediaName: imageName, cityName: cityName, index: index)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index: Int!
        if indexPath.section == 0 {
            index = 0
        }else {
            index = indexPath.row + 1
        }
        print("Index: \(index)")
        appDelegate.global.selectedArticle = articles[index]
        transitionToArticleView()
    }
    
    func notificationManager(deniedAuthorization message: String) {
        transitionToArticleView()
    }
    
    func transitionToArticleView() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        nextView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func toucedSidemenuButton(_ sender: Any) {
        self.slideMenuController()?.openLeft()
//        let storyboard = UIStoryboard(name: "Sidemenu", bundle: nil)
//        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
//        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}
