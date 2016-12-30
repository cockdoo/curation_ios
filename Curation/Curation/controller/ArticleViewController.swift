//
//  ArticleViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import SwiftyGif

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
    
    @IBOutlet weak var webPrevButton: UIButton!
    @IBOutlet weak var webNextButton: UIButton!
    
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var favoImageView: UIImageView!
    var favoAnimationView: UIImageView!
    
    @IBOutlet weak var ikitaiLabel: UILabel!
    @IBOutlet weak var tizuLabel: UILabel!
    
    var loadCount: Int!
    
    var mapLightBox: ArticleMapView!
    
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
        toolView.layer.shadowColor = Colors().borderGray.cgColor
        toolView.layer.shadowOffset = CGSize.init(width: 0, height: -0.5)
        toolView.layer.shadowOpacity = 1
        toolView.layer.shadowRadius = 0
        ikitaiLabel.font = UIFont.boldSystemFont(ofSize: ikitaiLabel.font.pointSize)
        tizuLabel.font = UIFont.boldSystemFont(ofSize: tizuLabel.font.pointSize)
        loadCount = 0
        loadWebView()
    }
    
    func refresh() {
        let id = myArticle["id"] as! String
        if appDelegate.DBManager.getFavoriteArticleFromId(id)["id"] != nil {
            isFavorite = true
        }else {
            isFavorite = false
        }
        webView.delegate = self
        toggleFavotiteButtonTheme()
    }
    
    func loadWebView() {
        print(myArticle ?? "")
        let url = URL(string : myArticle["url"] as! String)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
        appDelegate.global.showLoadingView(view: self.view, messege: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        print("webview did start load")
        loadCount =  loadCount + 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        print("webview did finish load")
        loadCount =  loadCount - 1
        if loadCount > 0 {
            return;
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("finish all loading")
        loadCount = 0
        appDelegate.global.removeLoadingView()
        setWebControlButton()
    }
    
    func setWebControlButton() {
        if webView.canGoBack {
            webPrevButton.isUserInteractionEnabled = true
            webPrevButton.setImage(UIImage.init(named: "web_prev_on.png"), for: .normal)
        }else {
            webPrevButton.isUserInteractionEnabled = false
            webPrevButton.setImage(UIImage.init(named: "web_prev_off.png"), for: .normal)
        }
        if webView.canGoForward {
            webNextButton.isUserInteractionEnabled = true
            webNextButton.setImage(UIImage.init(named: "web_next_on.png"), for: .normal)
        }else {
            webNextButton.isUserInteractionEnabled = false
            webNextButton.setImage(UIImage.init(named: "web_next_off.png"), for: .normal)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadCount = loadCount - 1
        if loadCount > 0 {
            return
        }
        appDelegate.global.removeLoadingView()
        Common().showAlert(title: "", message: "読み込みエラー", target: self, popView: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    @IBAction func touchedPrevPageButton(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func touchedNextPageButton(_ sender: Any) {
        webView.goForward()
    }
  
    func toggleFavotiteButtonTheme() {
        if isFavorite! {
            favoImageView.image = UIImage(named: "favo_on.png")
            ikitaiLabel.textColor = Colors().mainGreen
        }else {
            if favoAnimationView != nil {
                favoAnimationView.removeFromSuperview()
                favoAnimationView = nil
            }
            favoImageView.image = UIImage(named: "favo_off.png")
            ikitaiLabel.textColor = Colors().subText
        }
    }
    
    @IBAction func touchedFavoriteButton(_ sender: AnyObject) {
        if isFavorite! {
            appDelegate.DBManager.removeFromFavoriteTable(appDelegate.global.selectedArticle["id"] as! String)
            isFavorite = false
        }else {
            appDelegate.DBManager.insertFavoriteTable(appDelegate.global.selectedArticle)
            let gifmanager = SwiftyGifManager(memoryLimit: 20)
            let gif = UIImage(gifName: "favo")
            favoAnimationView = UIImageView(gifImage: gif, manager: gifmanager)
            favoAnimationView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            favoAnimationView.setGifImage(gif, loopCount: 1)
            favoImageView.addSubview(favoAnimationView)
            isFavorite = true
        }
        toggleFavotiteButtonTheme()
    }
    
    @IBAction func touchedMapButton(_ sender: Any) {
        if mapLightBox == nil {
            setMapView()
        }else {
            removeMapView()
        }
    }
    
    func setMapView() {
        mapLightBox = ArticleMapView.instance()
        mapLightBox.frame = CGRect.init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width - 90, height: (self.view.frame.width - 90) * 1.5))
        mapLightBox.center = self.view.center
        let lat = Double(myArticle["lat"] as! String)
        let lng = Double(myArticle["lng"] as! String)
        mapLightBox.setMapCameraAndMarker(lat: lat!, lng: lng!)
        self.view.addSubview(mapLightBox)
    }
    
    func removeMapView() {
        if mapLightBox != nil {
            mapLightBox.removeFromSuperview()
            mapLightBox = nil
        }
    }
    
    @IBAction func touchedBackButton(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
