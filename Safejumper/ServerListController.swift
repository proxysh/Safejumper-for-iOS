//
//  ViewController.swift
//  Safejumper
//
//  Created by Developer on 23.04.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class ServerListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerLabel: UILabel!
    
    let settings = SettingsController()
    
    let serverListCellId:String = "ServerListCell"
    
    static let protocolAndPorts:[ProtocolAndPort] = [
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
    
    var serverList:[Server] = []
    
    var protoScreen:Bool = false
    
    override func viewDidLoad() {
        self.serverList = APIController.serverList
        
    self.tableView.tableFooterView = UIView.new()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.serverList = APIController.serverList
        
        
        //println(self.serverList)
        if(self.serverList.count > 0)
        {
            self.tableView.reloadData()
        }
        else
        {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        if(protoScreen) {
            return ServerListController.protocolAndPorts.count
        }
        return self.serverList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ServerListCell = self.tableView.dequeueReusableCellWithIdentifier(serverListCellId) as! ServerListCell
        if(protoScreen) {
            cell.titleLabel.text = ServerListController.protocolAndPorts[indexPath.row].proto + " " + ServerListController.protocolAndPorts[indexPath.row].port
            cell.subtitleLabel.text = ""
        }
        else {
            cell.titleLabel.text = self.serverList[indexPath.row].location
            cell.subtitleLabel.text = String(format: "%.0f%%", self.serverList[indexPath.row].load)
            
            println( Int( self.serverList[indexPath.row].load ))
            
            if(Int( self.serverList[indexPath.row].load ) <= 25)
            {
              cell.myimageview?.image = UIImage(named: "green_bar.png")
            }
            else if ( Int( self.serverList[indexPath.row].load ) >= 75)
            {
               cell.myimageview?.image = UIImage(named: "red_bar.png")
            }
            else
            {
               cell.myimageview?.image = UIImage(named: "grey_bar.png")
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(protoScreen) {
            settings.saveValue(SettingsController.keyProtocolPortIndex, value: indexPath.row)
            settings.commit()
            enableProtoScreen(false)
            self.tabBarController!.selectedIndex = 2;
        }
        else {
            settings.saveValue(SettingsController.keyServerName, value: self.serverList[indexPath.row].location)
            settings.saveValue(SettingsController.keyServerIndex, value: indexPath.row)
            settings.commit()
            enableProtoScreen(true)
        }
    }
    
    func enableProtoScreen(enable:Bool) {
        protoScreen = enable
        if(enable) {
            self.headerLabel.text = "Please select desired protocol and port"
        }
        else {
            self.headerLabel.text = "Please select your desired location"
        }
        self.tableView.reloadData()
    }
    
}

