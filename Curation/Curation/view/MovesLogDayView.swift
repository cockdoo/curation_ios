//
//  MovesLogDayView.swift
//  Curation
//
//  Created by menteadmin on 2016/12/18.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class MovesLogDayView: UIView {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayOfWeelLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var circleInsideView: UIView!
    
    
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
        self.layer.shadowOpacity = 0
    }
    
    override func layoutSubviews() {
        circleView.layer.cornerRadius = 47.0/2
        circleInsideView.layer.cornerRadius = 43.0/2
    }
}
