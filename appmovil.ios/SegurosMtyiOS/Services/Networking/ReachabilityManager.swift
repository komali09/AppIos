//
//  ReachabilityManager.swift
//  SegurosMtyiOS
//
//  Created by Isidro Adan Garcia Solorio  on 12/4/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager {
    
    private let hostnamePing : String = "www.google.com"
    private var reachability: Reachability?
    private var isMonitoring:Bool = false
    
    var isOnline : Bool = true
    static let shared = ReachabilityManager()
    
    private init() {
        self.reachability = Reachability(hostname: hostnamePing)
        
        self.reachability?.whenReachable = { reach in
            self.isOnline = true
        }
        
        self.reachability?.whenUnreachable = { reach in
            self.isOnline = false
        }
    }
    
    func startMonitoring() {
        do {
            if !self.isMonitoring {
                try self.reachability?.startNotifier()
                debugPrint("📡 Monitoring network!")
                self.isMonitoring = true
            }
        } catch {
            debugPrint("❌ Is not posible to start monitoring network.")
        }
    }
    
    func stopMonitoring() {
        self.reachability?.stopNotifier()
        self.isMonitoring = false
        debugPrint("⛔ Stop monitoring network!")
    }
    
    static func getWiFiAddress() -> String? {
        var address : String?
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        #if DEBUG
            return "192.168.0.1"
        #else
            return address
        #endif
        //return address
    }
}
