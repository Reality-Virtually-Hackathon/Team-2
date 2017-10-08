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
}
