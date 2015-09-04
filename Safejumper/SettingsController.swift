//
//  SettingsController.swift
//  Safejumper
//
//  Created by Developer on 29.04.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import Foundation

class SettingsController {
    static let keyStoreUserName:String = "store-username"
    static let keyDisplayAllNodes:String = "display-all-nodes"
    static let keyUserName:String = "user-name"
    static let keyPassword:String = "password"
    static let keyServerName:String = "server-name"
    static let keyServerIndex:String = "server-index"
    static let keyProtocolPortIndex:String = "protocol-port-index"
    static let keyProtocolPort:String = "protocol-port"
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func loadValue(key:String, defValue:AnyObject) -> AnyObject {
        let value:AnyObject? = userDefaults.objectForKey(key)
//        println("load key: \(key) value: \(value)")
        if(value == nil) {
            return defValue
        }
        return value!
    }
    
    func saveValue(key:String, value:AnyObject) {
        userDefaults.setObject(value, forKey:key)
//        println("save key: \(key) value: \(value)")
    }
    
    func commit() {
        userDefaults.synchronize()
    }
}