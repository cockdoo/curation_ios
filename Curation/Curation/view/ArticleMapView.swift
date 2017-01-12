//
//  ArticleMapView.swift
//  Curation
//
//  Created by menteadmin on 2016/11/06.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import MapKit

class ArticleMapView: UIView {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var coverView: UIView!
    
    class func instance() -> ArticleMapView {
        return UINib(nibName: "ArticleMapView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ArticleMapView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.shadowColor = Colors().mainBlack.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 4
    }
    
    override func layoutSubviews() {
        coverView.layer.cornerRadius = 4
    }
    
    func setMapCameraAndMarker(lat: Double, lng: Double) {
        let position = CLLocationCoordinate2DMake(lat, lng)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = position
        mapView.addAnnotation(annotation)
        
        var cr: MKCoordinateRegion = mapView.region
        cr.center = position
        cr.span = MKCoordinateSpanMake(0.01, 0.01)
        mapView.setRegion(cr, animated: true)
    }
    
    @IBAction func touchedCloseButton(_ sender: Any) {
        removeFromSuperview()
    }
}
