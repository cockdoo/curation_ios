//
//  AnketAleartView.swift
//  Curation
//
//  Created by menteadmin on 2017/01/02.
//  Copyright © 2017年 TaigaSano. All rights reserved.
//

import UIKit

class AnketAleartView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func instance() -> AnketAleartView {
        return UINib(nibName: "AnketAleartView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AnketAleartView
    }
    
    override func layoutSubviews() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = Colors().mainBlack.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2
        wrapperView.layer.cornerRadius = 10
        
        let attributedText = NSMutableAttributedString(string: descriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        paragraphStyle.alignment = NSTextAlignment.center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        descriptionLabel.attributedText = attributedText
        
        okButton.addTarget(HomeViewController(), action: #selector(HomeViewController.linkAnketWebPage), for: .touchUpInside)
        noButton.addTarget(HomeViewController(), action: #selector(HomeViewController.removeAnketAleart), for: .touchUpInside)
    }
}
