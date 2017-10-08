//
//  ViewControllerAlignment.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SceneKit

extension ViewController{
    
    func endAlignmentMode(){
        
        //Hiding all nodes but origin
        if let firstNode = DataManager.shared().alignmentSCNNodes.first {
            
            let animationDuration = 1.5
            for node in DataManager.shared().alignmentSCNNodes {
                if node != firstNode{
                    self.delay(animationDuration, closure: {
                        node.removeFromParentNode()
                    })
                    let fadeAnimation = CABasicAnimation(keyPath: "opacity")
                    fadeAnimation.fromValue = 1.0
                    fadeAnimation.toValue = 0.0
                    fadeAnimation.duration = animationDuration + 0.1
                    fadeAnimation.isRemovedOnCompletion = false
                    node.addAnimation(fadeAnimation, forKey: "opacity")
                }
            }
            DataManager.shared().alignmentSCNNodes = [firstNode]
        }
    }
    
    
}
