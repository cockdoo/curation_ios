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
    
    var myArticle: AnyObject!
    
    @IBOutlet weak var navigationTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func initialize() {
        myArticle = appDelegate.global.selectedArticle
        navigationTitle.text = myArticle["title"] as? String
        navigationTitle.font = UIFont.boldSystemFont(ofSize: navigationTitle.font.pointSize)
        setWebView()
    }
    
    func refresh() {
        let id = myArticle["id"] as! String
        if appDelegate.DBManager.getFavoriteArticleFromId(id)["id"] != nil {
            isFavorite = true
        }else {
            isFavorite = false
        }
        setFavotiteButtonTheme()
    }
    
    func setWebView() {
        print(myArticle ?? "")
        let url = URL(string : myArticle["url"] as! String)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webview did start load")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webview did finish load")
    }
    
    @IBAction func touchedPrevPageButton(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func touchedNextPageButton(_ sender: Any) {
        webView.goForward()
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
    
    @IBAction func touchedMapButton(_ sender: Any) {
        setMapView()
    }
    
    func setMapView() {
        let lightBox = ArticleMapView.instance()
        lightBox.frame = CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width - 60, height: self.view.frame.height - 120))
        lightBox.center = self.view.center
        let lat = Double(myArticle["lat"] as! String)
        let lng = Double(myArticle["lng"] as! String)
        lightBox.setMapCameraAndMarker(lat: lat!, lng: lng!)
        self.view.addSubview(lightBox)
    }
    
    @IBAction func touchedBackButton(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
