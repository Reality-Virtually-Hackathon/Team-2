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
	
	func drawPoints() {
		let points = DataManager.shared().alignmentPoints
		guard points.count > 0 else { print("NO POINTS SENT!"); return }
		guard let cameraTransform = session.currentFrame?.camera.transform,
			let focusSquarePosition = focusSquare.lastPosition else {
				statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
				return
		}
		expandContinueButton(message: "Confirm Point Alignment")
		let vo = VirtualObject()
		let rootNode = SCNNode.init()
		
		vo.addChildNode(rootNode)
		
		
		//CGPoint.init(x: 0, y: 0)
		//let size = 0.25
		//let incomingNode = self.makeShapeWith(points: [CGPoint.init(x: size, y: size), CGPoint.init(x: -size, y: size), CGPoint.init(x: -size, y: -size), CGPoint.init(x: size, y: -size)])
		//vo.addChildNode(incomingNode)
		
		guard let (worldPosition, _, _/*onPlane*/) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition, infinitePlane: true) else {
			print("No Plane found"); return
		}
		
		vo.position = SCNVector3.init(worldPosition)
		
		var vecPoints:[SCNVector3] = []
		
		//loops through the points, drawing spheres
		for i in 0..<points.count {
			let cgp = points[i]
			let newVec = SCNVector3.init(cgp.x, 0, cgp.y)
			vecPoints.append(newVec)
			let pointNode = SCNNode()
			let pointGeometry = SCNSphere(radius: 0.007)
			let orangeMaterial = SCNMaterial()
			if i == 0 {
				orangeMaterial.diffuse.contents = UIColor.green
			} else {
				orangeMaterial.diffuse.contents = UIColor.red
			}
			pointGeometry.materials = [orangeMaterial]
			pointNode.geometry = pointGeometry
			pointNode.position = newVec
			rootNode.addChildNode(pointNode)
		}
		
		//loops through the points, adding lines between them
		for i in 0..<points.count-1 {
			let newTempNode = SCNNode()
			let newLine = newTempNode.buildLineInTwoPointsWithRotation(from: vecPoints[i],
																	   to: vecPoints[i+1],
																	   radius: 0.005,
																	   color: .cyan)
			rootNode.addChildNode(newLine)
		}
		
		virtualObjectInteraction.selectedObject = vo
		vo.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
		
		updateQueue.async {
			self.sceneView.scene.rootNode.addChildNode(vo)
		}
		
		print("Received Alignment Points")
		DataManager.shared().rootNode = rootNode
	}
	
	//incoming recieved delegates
	func receivedAlignmentPoints(points: [CGPoint]) {
		//must be client!
		let ut = DataManager.shared().userType
		guard ut == .Client else { return }
		//must be alignment!
		let state = DataManager.shared().state
		guard state == .AlignmentStage else { return }
		
		//if it is, draw the points
		drawPoints()
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
