//
//  FavoriteMapViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/11/07.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

protocol FavoriteMapViewDelegate {
    func favoriteMapView(touchedArticleButton message: String)
}

class FavoriteMapViewController: UIViewController, UIScrollViewDelegate, GMSMapViewDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: FavoriteListViewDelegate!
    
    @IBOutlet weak var mapView: FavoriteMapView!
    @IBOutlet weak var infoScrollView: UIScrollView!
    let infoViewHeight: CGFloat = 80
    
    var isFirstSubView: Bool!
    
    var articles = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        infoScrollView.delegate = self
    }
    
    func refreshEveryViewWillApper() {
        isFirstSubView = true
    }
    
    override func viewDidLayoutSubviews() {
        if !isFirstSubView {
            return
        }
        articles = appDelegate.DBManager.getFavoriteArticles()
        setMarkersAndInformationViews()
        self.view.layoutIfNeeded()
    }
    
    func setMarkersAndInformationViews() {
        
        mapView.resetMarkers()
        mapView.setMarkers(objects: articles)
        mapView.delegate = self
        
        let width = infoScrollView.frame.width
        
        for v in infoScrollView.subviews {
            v.removeFromSuperview()
        }
        
        infoScrollView.contentSize = CGSize.init(width: width * CGFloat(articles.count), height: infoViewHeight)

        for (index, article) in articles.enumerated() {
            let title = article["title"] as! String
            let lat = article["lat"] as! Double
            let lng = article["lng"] as! Double
            let imageUrl = article["imageUrl"] as! String
            let media = article["media"] as! String
            
            if index == 0 {
                mapView.setCameraPosition(lat: lat, lng: lng)
            }
            
            let infoView = InformationView.instance()
            infoView.setInfomations(imageUrl: imageUrl, title: title, media: media, index: index)
            infoView.frame = CGRect.init(x: width * CGFloat(index), y: 0, width: width, height: infoViewHeight)
            infoScrollView.addSubview(infoView)
        }
        isFirstSubView = false
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        appDelegate.global.selectedArticle = articles[marker.userData as! Int]
        delegate.favoriteListView(touchedArticleButton: "")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("ぬあ！")
        print(scrollView.contentInset)
        print(scrollView.contentOffset)
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        print("Index: \(index)")
        let lat = articles[index]["lat"] as! Double
        let lng = articles[index]["lng"] as! Double
        mapView.animateCameraPosition(lat: lat, lng: lng)
    }
    
    @IBAction func touchedPrevButton(_ sender: Any) {
        
    }
    
    @IBAction func touchedNextButton(_ sender: Any) {
        
    }
    
    func touchedInfoView(button: UIButton) {
        appDelegate.global.selectedArticle = articles[button.tag]
        delegate.favoriteListView(touchedArticleButton: "")
    }
}
