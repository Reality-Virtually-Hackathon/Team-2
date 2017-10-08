//
//  SharedARObjectDescriptor.swift
//  WorkspaceAR
//
//  Created by Joe Crotchett on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import SceneKit

struct SharedARObjectDescriptor {
    var name: String
    var physicsBody: SCNPhysicsBody
    var position: SCNVector3
    var rotation: SCNVector4
    var modelName: String
    var description: String
    var multipleAllowed: Bool
    
    func BuildSCNNode() -> SCNNode? {
        let url = Bundle.main.url(forResource: "Models.scnassets/\(modelName)/\(modelName)", withExtension: ".scn")
        let node = SCNReferenceNode(url: url!)
        
        if let node = node {
            node.load()
            // configure physics
            node.physicsBody = physicsBody
            
            // configure transform
            node.position = position
            node.rotation = rotation
            
            // configure description
            node.name = name
            return node
        }
        
        return nil
    }
}
