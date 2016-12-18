//
//  MovesLogDayView.swift
//  Curation
//
//  Created by menteadmin on 2016/12/18.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class MovesLogDayView: UIView {
    class func instance() -> MovesLogDayView {
        return UINib(nibName: "MovesLogDayView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MovesLogDayView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowOpacity = 20
    }
}
