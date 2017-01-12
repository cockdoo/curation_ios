//
//  AreaCell.swift
//  Curation
//
//  Created by menteadmin on 2016/10/29.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class AreaCell: UICollectionViewCell {
    
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var areaImageView: UIImageView!
    
    func setUpCell(_ areaName: String, lat: Double, lng: Double) {
        areaNameLabel.text = areaName
        areaNameLabel.adjustsFontSizeToFitWidth = true
        
        let r = CGFloat(arc4random() % 150) + 100
        let g = CGFloat(arc4random() % 150) + 100
        let b = CGFloat(arc4random() % 150) + 100
        areaImageView.backgroundColor = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
        
        self.layer.cornerRadius = 4
        
        //画像を非同期で読み込む
        let urlStr = "http://taigasano.com/curation/api/get-image/?lat=\(lat)&lng=\(lng)"
        let url: URL = URL(string: urlStr)!
        let req: URLRequest = URLRequest(url: url)
        print(urlStr)
        
        areaImageView.setImageWith(req, placeholderImage: nil, success: {(req, res, image) in
            self.areaImageView.image = image
            let transition = CATransition.init()
            transition.duration = 0.2
            self.areaImageView.layer.add(transition, forKey: nil)
        }, failure: nil)
    }
}
