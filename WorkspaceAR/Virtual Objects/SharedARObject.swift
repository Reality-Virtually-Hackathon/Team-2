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
    var animation: [String]
    var transform: SCNMatrix4
    var descriptionText: String
    var mass: Double
    var restitution:Double
    
    
    init(id: String = "",
        modelName: String,
        animation: [String],
        transform: SCNMatrix4, descriptionText: String, mass: Double, restitution:Double) {
        if id == ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"
            self.id = dateFormatter.string(from: Date()) + "\(CACurrentMediaTime())"
        }else{
            self.id = id
        }
        self.modelName = modelName
        self.animation = animation
        self.transform = transform
        self.descriptionText = descriptionText
        self.mass = mass
        self.restitution = restitution
    }
    
    // MARK: NSCoding
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let modelName = aDecoder.decodeObject(forKey: "modelName") as! String
        let animation = aDecoder.decodeObject(forKey: "animation") as! [String]
        let transform = aDecoder.decodeObject(forKey: "transform") as! SCNMatrix4
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as! String
        let mass = aDecoder.decodeObject(forKey: "mass") as! Double
        let restitution = aDecoder.decodeObject(forKey: "restitution") as! Double
        self.init(
            id: id,
            modelName: modelName,
            animation: animation,
            transform: transform,
            descriptionText: descriptionText,
            mass: mass,
            restitution:restitution
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.modelName, forKey: "modelName")
        aCoder.encode(self.animation, forKey: "animation")
        aCoder.encode(self.transform, forKey: "transform")
        aCoder.encode(descriptionText, forKey: "descriptionText")
        aCoder.encode(mass, forKey: "mass")
        aCoder.encode(restitution, forKey: "restitution")
    }
}
