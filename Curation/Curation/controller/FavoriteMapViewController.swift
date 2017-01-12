//
//  FavoriteMapViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/11/07.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import MapKit

protocol FavoriteMapViewDelegate {
    func favoriteMapView(touchedArticleButton message: String)
}

class FavoriteMapViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: FavoriteListViewDelegate!
    
    @IBOutlet weak var fMapView: FavoriteMapView!
    @IBOutlet weak var infoScrollView: UIScrollView!
    let infoViewHeight: CGFloat = 80
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var isFirstSubView: Bool!
    
    var articles = [AnyObject]()
    var isInitializedSelf: Bool = false
    
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
        isInitializedSelf = true
    }
    
    func refreshEveryViewWillApper() {
        Common().trackingScreen(vc: self) 
        isFirstSubView = true
    }
    
    override func viewDidLayoutSubviews() {
        if !isFirstSubView {
            return
        }
        refreshFavoriteList()
    }
    
    func superViewWillApperd() {
        if isInitializedSelf {
            refreshFavoriteList()
        }
    }
    
    func refreshFavoriteList(){
        articles = appDelegate.DBManager.getFavoriteArticles()
        setMarkersAndInformationViews()
        switchPrevNextButtonHidden()
        self.view.layoutIfNeeded()
    }
    
    func setMarkersAndInformationViews() {
        fMapView.resetMarkers()
        fMapView.setMarkers(objects: articles)
        fMapView.delegate = self
        
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
                fMapView.setCameraPosition(lat: lat, lng: lng)
            }
            
            let infoView = InformationView.instance()
            infoView.setInfomations(imageUrl: imageUrl, title: title, media: media, index: index)
            infoView.frame = CGRect.init(x: width * CGFloat(index), y: 0, width: width, height: infoViewHeight)
            infoScrollView.addSubview(infoView)
        }
        isFirstSubView = false
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        if !(annotation is MKPointAnnotation) {
            return
        }
        let index : CGFloat = CGFloat(atof((annotation?.title)!))
        Common().trackingEvent(category: "FavoriteMap", action: "SelectedPin", label: "\(index)")
        infoScrollView.setContentOffset(CGPoint.init(x: infoScrollView.frame.width * index, y: 0), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let identifier = "annotaion"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") { // 再利用できる場合はそのまま返す
            return annotationView
        } else { // 再利用できるアノテーションが無い場合（初回など）は生成する
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = UIImage(named: "favomap_pin.png")
            return annotationView
        }
    }
    
    
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
        fMapView.animateCameraPosition(lat: lat, lng: lng)
    }
    
    
    func touchedInfoView(button: UIButton) {
        print(button.tag)
        Common().trackingEvent(category: "FavoriteMap", action: "SelectedArticle", label: "\(button.tag)")
        appDelegate.global.selectedArticle = articles[button.tag]
        delegate.favoriteListView(touchedArticleButton: "")
    }
}
