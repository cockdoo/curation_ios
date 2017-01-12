//
//  ScreenTracking.swift
//  Curation
//
//  Created by menteadmin on 2017/01/02.
//  Copyright © 2017年 TaigaSano. All rights reserved.
//

extension UIViewController {
    open override class func initialize() {
        struct Static {
            static var token: dispatch_time_t = 0
        }
        if self !== UIViewController.self {
            return
        }
        swiftalytics_viewDidAppear(false)
    }
    
    func swiftalytics_viewDidAppear(animated: Bool) {
        swiftalytics_viewDidAppear(animated: animated)
        if !(self is UINavigationController) {
            var className = NSStringFromClass(type(of: self))
            
            
            let build = GAIDictionaryBuilder.createEventWithCategory(category.rawValue, action: action.rawValue, label: label, value: value).build() as [NSObject: AnyObject]
            GAI.sharedInstance().defaultTracker.send(build)
            
            let tracker = GAI.sharedInstance().defaultTracker
//            tracker?.set(kGAIScreenName, value: className)
            let build = GAIDictionaryBuilder.createScreenView().set("ホーム", forKey: kGAIScreenName).build() as Dictionary
            //        tracker?.send(builder?.build() as [AnyHashable : Any])
            tracker?.send(build as [NSObject : AnyObject])
        }
    }
}
