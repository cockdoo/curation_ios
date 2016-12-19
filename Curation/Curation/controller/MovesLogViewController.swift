//
//  MovesLogViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/12/17.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit
import MapKit

class MovesLogViewController: UIViewController, UIScrollViewDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateScrollView: UIScrollView!
    
    let currentDate: Date = Date.init(timeIntervalSinceNow: TimeInterval(NSTimeZone.system.secondsFromGMT()))
    let timeDifference: TimeInterval = TimeInterval(NSTimeZone.system.secondsFromGMT())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        dateScrollView.delegate = self
        
        dateScrollView.layer.shadowColor = UIColor.black.cgColor
        dateScrollView.layer.shadowOffset = CGSize.init(width: 0, height: -2)
        dateScrollView.layer.shadowOpacity = 0.5
        dateScrollView.layer.shadowRadius = 2
    }
    
    var isAlreadySet = false
    override func viewDidLayoutSubviews() {
        if !isAlreadySet {
            setDateView()
            setDayMoveLog(dayCountFromToday: 0)
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
            setDayMoveLog(dayCountFromToday: index)
        }
    }
    
    func setDayMoveLog(dayCountFromToday: Int) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormater.string(from: Date())
        let todayStartDate = Date.init(timeInterval: timeDifference, since: dateFormater.date(from: todayString)!)

        let from: Date = Date.init(timeInterval: TimeInterval(-60*60*24*dayCountFromToday), since: todayStartDate)
        let to: Date = Date.init(timeInterval: TimeInterval(-60*60*24*(dayCountFromToday-1)-1), since: todayStartDate)
        
        let locationLog = appDelegate.DBManager.getLocationLog(from: from, to: to)
        print(locationLog)
    }
    
    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
