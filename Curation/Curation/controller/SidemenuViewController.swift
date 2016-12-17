//
//  SidemenuViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/12/17.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SidemenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchedMoveLogButton(_ sender: Any) {
        openMovesLogView()
    }
    
    func openMovesLogView() {
        let storyboard = UIStoryboard(name: "MovesLog", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.present(nextView, animated: true, completion: nil)
    }
}
