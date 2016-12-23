//
//  MovesLogViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/12/17.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import MapKit

class MovesLogViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var logMapView: MKMapView!
    @IBOutlet weak var dateScrollView: UIScrollView!
    
    let currentDate: Date = Date.init(timeIntervalSinceNow: TimeInterval(NSTimeZone.system.secondsFromGMT()))
    let timeDifference: TimeInterval = TimeInterval(NSTimeZone.system.secondsFromGMT())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        
        dateScrollView.delegate = self
        
        dateScrollView.layer.shadowColor = UIColor.black.cgColor
        dateScrollView.layer.shadowOffset = CGSize.init(width: 0, height: -2)
        dateScrollView.layer.shadowOpacity = 0.5
        dateScrollView.layer.shadowRadius = 2
        
        logMapView.delegate = self
    }
    
    var isAlreadySet = false
    override func viewDidLayoutSubviews() {
        if !isAlreadySet {
            setDateView()
            prepareSetDayMoveLog(dayCountFromToday: 0)
            isAlreadySet = true
        }
    }
    
    func setDateView() {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        
        for num in 0..<30 {
            let dateView: MovesLogDayView = MovesLogDayView.instance()
            dateView.frame = CGRect.init(x: dateScrollView.frame.width*CGFloat(num), y: 0, width: dateScrollView.frame.width, height: dateScrollView.frame.height)
            let dateString = dateFormater.string(from: Date.init(timeInterval: TimeInterval(-60*60*24*num), since: Date()))
            dateView.dateLabel.text = dateString
            dateView.dayLabel.text = dateString.substring(from: dateString.index(dateString.endIndex, offsetBy: -2))
            dateView.dayOfWeelLabel.text = getshortWeekdaySymbols(date: Date.init(timeInterval: TimeInterval(-60*60*24*num), since: Date()))
            dateScrollView.addSubview(dateView)
        }
        dateScrollView.contentSize = CGSize.init(width: dateScrollView.frame.width*30, height: dateScrollView.frame.height)
    }
    
    func getshortWeekdaySymbols(date: Date) -> String {
        let cal: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let comp: NSDateComponents = cal.components(
            [NSCalendar.Unit.weekday],
            from: date
            ) as NSDateComponents
        let weekday: Int = comp.weekday
        let weekdaySymbolIndex: Int = weekday - 1
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja")
//        print(formatter.shortWeekdaySymbols[weekdaySymbolIndex]) // -> 日
//        print(formatter.weekdaySymbols[weekdaySymbolIndex]) // -> 日曜日
        return formatter.shortWeekdaySymbols[weekdaySymbolIndex]
    }
    
    var prevIndex = 0
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        print("Index: \(index)")
        
        if prevIndex != index {
            prevIndex = index
            prepareSetDayMoveLog(dayCountFromToday: index)
        }
    }
    
    func prepareSetDayMoveLog(dayCountFromToday: Int) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormater.string(from: Date())
        let todayStartDate = Date.init(timeInterval: timeDifference, since: dateFormater.date(from: todayString)!)

        let from: Date = Date.init(timeInterval: TimeInterval(-60*60*24*dayCountFromToday), since: todayStartDate)
        let to: Date = Date.init(timeInterval: TimeInterval(-60*60*24*(dayCountFromToday-1)-1), since: todayStartDate)
        
        let locationLog = appDelegate.DBManager.getLocationLog(from: from, to: to)
        
        if prevLines != nil {
            logMapView.remove(prevLines!)
        }
        if locationLog.count > 0 {
            removeNoMoveLogLabel()
            setDayMoveLog(locations: locationLog)
        }else {
            setNoMoveLogLabel()
        }
    }
    
    var prevLines: MKPolyline?
    func setDayMoveLog(locations: [AnyObject]) {
        var coordinates = [CLLocationCoordinate2D]()
        var maxLat = -999.0
        var maxLng = -999.0
        var minLat = 999.0
        var minLng = 999.0
        
        for location in locations {
            let lat = location["lat"] as! Double
            let lng = location["lng"] as! Double
            let c = CLLocationCoordinate2DMake(lat, lng)
            coordinates.append(c)
            
            if lat > maxLat { maxLat = lat }
            if lng > maxLng { maxLng = lng }
            if lat < minLat { minLat = lat }
            if lng < minLng { minLng = lng }
        }
        let polyline: MKPolyline = MKPolyline.init(coordinates: coordinates, count: coordinates.count)
        prevLines = polyline
        logMapView.add(polyline)
        
        var cr: MKCoordinateRegion = logMapView.region
        cr.center.latitude = (maxLat + minLat) / 2
        cr.center.longitude = (maxLng + minLng) / 2
        
        let mapMargin:Double = 1.5;
        let leastCoordSpan:Double = 0.005;
        let span_x:Double = fmax(leastCoordSpan, fabs(maxLat - minLat) * mapMargin);
        let span_y:Double = fmax(leastCoordSpan, fabs(maxLng - minLng) * mapMargin);
        cr.span = MKCoordinateSpanMake(span_x, span_y);
        logMapView.setRegion(cr, animated: true)
    }
    
    var noLabel: NoMoveLogLabel?
    func setNoMoveLogLabel() {
        if noLabel != nil {
            return
        }
        noLabel = NoMoveLogLabel.instance()
        noLabel?.frame = CGRect.init(x: 0, y: 0, width: 190, height: 40)
        noLabel?.center = logMapView.center
        self.view.addSubview(noLabel!)
    }
    
    func removeNoMoveLogLabel() {
        if noLabel != nil {
            noLabel?.removeFromSuperview()
            noLabel = nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        myPolyLineRendere.lineWidth = 7
        myPolyLineRendere.strokeColor = UIColor.red
        myPolyLineRendere.alpha = 0.6
        return myPolyLineRendere
    }
    
    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
