//
//  FavoriteMapView.swift
//  Curation
//
//  Created by menteadmin on 2016/11/07.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class FavoriteMapView: GMSMapView {
    
    var markers = [GMSMarker]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setMarkers(objects: [AnyObject]) {
        markers = [GMSMarker]()
        
        for (index, object) in objects.enumerated() {
            let lat = Double(object["lat"] as! String)!
            let lng = Double(object["lng"] as! String)!
            let title = object["title"] as! String
            
            let position = CLLocationCoordinate2DMake(lat, lng)
            let marker = GMSMarker(position: position)
//            marker.title = title
//            let pinName = "pin_\(num).png"
//            let img: UIImage! = UIImage(named: pinName)
//            marker.icon = img
            marker.userData = index
            marker.map = self
            markers.append(marker)
        }
    }
    
    func resetMarkers() {
        for marker in markers {
            marker.map = nil
        }
    }
    
    func setCameraPosition(lat: Double, lng: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 14)
        self.camera = camera
    }
    
    func animateCameraPosition(lat: Double, lng: Double) {
        self.animate(toLocation: CLLocationCoordinate2D.init(latitude: lat, longitude: lng))
    }
}
