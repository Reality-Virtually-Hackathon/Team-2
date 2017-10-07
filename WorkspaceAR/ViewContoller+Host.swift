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
        
        guard let (worldPosition, _ /*planeAnchor*/, _) = sceneView.worldPosition(fromScreenPosition: gestureRecognize.location(in: sceneView), objectPosition: focusSquare.lastPosition) else {
            print("No Plane found")
            return
        }
        print("World position - \(worldPosition)")
//        planeAnchor?.center
//        sceneView.hitTest(gestureRecognize.location(in: sceneView), types: ARHitTestResult.c)
//        let planeNode = sceneView.node(for: planeAnchor!)
//        print("Plane Center - \(planeNode?.position)")
//
//        let hitTestResults = sceneView.hitTestWithInfiniteHorizontalPlane(gestureRecognize.location(in: sceneView), (planeNode?.position.float3FromPosition())!)
//
//
//        if let pointLocation = hitTestResults{
            let pointNode = SCNNode()
            let pointGeometry = SCNSphere(radius: 0.01)
            pointGeometry.firstMaterial?.ambient.contents = UIColor.orange
        
            pointNode.geometry = pointGeometry
            
            
            pointNode.position = SCNVector3Make(worldPosition.x, worldPosition.y, worldPosition.z)
            self.sceneView.scene.rootNode.addChildNode(pointNode)
//            planeNode?.addChildNode(pointNode)
        
//            print("Point found - \(pointLocation)")
//        }
        
    }
    

}
