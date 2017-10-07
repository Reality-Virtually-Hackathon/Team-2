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
            let orangeMaterial = SCNMaterial()
            orangeMaterial.diffuse.contents = UIColor.red
            pointGeometry.materials = [orangeMaterial]
            pointNode.geometry = pointGeometry
            
            if DataManager.shared().alignmentSCNNodes.count > 0 {
                let rootPosition = DataManager.shared().rootNode!.position
                let nodePosition = SCNVector3Make(worldPosition.x - rootPosition.x, 0, worldPosition.z - rootPosition.z)
                
//                pointNode.position = SCNVector3Make(worldPosition.x, 0, worldPosition.z)
                pointNode.position = nodePosition
            }else{
                let newRootNode = SCNNode()
                newRootNode.position = SCNVector3Make(worldPosition.x, worldPosition.y, worldPosition.z)
                self.sceneView.scene.rootNode.addChildNode(newRootNode)
                DataManager.shared().rootNode = newRootNode
                pointNode.position = SCNVector3Make(0, 0, 0)
            }
            DataManager.shared().alignmentPoints.append(CGPoint(x: Double(pointNode.position.x), y: Double(pointNode.position.z)))
            DataManager.shared().alignmentSCNNodes.append(pointNode)
            print("Alignment Points- \(DataManager.shared().alignmentPoints))")
                
            DataManager.shared().rootNode!.addChildNode(pointNode)
        }else{
            self.statusViewController.showMessage("Point not detected on plane")
        }
        
    }
    
    
}
