//
//  SerchViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, APIManagerDelegate, LocationManagerDelegate, UISearchBarDelegate, UITabBarControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
                    secondSubView.backgroundColor = Colors().lightGray
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
        self.tabBarController?.delegate = self
//        startEdit()
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
            searchLocationFromAddress()
        }
    }
    
    func searchLocationFromAddress() {
        CLGeocoder().geocodeAddressString(searchField.text!, in: nil, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Search Error:\(error)")
                Common().showAlert(title: "検索失敗", message: "該当する場所がありませんでした。", target: self)
                return
            }
            if let placemarks = placemarks {
                guard let place = placemarks.first else { return }
                self.getArticlesWithLocation(lat: (place.location?.coordinate.latitude)!, lng: (place.location?.coordinate.latitude)!)
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
        appDelegate.LManager.startUpdatingLocation()
        Common().checkLocationAuthorize(target: self)
    }
    
    func locationManager(didUpdatingLocation message: String) {
        if !isSearch {
            return
        }
        print("位置情報取得完了！")
        let lat = appDelegate.LManager.lat
        let lng = appDelegate.LManager.lng
        getArticlesWithLocation(lat: lat, lng: lng)
        isSearch = false
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
        let size: CGSize = CGSize.init(width: (sw-1)/2, height: (sw-1)/2/1.618)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: UIEdgeInsets = UIEdgeInsets.init(top: 1, left: 0, bottom: 0, right: 0)
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
        print("Index: \((indexPath as NSIndexPath).row)")
        endEdit()
        let lat = areaList[indexPath.row]["lat"] as! Double
        let lng = areaList[indexPath.row]["lng"] as! Double
        getArticlesWithLocation(lat: lat, lng: lng)
    }
    
    //記事を取得できたときに呼ばれる
    func apiManager(didGetArticles articles: [AnyObject]) {
        if articles.count > 0 {
            appDelegate.global.searchResultArticles = articles
            transitionToSearchResultView()
        }else {
            Common().showAlert(title: "検索結果", message: "該当記事がありませんでした。", target: self)
        }
    }
    
    func transitionToSearchResultView() {
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
