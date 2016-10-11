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
    @IBOutlet weak var cellButton: UIButton!
    
    func setUpCell(title: String, imageUrl: String) {
        titleLabel.text = title
        
        let url: NSURL = NSURL(string: imageUrl)!
        //非同期で読み込む
        let req: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)
    }
    
    func getHttp(res:NSURLResponse?, data:NSData?, error:NSError?) {
        let img: UIImage = UIImage(data: data!)!
        thumbView.image = img
        
        let overlay = UIView.init(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        thumbView.addSubview(overlay)
    }
}
