//
//  ViewContoller+Host.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import ARKit

extension ViewController{
    
    @objc func handleAddPointTap(gestureRecognize: UITapGestureRecognizer) {
        print("Add Point tapped")
        //        guard !addObjectButton.isHidden && !virtualObjectLoader.isLoading else { return }
        print("Adding point with hittest")
        
        
        guard let (worldPosition, _, onPlane) = sceneView.worldPosition(fromScreenPosition: gestureRecognize.location(in: sceneView), objectPosition: focusSquare.lastPosition, infinitePlane: true) else {
            print("No Plane found")
            return
        }
        print("World position - \(worldPosition)")
        if onPlane{
            self.statusViewController.showMessage("Point added")
            let pointNode = SCNNode()
            let pointGeometry = SCNSphere(radius: 0.006)
            pointGeometry.firstMaterial?.ambient.contents = UIColor.orange
            pointNode.geometry = pointGeometry
            
            if DataManager.shared().alignmentSCNVectors.count > 0 {
                pointNode.position = SCNVector3Make(worldPosition.x, DataManager.shared().alignmentSCNVectors.last!.y, worldPosition.z)
            }else{
                pointNode.position = SCNVector3Make(worldPosition.x, worldPosition.y, worldPosition.z)
            }
            DataManager.shared().alignmentPoints.append(CGPoint(x: Double(pointNode.position.x), y: Double(pointNode.position.y)))
            DataManager.shared().alignmentSCNVectors.append(pointNode.position)
            print("Alignment Points- \(DataManager.shared().alignmentPoints))")
                
            self.sceneView.scene.rootNode.addChildNode(pointNode)
        }else{
            self.statusViewController.showMessage("Point not detected on plane")
        }
        
    }
    
    
}
