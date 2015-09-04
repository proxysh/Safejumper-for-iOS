//
//  PanelViewController.swift
//  Safejumper
//
//  Created by Developer on 24.06.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class PanelViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         UIApplication.sharedApplication().statusBarHidden=true;
        
        
        let url = NSURL(string: "https://proxy.sh/panel/clientarea.php")
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
}