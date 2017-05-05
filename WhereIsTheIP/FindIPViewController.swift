//
//  FindIPViewController.swift
//  WhereIsTheIP
//
//  Created by Pansit Wattana on 4/27/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FindIPViewController: UIViewController {

    @IBOutlet weak var inputIP: UITextField!
    
    var postal = "x"
    var city = "x"
    var longitude = 0.0
    var country = "x"
    var continent = "x"
    var stateAbbr = "x"
    var latitude = 0.0
    var ds = "x"
    var state = "x"
    var ip = "x"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let addr = getWiFiAddress() {
//            print(addr)
//        } else {
//            print("No WiFi address")
//        }
        // Do any additional setup after loading the view.
    }

    @IBAction func findIP(_ sender: Any) {
        getLocation(ip: inputIP.text!, { (error, json) in
            if error != nil {
                print(error!)
            }
            else {
                print(json!)
                self.parseJson(json: json!)
                self.showMap(latitude: self.latitude, longtitude: self.longitude)
            }
        })
    }
    
    func updateView() {
        print(country)
    }
    
    func showMap(latitude: Double, longtitude: Double) {
        let url = URL(string: "https://www.google.com/maps?q=\(latitude),\(longitude)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func parseJson(json: JSON) {
        if let res = json["RestResponse"]["result"].dictionary {
            if let postal = res["postal"]?.string {
                self.postal = postal
            }
            
            if let city = res["city"]?.string {
                self.city = city
            }
            
            if let longitude = res["longitude"]?.string {
                self.longitude = Double(longitude)!
            }
            
            if let latitude = res["latitude"]?.string {
                self.latitude = Double(latitude)!
            }
            
            if let country = res["country"]?.string {
                self.country = country
            }
            
            if let ip = res["ip"]?.string {
                self.ip = ip
            }
        }
    }
    
    func getLocation(ip: String, _ completion: @escaping (_ error: NSError?, _ json: JSON?) -> Void) {
        
        let url = "http://geo.groupkt.com/ip/\(ip)/json"
        
        print("get ip From \(ip) url: \(url)")
        
        Alamofire.request(url).validate().responseJSON { (response) in
            do {
                let searchJson = JSON(data: response.data!)
                let error = response.error
                completion(error as NSError?, searchJson)
            }
        }
    }
    
    
//    {
//    "RestResponse": {
//    "result": {
//    "countryIso2": "US",
//    "stateAbbr": "CA",
//    "postal": "94043",
//    "continent": "North America",
//    "state": "California",
//    "longitude": "-122.0574",
//    "latitude": "37.4192",
//    "ds": "II",
//    "network": "AS15169 Google Inc.",
//    "city": "Mountain View",
//    "country": "United States",
//    "ip": "172.217.3.14"
//    }
//    }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getWiFiAddress() -> String? {
//        var address : String?
//        
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == 0 else { return nil }
//        guard let firstAddr = ifaddr else { return nil }
//        
//        // For each interface ...
//        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//            let interface = ifptr.pointee
//            
//            // Check for IPv4 or IPv6 interface:
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//                
//                // Check interface name:
//                let name = String(cString: interface.ifa_name)
//                if  name == "en0" {
//                    
//                    // Convert interface address to a human readable string:
//                    var addr = interface.ifa_addr.pointee
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//        
//        return address
//    }
}
