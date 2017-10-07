//
//  ViewController+DataManager.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SceneKit

extension ViewController: DataManagerDelegate{
	
	func receivedAlignmentPoints(points: [CGPoint]) {
		guard points.count > 0 else { print("NO POINTS SENT!"); return }
		guard let cameraTransform = session.currentFrame?.camera.transform,
			let focusSquarePosition = focusSquare.lastPosition else {
				statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
				return
		}

		let plane = SCNPlane.init(width: 0.25, height: 0.25)
		let planeNode = SCNNode.init(geometry: plane)
		let vo = VirtualObject()
		
		
		//CGPoint.init(x: 0, y: 0)
		//let size = 0.25
		//let incomingNode = self.makeShapeWith(points: [CGPoint.init(x: size, y: size), CGPoint.init(x: -size, y: size), CGPoint.init(x: -size, y: -size), CGPoint.init(x: size, y: -size)])
		//vo.addChildNode(incomingNode)
		
		guard let (worldPosition, _, _/*onPlane*/) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition, infinitePlane: true) else {
			print("No Plane found"); return
		}
		vo.position = SCNVector3.init(worldPosition)
		
		var vecPoints:[SCNVector3] = []
		
		for cgp in points {
			print(cgp)
			let newVec = SCNVector3.init(cgp.x, 0, cgp.y)
			vecPoints.append(newVec)
			let pointNode = SCNNode()
			let pointGeometry = SCNSphere(radius: 0.007)
			let orangeMaterial = SCNMaterial()
			orangeMaterial.diffuse.contents = UIColor.red
			pointGeometry.materials = [orangeMaterial]
			pointNode.geometry = pointGeometry
			pointNode.position = newVec
			vo.addChildNode(pointNode)
		}
		
		
		for i in 0..<points.count-1 {
			let newTempNode = SCNNode()
			let newLine = newTempNode.buildLineInTwoPointsWithRotation(from: vecPoints[i],
														 to: vecPoints[i+1],
														 radius: 0.005,
														 color: .cyan)
			vo.addChildNode(newLine)
		}
		
//		planeNode.rotation = SCNVector4Make(1, 0, 0, -Float(Double.pi/2));
		//let planeVO = planeNode as! VirtualObject
		virtualObjectInteraction.selectedObject = vo
		vo.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
		
		updateQueue.async {
			//original:
			//self.sceneView.scene.rootNode.addChildNode(virtualObject)
			self.sceneView.scene.rootNode.addChildNode(vo)
		}
		
        print("Received Alignment Points")
    }
    
    func receivedObjectsUpdate(objects: [SharedARObject]) {
        print("Received Objects Update")
    }
    
    func receivedNewObject(object: SharedARObject) {
        print("Received New Object")
    }
    
    func newDevicesConnected(devices: [String]) {
        print("New Devices Connected")
        if devices.count > 1{
            self.statusViewController.showMessage("Devices connected: \(devices.joined(separator: ", "))")
        }else{
            self.statusViewController.showMessage("Device connected: \(devices.joined(separator: ", "))")
        }
        devicesConnectedLabel.text = "Other Devices Connected: \(DataManager.shared().allConnectedDevices.count)"
    }
    

}
