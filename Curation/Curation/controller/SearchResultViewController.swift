//
//  SerchResultViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var sw: CGFloat!
    var sh: CGFloat!
    
    
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    let cellIdentifer = "ArticleCollectionCell"
    let cellIdentifer_R = "ArticleCollectionCell_R"
    @IBOutlet weak var titleLabel: UILabel!
    
    //Article
    var articles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Common().trackingScreen(vc: self)
        appDelegate.global.removeLoadingView()
    }
    
    func initialize() {
        sw = self.view.bounds.width
        sh = self.view.bounds.height
        
        //テーブルの設定
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        let nib2 = UINib(nibName: cellIdentifer_R, bundle: nil)
        articleCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifer)
        articleCollectionView.register(nib2, forCellWithReuseIdentifier: cellIdentifer_R)
        
        articles = appDelegate.global.searchResultArticles
        articleCollectionView.reloadData()
//        print(articles)
        
        titleLabel.text = appDelegate.global.searchedPlaceName
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
    }
    
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        if sw == 320 {
            size = CGSize.init(width: sw/2, height: sw/2*1.25)
        }else if sw == 375 {
            size = CGSize.init(width: sw/2, height: sw/2*1.18)
        }else {
            size = CGSize.init(width: sw/2, height: sw/2*1.12)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let article = articles[index] as AnyObject
        let title: String = article["title"] as! String
        let imageUrl: String = article["imageUrl"] as! String
        let imageName: String = article["media"] as! String
        let cityName: String = (article["locality"] as! String) + (article["sublocality"] as! String)
        
        if index % 2 != 0 {
            let cell: ArticleCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! ArticleCollectionCell
            cell.setUpCell(title, imageUrl: imageUrl, mediaName: imageName, cityName: cityName, index: index)
            return cell
        }else {
            let cell: ArticleCollectionCell_R = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer_R, for: indexPath) as! ArticleCollectionCell_R
            cell.setUpCell(title, imageUrl: imageUrl, mediaName: imageName, cityName: cityName, index: index)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Common().trackingEvent(category: "SearchResult", action: "SelectedArticle", label: "\(indexPath.row)")
        appDelegate.global.selectedArticle = articles[indexPath.row]
        transitionToArticleView()
    }
    
    func transitionToArticleView() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        nextView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func touchedBackButton(_ sender: Any) {
        appDelegate.global.isBackFromSearchResultView = true
        _ = navigationController?.popViewController(animated: true)
    }
}
