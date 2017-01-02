//
//  AnketAleartView.swift
//  Curation
//
//  Created by menteadmin on 2017/01/02.
//  Copyright © 2017年 TaigaSano. All rights reserved.
//

import UIKit

class AnketAleartView: UIView {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    class func instance() -> AnketAleartView {
        return UINib(nibName: "AnketAleartView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! AnketAleartView
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 6
        self.layer.shadowColor = Colors().mainBlack.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        wrapperView.layer.cornerRadius = 6
        
        let attributedText = NSMutableAttributedString(string: descriptionLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = NSTextAlignment.center
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        descriptionLabel.attributedText = attributedText
        
        okButton.addTarget(HomeViewController(), action: #selector(HomeViewController.linkAnketWebPage), for: .touchUpInside)
        noButton.addTarget(HomeViewController(), action: #selector(HomeViewController.removeAnketAleart), for: .touchUpInside)
    }
}
