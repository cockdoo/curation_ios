//
//  HomeContainerViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/12/17.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class HomeContainerViewController: SlideMenuController {

    override func awakeFromNib() {
        let controller: UIViewController = UIStoryboard(name: "Top", bundle: nil).instantiateViewController(withIdentifier: "Home")
        self.mainViewController = controller
        let leftController = UIStoryboard(name: "Sidemenu", bundle: nil).instantiateInitialViewController()
        self.leftViewController = leftController
        
        SlideMenuOptions.leftViewWidth = self.view.frame.width*6/10
        SlideMenuOptions.contentViewScale = 0.98
        SlideMenuOptions.animationDuration = 0.2
        SlideMenuOptions.hideStatusBar = false
        super.awakeFromNib()
    }
}
