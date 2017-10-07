//
//  DataManager.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SceneKit

enum UserType {
    case Host
    case Client
}

class DataManager {
    static var sharedInstance: DataManager = {
        let dataManager = DataManager()
        return dataManager
    }()
    
    class func shared() -> DataManager {
        return sharedInstance
    }
    
    init(){
        connectivity.delegate = self
    }
    
    var connectivity = ConnectivityManager()
    
    var userType: UserType?
    
    var alignmentPoints = [CGPoint]()
    
    var rootNode: SCNNode?
    
//    var objects
    var objects = [SharedARObject]()
    
    func addObject(object: SharedARObject){
        //TODO: - Add object to root node, check ids
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendTestString()
    }
    
}

extension DataManager: ConnectivityManagerDelegate{
    
    func connectedDevicesChanged(manager: ConnectivityManager, connectedDevices: [String]) {
        print("--- Connected Devices Changed ---")
        print("New Devices: \(connectedDevices)")
    }
    
    func dataReceived(manager: ConnectivityManager, data: Data) {
        print("Received Data" )
    }
    
}

