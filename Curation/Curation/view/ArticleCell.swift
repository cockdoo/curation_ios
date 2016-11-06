//
//  ArticleCell.swift
//  Curation
//
//  Created by menteadmin on 2016/10/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var mediaLabel: UILabel!
    
    func setUpCell(_ title: String, imageUrl: String, mediaName: String, index: Int) {
        //テキスト反映&行間調整
        let attributedText = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.0
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        titleLabel.attributedText = attributedText
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowRadius = 5
        
        mediaLabel.text = mediaName
        mediaLabel.font = UIFont.boldSystemFont(ofSize: mediaLabel.font.pointSize)
        
        let r = CGFloat(arc4random() % 200)
        let g = CGFloat(arc4random() % 200)
        let b = CGFloat(arc4random() % 200)
        thumbView.backgroundColor = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
        
        //画像を非同期で読み込む
        let url: URL = URL(string: imageUrl)!
        let req: URLRequest = URLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(req, queue:OperationQueue.main) {(res, data, err) in
            let img: UIImage = UIImage(data: data!)!
            self.thumbView.image = img
        }
    }
}
