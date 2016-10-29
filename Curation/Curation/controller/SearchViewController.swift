//
//  SerchViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, APIManagerDelegate, LocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    //Commons
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiManager = APIManager()
    
    @IBOutlet weak var searchCurrentLocationButton: UIButton!
    @IBOutlet weak var searchField: UISearchBar!
    
    @IBOutlet weak var areaListTable: UITableView!
    var areaList = [AnyObject]()
    let cellIdentifer = "AreaCell"
    let cellHeight: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        refreshEveryViewWillApper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func initialize() {
        searchField.delegate = self
        searchField.layer.borderWidth = 0
        searchField.layer.borderColor = UIColor.clear.cgColor
        searchCurrentLocationButton.layer.cornerRadius = 4
        apiManager.delegate = self
        areaListTable.delegate = self
        areaListTable.dataSource = self
        let nib = UINib(nibName: cellIdentifer, bundle: nil)
        areaListTable.register(nib, forCellReuseIdentifier: cellIdentifer)
    }
    
    func refreshEveryViewWillApper() {
        appDelegate.LManager.delegate = self
        searchField.becomeFirstResponder()
        searchField.showsCancelButton = true
        setAreaList()
    }
    
    //MARK: SEARCH BAR
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchField.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endEdit()
        searchField.text = ""
    }
    
    //キーボードのリターンボタンが押されたとき
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEdit()
        searchFromFieldContent()
    }
    
    func searchFromFieldContent() {
        if !searchField.text!.isEmpty {
            print("検索！")
        }
    }
    
    //画面がタップされたときキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEdit()
    }
    
    func endEdit() {
        searchField.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    //MARK: CURRENT LOCATION
    
    @IBAction func touchedSerchCurrentLocationButton(_ sender: Any) {
        endEdit()
        appDelegate.LManager.startUpdatingLocation()
        Common().checkLocationAuthorize(target: self)
    }
    
    func locationManager(didUpdatingLocation message: String) {
        print("位置情報取得完了！")
        let lat = appDelegate.LManager.lat
        let lng = appDelegate.LManager.lng
        getArticlesWithLocation(lat: lat, lng: lng)
    }

    func getArticlesWithLocation(lat: Double, lng: Double) {
        let locations = [["lat": "\(lat)", "lng": "\(lng)"]]
        apiManager.getArticles(locations as [AnyObject], num: Config().numberForGetArticles)
    }
    
    //MARK: AREA TABLE
    
    func setAreaList() {
        areaList = appDelegate.DBManager.getLivingAreaList()
        areaListTable.reloadData()
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaList.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let area = areaList[indexPath.row]
        let areaName: String = area["cityName"] as! String
        let cell: AreaCell = areaListTable.dequeueReusableCell(withIdentifier: cellIdentifer) as! AreaCell
        
        cell.setUpCell(areaName)
        return cell
    }
    
    //Cellが選択された際に呼び出される.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: \((indexPath as NSIndexPath).row)")
        endEdit()
        let lat = areaList[indexPath.row]["lat"] as! Double
        let lng = areaList[indexPath.row]["lng"] as! Double
        getArticlesWithLocation(lat: lat, lng: lng)
    }
    
    
    //記事を取得できたときに呼ばれる
    func apiManager(didGetArticles articles: [AnyObject]) {
        print(articles)
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
