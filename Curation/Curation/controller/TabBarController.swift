//
//  TabBarController.swift
//  Curation
//
//  Created by menteadmin on 2016/11/06.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers?[0].tabBarItem.image = UIImage.init(named: "home.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.viewControllers?[0].tabBarItem.selectedImage = UIImage.init(named: "home_selected.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.viewControllers?[1].tabBarItem.image = UIImage.init(named: "favo.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.viewControllers?[1].tabBarItem.selectedImage = UIImage.init(named: "favo_selected.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.viewControllers?[2].tabBarItem.image = UIImage.init(named: "search.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.viewControllers?[2].tabBarItem.selectedImage = UIImage.init(named: "search_selected.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let attributes: [String: Any]! = [NSForegroundColorAttributeName : UIColor(red: 142/255, green: 143/255, blue: 137/255, alpha: 1.0)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .disabled)
        
        self.tabBar.layer.shadowOpacity = 1.0
        self.tabBar.layer.shadowColor = UIColor(red: 228/255, green: 230/255, blue: 225/255, alpha: 1.0).cgColor
        self.tabBar.layer.shadowRadius = 0
        self.tabBar.layer.shadowOffset = CGSize.init(width: 0, height: -1.0)
        
//        self.tabBar.layer.borderColor = UIColor.red.cgColor
//        self.tabBar.layer.borderWidth = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
