//
//  ImportViewController.swift
//  Safejumper
//
//  Created by Admin on 15.07.15.
//  Copyright © 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {
    
    @IBOutlet var serverLabel: UILabel!
    @IBOutlet var loadLabel: UILabel!
    @IBOutlet var pingLabel: UILabel!
    
    let api = APIController()
    let settings = SettingsController()
    let app:UIApplication = UIApplication.sharedApplication()
    
    var serverList:[Server] = []
    
    var serverIndx:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.serverList = APIController.serverList
        let protocolPort:Int = self.settings.loadValue(SettingsController.keyProtocolPortIndex, defValue: 0) as! Int
        serverIndx = settings.loadValue(SettingsController.keyServerIndex, defValue: 0) as! Int
        serverLabel.text = self.serverList[serverIndx].location + " ("+getProtoLabel(ServerListController.protocolAndPorts[protocolPort])+")"
        loadLabel.text = String(format: "Load: %.0f%%", self.serverList[serverIndx].load)
    }
    
    @IBAction func actConnectButtonPressed(sender: AnyObject) {
        let installed:Bool = app.canOpenURL(NSURL(string: "openvpn://")!)
        
        if(installed == false) {
            let alert = UIAlertController(title: "Warning", message: "Safejumper needs OpenVPN Connect installed to work. Have you installed it already?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "No, point me to it in the Appstore.", style: .Default, handler: { (action: UIAlertAction!) in
                app.openURL(NSURL(string: "https://itunes.apple.com/app/id590379981?mt=8")!)
            }))
            
            alert.addAction(UIAlertAction(title: "Yes, I got it, point me to the config.", style: .Default, handler: { (action: UIAlertAction!) in
                self.openConfigURL()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.openConfigURL()
        }
    }

    func openConfigURL() {
        let server:Server = self.serverList[self.settings.loadValue(SettingsController.keyServerIndex, defValue: 0) as! Int]
        let protocolPort:Int = self.settings.loadValue(SettingsController.keyProtocolPortIndex, defValue: 0) as! Int
        app.openURL(NSURL(string: self.api.getOvpnConfigURL(server, proto: ServerListController.protocolAndPorts[protocolPort]))!)
    }
    
    func getProtoLabel(pap:ProtocolAndPort) -> String {
        return pap.proto + " " + pap.port
    }
}
