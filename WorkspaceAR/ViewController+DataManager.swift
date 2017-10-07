//
//  ViewController+DataManager.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

extension ViewController: DataManagerDelegate{
    func receivedAlignmentPoints(points: [CGPoint]) {
        print("Received Alignment Points")
    }
    
    func receivedObjectsUpdate(objects: [SharedARObject]) {
        print("Received Objects Update")
    }
    
    func receivedNewObject(object: SharedARObject) {
        print("Received New Object")
    }
    
    func newDevicesConnected(devices: [String]) {
        print("New Devices Connected")
        if devices.count > 1{
            self.statusViewController.showMessage("Devices connected: \(devices.joined(separator: ", "))")
        }else{
            self.statusViewController.showMessage("Device connected: \(devices.joined(separator: ", "))")
        }
        devicesConnectedLabel.text = "Other Devices Connected: \(DataManager.shared().allConnectedDevices.count)"
    }
    

}
