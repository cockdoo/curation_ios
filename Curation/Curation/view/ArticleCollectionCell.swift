//
//  ArticleCollectionCell.swift
//  Curation
//
//  Created by menteadmin on 2016/11/12.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class ArticleCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var clipView: UIView!
    
    func setUpCell(_ title: String, imageUrl: String, mediaName: String, cityName: String, index: Int) {
        /*
        self.layer.cornerRadius = 4
        clipView.layer.cornerRadius = 4
        */
 
        /*
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 1
        */
        
        
        //テキスト反映&行間調整
        let attributedText = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        titleLabel.attributedText = attributedText
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowRadius = 5
        
        mediaLabel.text = mediaName
//        mediaLabel.font = UIFont.boldSystemFont(ofSize: mediaLabel.font.pointSize)
        
        locationLabel.text = cityName
        
        
        let r = CGFloat(arc4random() % 150) + 100
        let g = CGFloat(arc4random() % 150) + 100
        let b = CGFloat(arc4random() % 150) + 100
        thumbView.backgroundColor = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
        
        //画像を非同期で読み込む
        let url: URL = URL(string: imageUrl)!
        let req: URLRequest = URLRequest(url: url)
        
        thumbView.setImageWith(req, placeholderImage: nil, success: {(req, res, image) in
            self.thumbView.image = image
            let transition = CATransition.init()
            transition.duration = 0.2
            self.thumbView.layer.add(transition, forKey: nil)
        }, failure: nil)

    }
}
