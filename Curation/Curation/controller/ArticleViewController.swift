//
//  ArticleViewController.swift
//  Curation
//
//  Created by menteadmin on 2016/10/11.
//  Copyright © 2016年 TaigaSano. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    //Commons
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let ud = NSUserDefaults.standardUserDefaults()
    let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        print(appDelegate.global.selectedArticle)
        let article = appDelegate.global.selectedArticle
        
        let url = NSURL(string : article["url"] as! String)
        let urlRequest = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
    }
    
    @IBAction func touchedBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
