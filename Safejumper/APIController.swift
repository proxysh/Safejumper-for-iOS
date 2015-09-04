//
//  APIController.swift
//  Safejumper
//
//  Created by Developer on 28.04.15.
//  Copyright (c) 2015 Three Monkeys International Inc. All rights reserved.
//

import Foundation

class Server: NSObject {
    var ip:String = ""
    var location:String = ""
    var load:Float = 0
    
    init (ip:String, location:String, load:Float) {
        self.ip = ip
        self.location = location
        self.load = load
    }
    
    override var description: String {
        get {
            return "server ip=\(ip) location=\(location) load=\(load)"
        }
    }
}

struct ProtocolAndPort {
    let proto:String
    let port:String
    init(proto:String, port: String) {
        self.proto = proto
        self.port = port
    }
}

protocol APIControllerProtocol {
    func didReceiveAPIResults(servers:[Server])
    func didReceiveError(error: NSError)
}

class APIController: NSObject, NSXMLParserDelegate {
    
    static let urlTemplate:String = "https://proxy.sh/panel/confgen.php?api=1&os=iOS&region=Specific&specificserver[]=%%server-ip%%&port=%%server-port%%/%%server-proto%%"

    var delegate: APIControllerProtocol?
    
    var parser = NSXMLParser()
    
    var showAllNodes:Bool = false
    
    var element = NSString()
    var parsedServer:Server = Server(ip:"",location:"",load:0)
    var address = NSMutableString()
    var location = NSMutableString()
    var load = NSMutableString()
    
    static var serverList:[Server] = []
//    static var ovpnTemplate:String = ""
    
    func loadServerList(login:String, password:String, allNodes:Bool) {
        
        self.showAllNodes = allNodes
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://proxy.sh/access.php")!)
        request.HTTPMethod = "POST"
//        let postString = "u=fszplkar&p=oh5kOL171f"
        let postString = "u=\(login)&p=\(password)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data,response,error) in
            if(error != nil) {
                self.delegate?.didReceiveError(error!)
                return
            }
//            let text = NSString(data:data!, encoding:NSUTF8StringEncoding)
//            print(text)
            self.parser = NSXMLParser(data: data!)
            self.parser.delegate = self
            APIController.serverList = []
            self.parser.parse()
            self.delegate?.didReceiveAPIResults(APIController.serverList)
        }
        
        task.resume()
    }
    
   // func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String])
        func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        element = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if element.isEqualToString("address") {
            address.appendString(string!)
        }
        else if element.isEqualToString("location") {
            location.appendString(string!)
        }
        else if element.isEqualToString("server_load") {
            load.appendString(string!)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString("server") {
            address = NSMutableString(string: address.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            location = NSMutableString(string: location.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            load = NSMutableString(string: load.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
            let locationString = location as String
            let isHub:Bool = locationString.rangeOfString(" Hub") != nil
            if(self.showAllNodes || isHub) {
                APIController.serverList.append(Server(ip: address as String, location: location as String, load: load.floatValue))
            }
            address = ""
            location = ""
            load = ""
        }
    }

    func getOvpnConfigURL(server:Server, proto:ProtocolAndPort) -> String {
        var rez:String = APIController.urlTemplate.stringByReplacingOccurrencesOfString("%%server-proto%%", withString: proto.proto)
        rez = rez.stringByReplacingOccurrencesOfString("%%server-ip%%", withString: server.ip)
        rez = rez.stringByReplacingOccurrencesOfString("%%server-port%%", withString: proto.port)
        print(rez)
        return rez
    }

    func findServerByName(serverName:String) -> Server? {
        for server in APIController.serverList {
            if(server.location == serverName) {
                return server
            }
        }
        return nil
    }
}