//
//  FavoriteCell.swift
//  Curation
//
//  Created by menteadmin on 2016/10/28.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbView: UIImageView!
    
    func setUpCell(_ title: String, imageUrl: String, index: Int) {
        //テキスト反映&行間調整
        let attributedText = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        titleLabel.attributedText = attributedText
        
        //画像を非同期で読み込む
        let url: URL = URL(string: imageUrl)!
        let req: URLRequest = URLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(req, queue:OperationQueue.main) {(res, data, err) in
            let img: UIImage = UIImage(data: data!)!
            self.thumbView.image = img
        }
    }
}