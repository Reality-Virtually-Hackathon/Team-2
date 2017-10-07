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
    
    var userType: UserType?
    
    var alignmentPoints = [CGPoint]()
    
    var rootNode: SCNNode?
    
//    var objects
    var objects = [SharedARObject]()
    
    func addObject(object: SharedARObject){
        //TODO: - Add object to root node, check ids
    }
    
}

