//
//  FavoriteViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import PageMenu


class FavoriteViewController: UIViewController, CAPSPageMenuDelegate, FavoriteListViewDelegate, FavoriteMapViewDelegate, NotificationManagerDelegate, UITabBarControllerDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var pageMenuCover: UIView!
    var pageMenu: CAPSPageMenu?

    var alreadyAddSubview: Bool!
    
    var pageMenuCoverFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        alreadyAddSubview = false
    }
    
    
    let list: FavoriteListViewController! = UIStoryboard(name: "FavoriteList", bundle: nil).instantiateInitialViewController() as! FavoriteListViewController!
    let map: FavoriteMapViewController! = UIStoryboard(name: "FavoriteMap", bundle: nil).instantiateInitialViewController() as! FavoriteMapViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        refreshEveryViewWillApper()
    }
    
    func refreshEveryViewWillApper() {
        self.tabBarController?.delegate = self
        appDelegate.NManager.delegate = self
        if alreadyAddSubview! {
            list.superViewWillApperd()
            map.superViewWillApperd()
        }
    }
    
    override func viewDidLayoutSubviews() {
        pageMenuCoverFrame = pageMenuCover.frame
        if !alreadyAddSubview {
            setPageMenuController()
        }
    }
    
    func setPageMenuController() {
        var controllerArray : [UIViewController] = []
        
        list.delegate = self
        
        map.delegate = self
        
        list.title = "リスト"
        map.title = "マップ"
        controllerArray.append(list)
        controllerArray.append(map)
        let parameters: [CAPSPageMenuOption] = [
            .useMenuLikeSegmentedControl(true),
            .scrollAnimationDurationOnMenuItemTap(Int(250)),
            .menuItemSeparatorPercentageHeight(0.0),
            .scrollMenuBackgroundColor(UIColor.white),
            .menuHeight(44),
            .selectedMenuItemLabelColor(Colors().mainBlack),
            .unselectedMenuItemLabelColor(Colors().subText),
            .selectionIndicatorColor(Colors().mainGreen),
            .bottomMenuHairlineColor(Colors().lightGreen),
            .selectionIndicatorHeight(2),
            .menuItemFont(UIFont.init(name: "Gotham Rounded", size: 15)!),
            .menuItemFont(UIFont.boldSystemFont(ofSize: 15))
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect.init(x: 0, y: 0, width: pageMenuCoverFrame.width, height: pageMenuCoverFrame.height), pageMenuOptions: parameters)
        pageMenuCover.addSubview(pageMenu!.view)
        pageMenu?.delegate = self
        
        alreadyAddSubview = true
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int){}
    
    func didMoveToPage(_ controller: UIViewController, index: Int){}
    
    func favoriteListView(touchedArticleButton message: String) {
        transitionToArticleView()
    }
    
    func favoriteMapView(touchedArticleButton message: String) {
        transitionToArticleView()
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
