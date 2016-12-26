//
//  Tutorial ViewController.swift
//  Mybousainote
//
//  Created by menteadmin on 2016/04/10.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, LocationManagerDelegate, UIScrollViewDelegate {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tutorialScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    @IBOutlet weak var mainButton: UIButton!
//    let tracker = GAI.sharedInstance().defaultTracker
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        appDelegate.LManager.delegate = self
        mainButton.layer.cornerRadius = 4
        mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: (mainButton.titleLabel?.font.pointSize)!)
        
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        
        tutorialScrollView.delegate = self
        
        let tw = tutorialScrollView.frame.width
        let th = tutorialScrollView.frame.height
        tutorialScrollView.contentSize = CGSize.init(width: tw * 3, height: th)
        
        let page1 = TutorialPage1.instance()
        let page2 = TutorialPage2.instance()
        let page3 = TutorialPage3.instance()
        page1.frame = CGRect.init(x: 0, y: 0, width: tw, height: th)
        page2.frame = CGRect.init(x: tw, y: 0, width: tw, height: th)
        page3.frame = CGRect.init(x: tw * 2, y: 0, width: tw, height: th)
        tutorialScrollView.addSubview(page1)
        tutorialScrollView.addSubview(page2)
        tutorialScrollView.addSubview(page3)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        setBottomViewStyle(index: index)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        setBottomViewStyle(index: index)
    }
    
    func setBottomViewStyle(index: Int) {
        pageControll.currentPage = index
        if index == 2 {
            mainButton.setTitle("はじめる", for: .normal)
        }else {
            mainButton.setTitle("次へ", for: .normal)
        }
    }
    
    @IBAction func changePage(_ sender: Any) {
        print("changePage")
    }
    
    @IBAction func touchedMainButton(_ sender: Any) {
        if pageControll.currentPage == 0 {
            tutorialScrollView.setContentOffset(CGPoint.init(x: tutorialScrollView.frame.width, y: 0), animated: true)
        }else if pageControll.currentPage == 1 {
            tutorialScrollView.setContentOffset(CGPoint.init(x: tutorialScrollView.frame.width * 2, y: 0), animated: true)
        }else if pageControll.currentPage == 2 {
            appDelegate.LManager.requestAuthorization()
        }
    }
    
    func touchedUseNotificaitonButton() {
        appDelegate.NManager.registerUserNotificationSettings()
        tutorialScrollView.setContentOffset(CGPoint.init(x: tutorialScrollView.frame.width * 2, y: 0), animated: true)
    }
    
    func touchedNoUseNotificationButton() {
        tutorialScrollView.setContentOffset(CGPoint.init(x: tutorialScrollView.frame.width * 2, y: 0), animated: true)
    }
    
    func locationManager(acceptAuthorization message: String) {
        transitionToTopView()
    }
    
    
    func locationManager(deniedAuthorization message: String) {
        transitionToTopView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trackingScreen()
    }
    
    
    
    
    //スクリーンをトラッキング
    func trackingScreen() {
        /*tracker.set(kGAIScreenName, value: "チュートリアル")
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])*/
    }
    
    //トップ画面へ遷移
    func transitionToTopView() {
        let ud = UserDefaults.standard
        ud.set(false, forKey: "FIRST_LAUNCH")
        ud.synchronize()
        
        print("トップ画面へ遷移")
        let storyboard = UIStoryboard(name: "Top", bundle: nil)
        let modalView: UIViewController! = storyboard.instantiateInitialViewController()
//        self.navigationController?.pushViewController(nextView, animated: true)
        self.present(modalView, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
