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

protocol DataManagerDelegate {
    func receivedAlignmentPoints(points: [CGPoint])
    func receivedObjectsUpdate(objects: [SharedARObject])
    func receivedNewObject(object: SharedARObject)
}

class DataManager {
    
    var delegate : DataManagerDelegate?
    
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
    
    var alignmentSCNVectors = [SCNVector3]()
    var alignmentPoints = [CGPoint]()
    
    var rootNode: SCNNode?
    
//    var objects
    var objects = [SharedARObject]()
    
    func addObject(object: SharedARObject){
        //TODO: - Add object to root node, check ids
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendTestString()
    }
    
    func broadcastAlignmentPoints(){
        let pointData = NSKeyedArchiver.archivedData(withRootObject: alignmentPoints)
        connectivity.sendData(data: pointData)
    }
    
}

extension DataManager: ConnectivityManagerDelegate{
    
    func connectedDevicesChanged(manager: ConnectivityManager, connectedDevices: [String]) {
        print("--- Connected Devices Changed ---")
        print("New Devices: \(connectedDevices)")
    }
    
    func dataReceived(manager: ConnectivityManager, data: Data) {
        print("Received Data" )
        let object = NSKeyedUnarchiver.unarchiveObject(with: data)
        if let newAlignmentPoints = object as? [CGPoint]{
            self.alignmentPoints = newAlignmentPoints
            delegate?.receivedAlignmentPoints(points: self.alignmentPoints)
        }
        if let newObject = object as? SharedARObject{
            
        }
    }
    
}

