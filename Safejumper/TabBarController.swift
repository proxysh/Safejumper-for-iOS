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
    
//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        return true
////        return connected || viewController.view.tag == 1
//    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        // tags for tabs view controllers: 1-login, 2-settings, 3-import, 4-panel
        
        // when not logged, pressing on settings or import opens login tab
        if !connected && (viewController.view.tag == 2 || viewController.view.tag == 3) {
            tabBarController.selectedIndex = 1;
            return
        }
        
        // reset settings tab when taping login tab
        if(viewController.view.tag == 1) {
            let tab:ServerListController = viewControllers![1] as! ServerListController
            tab.enableProtoScreen(false)
        }
        
        // switch login/logout labels on login tab
        if(viewController.view.tag == 1 && connected) {
            enableTabs(true)
        }
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
