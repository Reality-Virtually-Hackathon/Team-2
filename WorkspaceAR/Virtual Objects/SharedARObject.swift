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
    var name:String
    var animation: [String]
    var transform: SCNMatrix4
    var descriptionText: String
    var mass: Double
    var restitution:Double
    
    
    init(id: String = "",
         name: String,
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
        self.name = name
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
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let animation = aDecoder.decodeObject(forKey: "animation") as! [String]
        let transformValue = aDecoder.decodeObject(forKey: "transform") as! [Float]
        let transform = SCNMatrix4(m11: transformValue[0], m12: transformValue[1], m13: transformValue[2], m14: transformValue[3], m21: transformValue[4], m22: transformValue[5], m23: transformValue[6], m24: transformValue[7], m31: transformValue[8], m32: transformValue[9], m33: transformValue[10], m34: transformValue[11], m41: transformValue[12], m42: transformValue[13], m43: transformValue[14], m44: transformValue[15])
        let descriptionText = aDecoder.decodeObject(forKey: "descriptionText") as! String
        let mass = aDecoder.decodeObject(forKey: "mass") as! NSNumber
        let restitution = aDecoder.decodeObject(forKey: "restitution") as! NSNumber
        self.init(
            id: id,
            name: name,
            modelName: modelName,
            animation: animation,
            transform: transform,
            descriptionText: descriptionText,
            mass: mass.doubleValue,
            restitution:restitution.doubleValue
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.modelName, forKey: "modelName")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.animation, forKey: "animation")
        var transformValues = [Float]()
        transformValues.append(self.transform.m11)
        transformValues.append(self.transform.m12)
        transformValues.append(self.transform.m13)
        transformValues.append(self.transform.m14)
        
        transformValues.append(self.transform.m21)
        transformValues.append(self.transform.m22)
        transformValues.append(self.transform.m23)
        transformValues.append(self.transform.m24)
        
        transformValues.append(self.transform.m31)
        transformValues.append(self.transform.m32)
        transformValues.append(self.transform.m33)
        transformValues.append(self.transform.m34)
        
        transformValues.append(self.transform.m41)
        transformValues.append(self.transform.m42)
        transformValues.append(self.transform.m43)
        transformValues.append(self.transform.m44)
        
        aCoder.encode(transformValues, forKey: "transform")
        aCoder.encode(descriptionText, forKey: "descriptionText")
        
        aCoder.encode(NSNumber.init(value: mass), forKey: "mass")
        aCoder.encode(NSNumber.init(value: restitution), forKey: "restitution")
    }
}
