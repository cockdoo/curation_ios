//
//  FavoriteListNoItemView.swift
//  Curation
//
//  Created by menteadmin on 2017/01/03.
//  Copyright © 2017年 TaigaSano. All rights reserved.
//

import UIKit

class FavoriteListNoItemView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func instance() -> FavoriteListNoItemView {
        return UINib(nibName: "FavoriteListNoItemView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! FavoriteListNoItemView
    }
    
    override func layoutSubviews() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        let attributedText = NSMutableAttributedString(string: descriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        paragraphStyle.alignment = NSTextAlignment.center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        descriptionLabel.attributedText = attributedText
    }
}
