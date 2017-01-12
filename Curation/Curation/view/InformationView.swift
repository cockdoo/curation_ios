//
//  InformationView.swift
//  Curation
//
//  Created by menteadmin on 2016/11/07.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class InformationView: UIView {

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var wrapView: UIView!
    
    class func instance() -> InformationView {
        return UINib(nibName: "InformationView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! InformationView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setInfomations(imageUrl: String, title: String, media: String, index: Int) {
        wrapView.layer.shadowColor = Colors().mainBlack.cgColor
        wrapView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        wrapView.layer.shadowOpacity = 0.3
        wrapView.layer.shadowRadius = 2
        wrapView.layer.cornerRadius = 4
        
        articleTitleLabel.text = title
        articleTitleLabel.font = UIFont.boldSystemFont(ofSize: articleTitleLabel.font.pointSize)
        button.tag = index
        button.addTarget(FavoriteMapViewController(), action: #selector(FavoriteMapViewController.touchedInfoView(button:)), for: .touchUpInside)
        
        //画像を非同期で読み込む
        let url: URL = URL(string: imageUrl)!
        let req: URLRequest = URLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(req, queue:OperationQueue.main) {(res, data, err) in
            let img: UIImage = UIImage(data: data!)!
            self.thumbView.image = img
        }
    }
}
