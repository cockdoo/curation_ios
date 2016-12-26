//
//  TutorialPage2.swift
//  Curation
//
//  Created by menteadmin on 2016/12/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TutorialPage2: UIView {

    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var noUseButton: UIButton!
    
    class func instance() -> TutorialPage2 {
        return UINib(nibName: "TutorialPage2", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! TutorialPage2
    }
    
    override func layoutSubviews() {
        useButton.layer.cornerRadius = 4
        useButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: (useButton.titleLabel?.font.pointSize)!)
        
        noUseButton.addTarget(TutorialViewController(), action: #selector(TutorialViewController.touchedNoUseNotificationButton), for: .touchUpInside)
        
        useButton.addTarget(TutorialViewController(), action: #selector(TutorialViewController.touchedUseNotificaitonButton), for: .touchUpInside)
    }
}
