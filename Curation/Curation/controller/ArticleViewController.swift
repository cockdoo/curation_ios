//
//  ArticleViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let ud = UserDefaults.standard
    let apiManager = APIManager()
    
    var isFavorite: Bool!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        let article = appDelegate.global.selectedArticle
        print(article ?? "")
        let url = URL(string : article?["url"] as! String)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
        
        let id = article?["id"] as! String
        if appDelegate.DBManager.getArticleFromFavoriteTable(id)["id"] != nil {
            isFavorite = true
        }else {
            isFavorite = false
        }
        setFavotiteButtonTheme()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webview did start load")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webview did finish load")
    }
    
    func setFavotiteButtonTheme() {
        if isFavorite! {
            favoriteButton.setTitle("削除", for: UIControlState.normal)
        }else {
            favoriteButton.setTitle("追加", for: UIControlState.normal)
        }
    }
    
    @IBAction func touchedFavoriteButton(_ sender: AnyObject) {
        if isFavorite! {
            appDelegate.DBManager.removeFromFavoriteTable(appDelegate.global.selectedArticle["id"] as! String)
            isFavorite = false
        }else {
            appDelegate.DBManager.insertFavoriteTable(appDelegate.global.selectedArticle)
            isFavorite = true
        }
        setFavotiteButtonTheme()
    }
    
    @IBAction func touchedBackButton(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
