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

enum State{
    case FindingPlane
    case AlignmentStage
    case Creative
}

protocol DataManagerDelegate {
    func receivedAlignmentPoints(points: [CGPoint])
    func receivedObjectsUpdate(objects: [SharedARObject])
    func receivedNewObject(object: SharedARObject)
    func newDevicesConnected(devices: [String])
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
        initiateObjectStore()
    }
    
    var solarSystemObjects = [SharedARObjectDescriptor]()
    var chessObjects = [SharedARObjectDescriptor]()
    var constructionObjects = [SharedARObjectDescriptor]()
    
    
    var connectivity = ConnectivityManager()

    var allConnectedDevices = [String]()
    
    var userType: UserType?
    var state: State = State.AlignmentStage
    
    var alignmentSCNNodes = [SCNNode]()
    var alignmentPoints = [CGPoint]()
    
    var rootNode: SCNNode?
    var loadedNodes = [SCNNode]()
    
    var objects = [SharedARObject]()
    
    func sendObject(object: SharedARObject){
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        connectivity.sendData(data: objectData)
    }
    
    func updateObject(object: SharedARObject){
        if let root = rootNode{
            if let node = root.childNode(withName: object.id, recursively: true){
                node.transform = object.transform
                
            }else{
                let pointNode = SCNNode()
                let pointGeometry = SCNSphere(radius: 0.015)
                let orangeMaterial = SCNMaterial()
                orangeMaterial.diffuse.contents = UIColor.orange
                pointGeometry.materials = [orangeMaterial]
                pointNode.geometry = pointGeometry
                
                pointNode.transform = object.transform
                pointNode.name = object.id
                //TODO: - Animated addition
                root.addChildNode(pointNode)
            }
        }
    }
    
    func removeObject(object:SharedARObject){
        if let root = rootNode{
            if let node = root.childNode(withName: object.id, recursively: true){
                //TODO: - Animated remove
                node.removeFromParentNode()
            }
        }
        
    }
    
    func broadcastAlignmentPoints(){
        guard userType == .Host else {
            print("Not host, don't broadcast points")
            return
        }
        guard state == .Creative else{
            print("Not finished picking alignment points")
            return
        }
        let pointData = NSKeyedArchiver.archivedData(withRootObject: alignmentPoints)
        connectivity.sendData(data: pointData)
    }
    
    func fullReset(){
        if let node = self.rootNode{
            node.removeFromParentNode()
        }
        alignmentSCNNodes = [SCNNode]()
        alignmentPoints = [CGPoint]()
        objects = [SharedARObject]()
        allConnectedDevices = [String]()
        state = .AlignmentStage
        userType = nil
    }
    
}

extension DataManager: ConnectivityManagerDelegate{
    
    func connectedDevicesChanged(manager: ConnectivityManager, connectedDevices: [String]) {
        print("--- Connected Devices Changed ---")
        var newDevices = [String]()
        for device in connectedDevices{
            if !self.allConnectedDevices.contains(device){
                newDevices.append(device)
            }
        }
        print("New Devices: \(newDevices)")
        if newDevices.count > 0{
            self.broadcastAlignmentPoints()
            for object in self.objects{
                self.updateObject(object: object)
            }
        }
        self.allConnectedDevices  = connectedDevices
        DispatchQueue.main.async {
            self.delegate?.newDevicesConnected(devices: newDevices)
        }
    }
	
    func dataReceived(manager: ConnectivityManager, data: Data) {
		
		print("Received Data" )
		DispatchQueue.main.async {
			let object = NSKeyedUnarchiver.unarchiveObject(with: data)
			if let newAlignmentPoints = object as? [CGPoint]{
                if newAlignmentPoints != self.alignmentPoints{
					self.alignmentPoints = newAlignmentPoints
					self.delegate?.receivedAlignmentPoints(points: self.alignmentPoints)
                }
			}
			if let newObject = object as? SharedARObject{
				self.updateObject(object: newObject)
			}
		}
    }
}

extension DataManager{
    
    
    func initiateObjectStore(){
        solarSystemObjects = [SharedARObjectDescriptor]()
        chessObjects = [SharedARObjectDescriptor]()
        constructionObjects = [SharedARObjectDescriptor]()
        
        solarSystemObjects.append(SharedARObjectDescriptor(name: "Sun", physicsBody: SCNPhysicsBody(), position: SCNVector3Zero, rotation: SCNVector4Zero, modelName: "candle", description: "The sun is the center of our solar system.", multipleAllowed: false))
        solarSystemObjects.append(SharedARObjectDescriptor(name: "Mercury", physicsBody: SCNPhysicsBody(), position: SCNVector3Zero, rotation: SCNVector4Zero, modelName: "cup", description: "Mercury is a cool planet.", multipleAllowed: false))
        print(VirtualObject.availableObjects)
    }
    
    
}

