//
//  FavoriteMapView.swift
//  Curation
//
//  Created by menteadmin on 2016/11/07.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import MapKit

class FavoriteMapView: MKMapView {
    
    var markers = [MKAnnotation]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setMarkers(objects: [AnyObject]) {
        markers = [MKAnnotation]()
        
        for (index, object) in objects.enumerated() {
            let lat = Double(object["lat"] as! String)!
            let lng = Double(object["lng"] as! String)!
            
            let position = CLLocationCoordinate2DMake(lat, lng)
//            marker.title = title
//            let pinName = "pin_\(num).png"
//            let img: UIImage! = UIImage(named: pinName)
//            marker.icon = img
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = position
            annotation.title = "\(index)"
            self.addAnnotation(annotation)
            
            markers.append(annotation)
        }
    }
    
    func resetMarkers() {
        for marker in markers {
            self.removeAnnotation(marker)
        }
    }
    
    func setCameraPosition(lat: Double, lng: Double) {
        var cr: MKCoordinateRegion = self.region
        cr.center = CLLocationCoordinate2DMake(lat, lng)
        cr.span = MKCoordinateSpanMake(0.01, 0.01)
        self.setRegion(cr, animated: false)
    }
    
    func animateCameraPosition(lat: Double, lng: Double) {
        var cr: MKCoordinateRegion = self.region
        cr.center = CLLocationCoordinate2DMake(lat, lng)
        self.setRegion(cr, animated: true)
    }
}
