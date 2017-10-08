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
    
    func BuildSCNNode() -> SCNNode? {
        let node = SCNNode()
        
        let scene = SCNScene(named: "Models.scnassets/" + modelName)
        if let nodeArray = scene?.rootNode.childNodes {
            // generate child nodes
            for childNode in nodeArray {
                node.addChildNode(childNode as SCNNode)
            }
            
            // configure physics
            node.physicsBody = physicsBody
            
            // configure transform
            node.position = position
            node.rotation = rotation
            
            // configure description
            node.name = name
        }
        
        return nil
    }
}
