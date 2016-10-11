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
    
    func setUpCell(title: String, imageUrl: String, index: Int) {
        //テキスト反映&行間調整
        let attributedText = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        titleLabel.attributedText = attributedText
        
        //画像を非同期で読み込む
        let url: NSURL = NSURL(string: imageUrl)!
        let req: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)
    }
    
    func getHttp(res:NSURLResponse?, data:NSData?, error:NSError?) {
        let img: UIImage = UIImage(data: data!)!
        thumbView.image = img
    }
}
