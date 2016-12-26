//
//  NoMoveLogLabel.swift
//  Curation
//
//  Created by menteadmin on 2016/12/23.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class NoMoveLogLabel: UIView {
    
    class func instance() -> NoMoveLogLabel {
        return UINib(nibName: "NoMoveLogLabel", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! NoMoveLogLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4
    }
}
