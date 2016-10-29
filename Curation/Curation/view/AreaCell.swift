//
//  AreaCell.swift
//  Curation
//
//  Created by menteadmin on 2016/10/29.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class AreaCell: UITableViewCell {
    
    @IBOutlet weak var areaNameLabel: UILabel!

    func setUpCell(_ areaName: String) {
        areaNameLabel.text = areaName
    }
}
