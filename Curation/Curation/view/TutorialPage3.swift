//
//  TutorialPage3.swift
//  Curation
//
//  Created by menteadmin on 2016/12/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TutorialPage3: UIView {

    @IBOutlet weak var descriptionLabel: UILabel!
    class func instance() -> TutorialPage3 {
        return UINib(nibName: "TutorialPage3", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! TutorialPage3
    }
    
    override func layoutSubviews() {
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: descriptionLabel.font.pointSize)
    }
}
