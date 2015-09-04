//
//  ConnectionSettingsViewController.swift
//  Safejumper
//
//  Created by Developer on 30.04.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class ConnectionSettingsViewController: UITableViewController {

    let protocolAndPorts:[ProtocolAndPort] = [
        ProtocolAndPort(proto: "TCP", port: "80"),
        ProtocolAndPort(proto: "TCP", port: "110"),
        ProtocolAndPort(proto: "TCP", port: "443"),
        ProtocolAndPort(proto: "TCP", port: "843"),
        ProtocolAndPort(proto: "UDP", port: "53"),
        ProtocolAndPort(proto: "UDP", port: "1194"),
        ProtocolAndPort(proto: "UDP", port: "1443"),
        ProtocolAndPort(proto: "UDP", port: "8080"),
        ProtocolAndPort(proto: "UDP", port: "9201"),
    ]
    
    let sectionHeaders:[String] = [
        "Server",
        "Protocol & Port"
    ]
    
    let cellId:String = "ConnectionTableCell"
    
    let settings = SettingsController()
    let api = APIController()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UITableViewCell
        
        switch(indexPath.section) {
        case 0:
            cell.textLabel!.text = settings.loadValue(SettingsController.keyServerName, defValue: "") as? String
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case 1:
            let port:Int = settings.loadValue(SettingsController.keyProtocolPort, defValue: 0) as! Int
            cell.textLabel?.text = protocolAndPorts[indexPath.row].proto + " " + protocolAndPorts[indexPath.row].port
            if(port == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        default:
            print("impossible case", appendNewline: false)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 1
        case 1:
            return protocolAndPorts.count
        default:
            print("impossible case", appendNewline: false)
            return 1
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.section) {
        case 0:
            self.performSegueWithIdentifier("segServerList", sender: self)
        case 1:
            settings.saveValue(SettingsController.keyProtocolPort, value: indexPath.row)
            settings.commit()
            self.tableView.reloadData()
        default:
            print("impossible case", appendNewline: false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        self.navigationItem.setRightBarButtonItem(
            UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Plain, target: self, action: "actConnectButtonPressed:"),
            animated:true)
        // server list could change since the last session, let's set settings to valid values
        let serverName:String = settings.loadValue(SettingsController.keyServerName, defValue: "") as! String
        if(serverName.isEmpty) {
            settings.saveValue(SettingsController.keyServerName, value: APIController.serverList[0].location)
            settings.commit()
        }
        let proto:Int = settings.loadValue(SettingsController.keyProtocolPort, defValue: 0) as! Int
        if(proto < 0 || proto >= protocolAndPorts.count) {
            settings.saveValue(SettingsController.keyProtocolPort, value: 0)
            settings.commit()
        }
    }
    
    func actConnectButtonPressed(sender: AnyObject) {
        let app:UIApplication = UIApplication.sharedApplication()
        
        let alert = UIAlertController(title: "Warning", message: "OpenVPN Connect needs to be installed to process .ovpn configuration files on your device. Go to OpenVPN Connect page in AppStore?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            app.openURL(NSURL(string: "https://itunes.apple.com/app/id590379981?mt=8")!)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            let server:Server = self.api.findServerByName(self.settings.loadValue(SettingsController.keyServerName, defValue: "") as! String)!
            let protocolPort:Int = self.settings.loadValue(SettingsController.keyProtocolPort, defValue: 0) as! Int
            app.openURL(NSURL(string: self.api.getOvpnConfigURL(server, proto: self.protocolAndPorts[protocolPort]))!)
        }))
        presentViewController(alert, animated: true, completion: nil)
        
    }
}