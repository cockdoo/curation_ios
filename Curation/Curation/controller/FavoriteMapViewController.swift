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
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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
        switchPrevNextButtonHidden()
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
            let lat = Double(article["lat"] as! String)!
            let lng = Double(article["lng"] as! String)!
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
        let index: CGFloat = CGFloat(marker.userData as! Int)
        print("Index: \(index)")
        infoScrollView.setContentOffset(CGPoint.init(x: infoScrollView.frame.width * index, y: 0), animated: true)
        return false
    }
    
    /*
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        appDelegate.global.selectedArticle = articles[marker.userData as! Int]
        delegate.favoriteListView(touchedArticleButton: "")
    }
    */
    
    @IBAction func touchedPrevButton(_ sender: Any) {
        let index = infoScrollView.contentOffset.x / infoScrollView.frame.width
        if !Common().isInteger(n: Double(index)) || infoScrollView.contentOffset.x == 0 { return }
        
        infoScrollView.setContentOffset(CGPoint.init(x: infoScrollView.contentOffset.x - infoScrollView.frame.width, y: 0), animated: true)
    }
    
    @IBAction func touchedNextButton(_ sender: Any) {
        let index = infoScrollView.contentOffset.x / infoScrollView.frame.width
        if !Common().isInteger(n: Double(index)) || infoScrollView.contentOffset.x == infoScrollView.frame.width * CGFloat(articles.count - 1) { return }
        
        infoScrollView.setContentOffset(CGPoint.init(x: infoScrollView.contentOffset.x + infoScrollView.frame.width, y: 0), animated: true)
    }
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        print("Index: \(index)")
        changeMapCameraPosition(index: index)
        switchPrevNextButtonHidden()
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        print("Index: \(index)")
        changeMapCameraPosition(index: index)
        switchPrevNextButtonHidden()
    }
    
    func switchPrevNextButtonHidden() {
        if articles.count == 0 {
            prevButton.isHidden = true
            nextButton.isHidden = true
            return
        }
        if infoScrollView.contentOffset.x == 0 {
            prevButton.isHidden = true
        }else {
            prevButton.isHidden = false
        }
        if infoScrollView.contentOffset.x == infoScrollView.frame.width * CGFloat(articles.count - 1) {
            nextButton.isHidden = true
        }else {
            nextButton.isHidden = false
        }
    }
    
    func changeMapCameraPosition(index: Int) {
        let lat = Double(articles[index]["lat"] as! String)!
        let lng = Double(articles[index]["lng"] as! String)!
        mapView.animateCameraPosition(lat: lat, lng: lng)
    }
    
    
    
    func touchedInfoView(button: UIButton) {
        appDelegate.global.selectedArticle = articles[button.tag]
        delegate.favoriteListView(touchedArticleButton: "")
    }
}
