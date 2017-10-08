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
        if DataManager.shared().state != State.AlignmentStage{
            print("Not in alignment stage, ")
            return
        }
        
        if DataManager.shared().userType != .Host{
            print("Not Host")
            return
        }
        
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
            let redMaterial = SCNMaterial()
            redMaterial.diffuse.contents = UIColor.red
            pointGeometry.materials = [redMaterial]
            pointNode.geometry = pointGeometry
            
            if DataManager.shared().alignmentSCNNodes.count > 0 {
                let rootPosition = DataManager.shared().rootNode!.position
                let nodePosition = SCNVector3Make(worldPosition.x - rootPosition.x, 0, worldPosition.z - rootPosition.z)
                pointNode.position = nodePosition
            }else{
                let newRootNode = SCNNode()
                newRootNode.position = SCNVector3Make(worldPosition.x, worldPosition.y, worldPosition.z)
                self.sceneView.scene.rootNode.addChildNode(newRootNode)
                DataManager.shared().rootNode = newRootNode
                pointNode.position = SCNVector3Make(0, 0, 0)
                let greenMaterial = SCNMaterial()
                greenMaterial.diffuse.contents = UIColor.green
                pointGeometry.materials = [greenMaterial]
                pointNode.geometry = pointGeometry
                pointNode.name = "first-alignment-node"
            }
            DataManager.shared().alignmentPoints.append(CGPoint(x: Double(pointNode.position.x), y: Double(pointNode.position.z)))
            DataManager.shared().alignmentSCNNodes.append(pointNode)
            print("Alignment Points- \(DataManager.shared().alignmentPoints))")
            DataManager.shared().rootNode!.addChildNode(pointNode)
            if DataManager.shared().alignmentSCNNodes.count > 2{
                self.expandContinueButton(message: "Confirm Alignment Points")
            }
            
        }else{
            self.statusViewController.showMessage("Point not detected on plane")
        }
        
    }
    
    
}
