//
//  SharedARObject.swift
//  WorkspaceAR
//
//  Created by Joe Crotchett on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import SceneKit

class SharedARObject: NSObject, NSCoding {
    
    var id: String
    var modelName: String
    var animation: Int
    var transform: SCNMatrix4
    
    init(id: String,
         modelName: String,
         animation: Int,
         transform: SCNMatrix4) {
        self.id = id
        self.modelName = modelName
        self.animation = animation
        self.transform = transform
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.modelName, forKey: "modelName")
        aCoder.encodeCInt(Int32(self.animation), forKey: "animation")
        aCoder.encode(self.transform, forKey: "transform")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let modelName = aDecoder.decodeObject(forKey: "modelName") as! String
        let animation = aDecoder.decodeObject(forKey: "animation") as! Int
        let transform = aDecoder.decodeObject(forKey: "transform") as! SCNMatrix4
        self.init(
            id: id,
            modelName: modelName,
            animation: animation,
            transform: transform
        )
    }
}
