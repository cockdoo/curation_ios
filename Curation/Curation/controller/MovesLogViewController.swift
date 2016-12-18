//
//  MovesLogViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/12/17.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class MovesLogViewController: UIViewController, UIScrollViewDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var dateScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load!")
        
        //test
        let from = Date(timeInterval: -60*60*24*2, since: Date())
        let to = Date(timeInterval: -60*60*24*1, since: Date())
        
        let locationLog = appDelegate.DBManager.getLocationLog(from: from, to: to)
        print(locationLog)
        
        
        initialize()
    }
    
    func initialize() {
        dateScrollView.delegate = self
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        let index: Int = Int(dateScrollView.contentOffset.x / scrollView.frame.width)
//        print("Index: \(index)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
//        print("Index: \(index)")
    }
    
    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
