//
//  SidemenuViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/12/17.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class SidemenuViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
    }
    
    @IBAction func touchedMoveLogButton(_ sender: Any) {
        openMovesLogView()
    }
    
    func openMovesLogView() {
        let storyboard = UIStoryboard(name: "MovesLog", bundle: nil)
        let nextView: UIViewController! = storyboard.instantiateInitialViewController()
        self.present(nextView, animated: true, completion: nil)
    }
    
    @IBAction func touchedAnketoButton(_ sender: Any) {
        let url = NSURL(string: "https://docs.google.com/forms/d/1DSU7cL-tYr4ASLA40VJHGkdAoYbRA0v6sNqw8yHNgRY")
        let app:UIApplication = UIApplication.shared
        app.openURL(url! as URL)
    }    
}
