//
//  TutorialPage1.swift
//  Curation
//
//  Created by menteadmin on 2016/12/26.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TutorialPage1: UIView {

    @IBOutlet weak var yokosoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func instance() -> TutorialPage1 {
        return UINib(nibName: "TutorialPage1", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! TutorialPage1
    }
    
    override func layoutSubviews() {
        yokosoLabel.font = UIFont.boldSystemFont(ofSize: yokosoLabel.font.pointSize)
        let attributedText = NSMutableAttributedString(string: descriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.6
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        descriptionLabel.attributedText = attributedText
    }
}
