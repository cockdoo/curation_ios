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
    
    //Table
    @IBOutlet weak var articleCollectionView: UICollectionView!
    let cellIdentifer = "ArticleCollectionCell"
    
    //Article
    var articles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        sw = self.view.bounds.width
        sh = self.view.bounds.height
        
        //テーブルの設定
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        articleCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifer)
        
        articles = appDelegate.global.searchResultArticles
        articleCollectionView.reloadData()
//        print(articles)
    }
    
    //MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        if sw == 320 {
            size = CGSize.init(width: (sw-1)/2, height: (sw-1)/2*1.25)
        }else if sw == 375 {
            size = CGSize.init(width: (sw-1)/2, height: (sw-1)/2*1.18)
        }else {
            size = CGSize.init(width: (sw-1)/2, height: (sw-1)/2*1.12)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row + 1
        
        let article = articles[index] as AnyObject
        let title: String = article["title"] as! String
        let imageUrl: String = article["imageUrl"] as! String
        let imageName: String = article["media"] as! String
        let cityName: String = (article["locality"] as! String) + (article["sublocality"] as! String)
        
        let cell: ArticleCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! ArticleCollectionCell
        cell.setUpCell(title, imageUrl: imageUrl, mediaName: imageName, cityName: cityName, index: index)
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appDelegate.global.selectedArticle = articles[indexPath.row]
        transitionToArticleView()
    }
    
    func transitionToArticleView() {
        let storyboard = UIStoryboard(name: "Article", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func touchedBackButton(_ sender: Any) {
        appDelegate.global.isBackFromSearchResultView = true
        _ = navigationController?.popViewController(animated: true)
    }
}
