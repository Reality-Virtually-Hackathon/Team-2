//
//  Extensions.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SceneKit

extension SCNVector3 {
    // from Apples demo APP
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func float3FromPosition()-> float3{
        return float3(arrayLiteral: self.x, self.y, self.z)
    }
}


extension UIViewController{
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}

extension SCNMatrix4{
    func toFloatArray()->[Float]{
        var transformValues = [Float]()
        transformValues.append(self.m11)
        transformValues.append(self.m12)
        transformValues.append(self.m13)
        transformValues.append(self.m14)
        
        transformValues.append(self.m21)
        transformValues.append(self.m22)
        transformValues.append(self.m23)
        transformValues.append(self.m24)
        
        transformValues.append(self.m31)
        transformValues.append(self.m32)
        transformValues.append(self.m33)
        transformValues.append(self.m34)
        
        transformValues.append(self.m41)
        transformValues.append(self.m42)
        transformValues.append(self.m43)
        transformValues.append(self.m44)
        return transformValues
    }
    
    static func matrixFromFloatArray(transformValue: [Float])-> SCNMatrix4{
        return SCNMatrix4(m11: transformValue[0], m12: transformValue[1], m13: transformValue[2], m14: transformValue[3], m21: transformValue[4], m22: transformValue[5], m23: transformValue[6], m24: transformValue[7], m31: transformValue[8], m32: transformValue[9], m33: transformValue[10], m34: transformValue[11], m41: transformValue[12], m42: transformValue[13], m43: transformValue[14], m44: transformValue[15])
    }
}
