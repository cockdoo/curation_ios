//
//  SerchViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, APIManagerDelegate, LocationManagerDelegate, NotificationManagerDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiManager = APIManager()
    var sw: CGFloat!
    var sh: CGFloat!
    
    @IBOutlet weak var searchCurrentLocationButton: UIButton!
    @IBOutlet weak var searchField: UISearchBar!
    
    @IBOutlet weak var areaCollection: UICollectionView!
    
    var areaList = [AnyObject]()
    let cellIdentifer = "AreaCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Common().trackingScreen(vc: self)
        if !appDelegate.global.isBackFromSearchResultView {
            refreshEveryViewWillApper()
        }
        appDelegate.global.isBackFromSearchResultView = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.navigationController {
            startEdit()
        }
    }
    
    func initialize() {
        sw = self.view.bounds.width
        sh = self.view.bounds.height
        searchField.delegate = self
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.white.cgColor
//        searchField.backgroundImage = UIImage()
        for subView in searchField.subviews {
            for secondSubView in subView.subviews {
                if secondSubView is UITextField {
                    secondSubView.backgroundColor = Colors().borderGray
                }
            }
        }
        
        searchCurrentLocationButton.layer.cornerRadius = 20
        
        apiManager.delegate = self
        areaCollection.delegate = self
        areaCollection.dataSource = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        areaCollection.register(nib, forCellWithReuseIdentifier: cellIdentifer)
    }
    
    func refreshEveryViewWillApper() {
        appDelegate.LManager.delegate = self
        appDelegate.NManager.delegate = self
        self.tabBarController?.delegate = self
        setAreaList()
    }
    
    //MARK: SEARCH BAR
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = true
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.setTitle("キャンセル", for: UIControlState.normal)
        uiButton.titleLabel?.font = UIFont.init(name: "Gotham Rounded", size: 16)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEdit()
        searchField.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEdit()
        searchFromFieldContent()
    }
    
    func searchFromFieldContent() {
        if !searchField.text!.isEmpty {
            appDelegate.global.showLoadingView(view: self.view, messege: nil)
            searchLocationFromAddress()
        }
    }
    
    func searchLocationFromAddress() {
        Common().trackingEvent(category: "Search", action: "TextField", label: searchField.text!)
        
        CLGeocoder().geocodeAddressString(searchField.text!, in: nil, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Search Error:\(error)")
                self.appDelegate.global.removeLoadingView()
                Common().showAlert(title: "検索失敗", message: "該当する場所がありませんでした。", target: self, popView: false)
                return
            }
            if let placemarks = placemarks {
                guard let place = placemarks.first else { return }
                self.getArticlesWithLocation(lat: (place.location?.coordinate.latitude)!, lng: (place.location?.coordinate.longitude)!)
                self.appDelegate.global.searchedPlaceName = self.searchField.text!
            }
            
        })
    }
    
    //画面がタップされたときキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEdit()
    }
    
    func startEdit() {
        searchField.showsCancelButton = true
        searchField.becomeFirstResponder()
        
    }
    
    func endEdit() {
        searchField.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    //MARK: CURRENT LOCATION
    
    var isSearch = false
    @IBAction func touchedSerchCurrentLocationButton(_ sender: Any) {
        endEdit()
        isSearch = true
        if Common().isLocationAuthorize() {
            Common().trackingEvent(category: "Search", action: "CurrentLocation", label: nil)
            appDelegate.global.showLoadingView(view: self.view, messege: nil)
            getArticlesWithLocation(lat: appDelegate.LManager.lat, lng: appDelegate.LManager.lng)
            appDelegate.global.searchedPlaceName = "現在地"
        }else {
            Common().checkLocationAuthorize(target: self)
        }
    }
    
    func locationManager(didUpdatingLocation message: String) {
        if !isSearch {
            return
        }
        print("位置情報取得完了！")
//        let lat = appDelegate.LManager.lat
//        let lng = appDelegate.LManager.lng
//        getArticlesWithLocation(lat: lat, lng: lng)
//        isSearch = false
    }

    func getArticlesWithLocation(lat: Double, lng: Double) {
        let locations = [["lat": "\(lat)", "lng": "\(lng)"]]
        apiManager.getArticles(locations as [AnyObject], num: Config().numberForGetArticles)
    }
    
    //MARK: Area Collection
    
    func setAreaList() {
        areaList = appDelegate.DBManager.getLivingAreaList()
        areaCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = CGSize.init(width: (sw-15)/2, height: (sw-15)/2/1.618)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5)
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let area = areaList[indexPath.row]
        let areaName: String = area["cityName"] as! String
        let lat: Double = area["lat"] as! Double
        let lng: Double = area["lng"] as! Double
        let cell: AreaCell = areaCollection.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! AreaCell
        
        cell.setUpCell(areaName, lat: lat, lng: lng)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Common().trackingEvent(category: "Search", action: "LivingArea", label: "\(indexPath.row)")
        
        print("Index: \((indexPath as NSIndexPath).row)")
        endEdit()
        let lat = areaList[indexPath.row]["lat"] as! Double
        let lng = areaList[indexPath.row]["lng"] as! Double
        appDelegate.global.showLoadingView(view: self.view, messege: nil)
        getArticlesWithLocation(lat: lat, lng: lng)
        appDelegate.global.searchedPlaceName = areaList[indexPath.row]["cityName"] as! String
    }
    
    //記事を取得できたときに呼ばれる
    func apiManager(didGetArticles articles: [AnyObject]) {
        appDelegate.global.removeLoadingView()
        if articles.count > 0 {
            appDelegate.global.searchResultArticles = articles
            transitionToSearchResultView()
        }else {
            Common().showAlert(title: "検索結果", message: "該当記事がありませんでした。", target: self, popView: false)
        }
    }
    
    func apiManager(failedGetArticles messege: String?) {
        print("記事取得失敗")
        appDelegate.global.removeLoadingView()
        Common().showAlert(title: "エラー", message: "記事の取得に失敗しました。再度お試しください。", target: self, popView: false)
    }
    
    func transitionToSearchResultView() {
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
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
}
