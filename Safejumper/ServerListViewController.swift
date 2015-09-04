//
//  ViewController.swift
//  Safejumper
//
//  Created by Developer on 23.04.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import UIKit

class ServerListViewController: UITableViewController {
    
    let settings = SettingsController()
    
    let serverListCellId:String = "ServerListCell"
    
    var serverList:[Server] = []
    
    override func viewDidLoad() {
        self.serverList = APIController.serverList
    }
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serverList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ServerListCell {
        let cell:ServerListCell = self.tableView.dequeueReusableCellWithIdentifier(serverListCellId) as! ServerListCell
        cell.titleLabel!.text = self.serverList[indexPath.row].location
        cell.subtitleLabel?.text = String(format: "load: %.2f%%", self.serverList[indexPath.row].load)
        
        
//        let selectedServer:String = settings.loadValue(SettingsController.keyServerName, defValue: "") as! String
//        if(selectedServer == serverList[indexPath.row].location) {
//            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        settings.saveValue(SettingsController.keyServerName, value: serverList[indexPath.row].location)
        settings.commit()
        self.tableView.reloadData()
    }
    
}

