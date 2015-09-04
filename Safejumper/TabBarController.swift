//
//  TabBarController.swift
//  Safejumper
//
//  Created by Developer on 20.06.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var connected:Bool = false

/*
    func enableTabs(connected: Bool) {
        (tabBar.items![0] as! UITabBarItem).enabled = true
        (tabBar.items![1] as! UITabBarItem).enabled = connected
        (tabBar.items![2] as! UITabBarItem).enabled = connected
    
        (tabBar.items![3] as! UITabBarItem).enabled = connected
    }
*/
    
    override func viewDidLoad() {
        delegate = self
        tabBar.tintColor = UIColor(red: 201.0/255.0, green: 0.0, blue: 31.0/255.0, alpha: 1.0)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        
      
        println(tabBarController.selectedIndex)
        println(viewController.view.tag)
        
        
        return connected //|| viewController.view.tag == 1
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if(viewController.view.tag != 1) {
        
        let tab:ServerListController = viewControllers![1] as! ServerListController
        tab.enableProtoScreen(false)
            
        }
        
        if(viewController.view.tag == 1) {
            
           enableTabs(false)
            
        }
//        else if(viewController.view.tag == 2) {
//            let tab:ServerListController = viewController as! ServerListController
//            tab.enableProtoScreen(false)
//        }
    }
    
    func resetProtoScreen() {
        
    }
    
    func enableTabs(connected:Bool) {
        self.connected = connected
        if(connected) {
            (tabBar.items![0] as! UITabBarItem).title = "Log Out"
            (tabBar.items![0] as! UITabBarItem).image = UIImage(named: "logout.png")
        }
        else {
            (tabBar.items![0] as! UITabBarItem).title = "Log In"
            (tabBar.items![0] as! UITabBarItem).image = UIImage(named: "login_btn.png")
        }
    }
}
