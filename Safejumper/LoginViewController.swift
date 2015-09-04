//
//  LoginViewController.swift
//  Safejumper
//
//  Created by Developer on 28.04.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate, APIControllerProtocol {
    
    let api = APIController()
    let settings = SettingsController()
    
    var storeDetails: Bool = false
    var displayAllNodes: Bool = false
    
    @IBOutlet weak var txUserName: UITextField!
    
    @IBOutlet weak var txPassword: UITextField!
    
    @IBOutlet weak var uiProgressBar: UIActivityIndicatorView!
    
    @IBOutlet weak var uiLoginButton: UIButton!
    
    @IBOutlet weak var btStoreDetails: UIButton!
    
    @IBOutlet weak var btDisplayAllNodes: UIButton!
    
    @IBAction func actLoginButtonPressed(sender: AnyObject) {
        self.api.delegate = self
        self.api.loadServerList(txUserName.text!,password: txPassword.text!, allNodes: displayAllNodes)
        self.uiProgressBar.hidden = false
        self.uiProgressBar.startAnimating()
        self.uiLoginButton.enabled = false
        
        settings.saveValue(SettingsController.keyStoreUserName, value: storeDetails)
        settings.saveValue(SettingsController.keyDisplayAllNodes, value: displayAllNodes)
        
        var ss = ""
        if(storeDetails) {
            ss = txUserName.text!
        }
        settings.saveValue(SettingsController.keyUserName, value: ss)
        
        ss = ""
        if(storeDetails) {
            ss = txPassword.text!
        }
        settings.saveValue(SettingsController.keyPassword, value: ss)
        
        settings.commit()
    }
    
    @IBAction func actStoreDetailsPressed(sender: AnyObject) {
        storeDetails = !storeDetails
        updateCheckboxes()
    }
    
    @IBAction func actDisplayAllNodes(sender: AnyObject) {
        displayAllNodes = !displayAllNodes
        updateCheckboxes()
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didReceiveAPIResults(servers: [Server]) {
        dispatch_async(dispatch_get_main_queue(), {
            self.uiProgressBar.stopAnimating()
            self.uiProgressBar.hidden = true
            self.uiLoginButton.enabled = true
            if(servers.count == 0) {
                let alert: UIAlertView = UIAlertView(title: "Error", message: "Wrong login info",
                    delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                return
            }
            (self.tabBarController as! TabBarController).enableTabs(true)
            self.tabBarController?.selectedIndex = 1;
//            (self.parentViewController as! TabBarController).enableTabs(true)
            // open server selection screen
//            self.performSegueWithIdentifier("segLogin2Connection", sender: self)
        })
    }
    
    func didReceiveError(error: NSError) {
        dispatch_async(dispatch_get_main_queue(), {
            self.uiProgressBar.stopAnimating()
            self.uiProgressBar.hidden = true
            self.uiLoginButton.enabled = true
            let alert: UIAlertView = UIAlertView(title: "Error", message: "Can't connect to server: \(error.description)",
                delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        })
    }
    
    func updateCheckboxes() {
        if(storeDetails) {
            btStoreDetails.setImage(UIImage(named: "checkbox_on"), forState: UIControlState.Normal)
        }
        else {
            btStoreDetails.setImage(UIImage(named: "checkbox_off"), forState: UIControlState.Normal)
        }
        if(displayAllNodes) {
            btDisplayAllNodes.setImage(UIImage(named: "checkbox_on"), forState: UIControlState.Normal)
        }
        else {
            btDisplayAllNodes.setImage(UIImage(named: "checkbox_off"), forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiProgressBar.hidden = true
        
        storeDetails = settings.loadValue(SettingsController.keyStoreUserName, defValue: true) as! Bool
        displayAllNodes = settings.loadValue(SettingsController.keyDisplayAllNodes, defValue: false) as! Bool
        txUserName.text = settings.loadValue(SettingsController.keyUserName, defValue: "") as! String
        txPassword.text = settings.loadValue(SettingsController.keyPassword, defValue: "") as! String
        
        updateCheckboxes()
    }

}