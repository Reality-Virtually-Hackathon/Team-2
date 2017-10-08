/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Methods on the main view controller for handling virtual object loading and movement
*/

import UIKit
import SceneKit

extension ViewController: VirtualObjectSelectionViewControllerDelegate {
	
    /**
     Adds the specified virtual object to the scene, placed using
     the focus square's estimate of the world-space position
     currently corresponding to the center of the screen.
     
     - Tag: PlaceVirtualObject
     */
    func placePointAlignmentNodes(_ virtualObject: VirtualObject) {
        guard let cameraTransform = session.currentFrame?.camera.transform,
            let focusSquarePosition = focusSquare.lastPosition else {
            statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
            return
        }
        
        //virtualObjectInteraction.selectedObject = virtualObject
        //virtualObject.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
		
		
		let plane = SCNPlane.init(width: 0.25, height: 0.25)
		let planeNode = SCNNode.init(geometry: plane)
		let vo = VirtualObject()
		
		//CGPoint.init(x: 0, y: 0)
		//let size = 0.25
		//let incomingNode = self.makeShapeWith(points: [CGPoint.init(x: size, y: size), CGPoint.init(x: -size, y: size), CGPoint.init(x: -size, y: -size), CGPoint.init(x: size, y: -size)])
		//vo.addChildNode(incomingNode)
		
		let points:[SCNVector3] = []
		
		let twoPointsNode1 = SCNNode()
		
		for i in 0..<points.count-1 {
			vo.addChildNode(twoPointsNode1.buildLineInTwoPointsWithRotation(
				from: points[i], to: points[i+1], radius: 0.05, color: .cyan))
		}
		
		planeNode.rotation = SCNVector4Make(1, 0, 0, -Float(Double.pi/2));
		//let planeVO = planeNode as! VirtualObject
		virtualObjectInteraction.selectedObject = vo
		vo.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
		
        updateQueue.async {
			//original:
			//self.sceneView.scene.rootNode.addChildNode(virtualObject)
            self.sceneView.scene.rootNode.addChildNode(vo)
        }
    }
    
    // MARK: - VirtualObjectSelectionViewControllerDelegate
    
    func virtualObjectSelectionViewController(_: VirtualObjectSelectionViewController, didSelectObject object: SharedARObjectDescriptor) {
        displayObjectLoadingUI()
        if let node = object.BuildSCNNode(), let rootNode = DataManager.shared().rootNode{
            DataManager.shared().loadedNodes.append(node)
            node.position = SCNVector3Make(0, 0, -0.5)
            DataManager.shared().currentObjectPlacing = node
            let extraLayerNode = SCNNode()
            extraLayerNode.addChildNode(node)
            self.sceneView.pointOfView?.addChildNode(extraLayerNode)
            print("Placed node")
            hideObjectLoadingUI()
            self.statusViewController.showMessage("Added \(object.name) to the workspace")
            self.addObjectButton.setImage(#imageLiteral(resourceName: "lockring"), for: .normal)
            self.addObjectButton.tag = 100
        }else{
            hideObjectLoadingUI()
            self.statusViewController.showMessage("Failed to add node")
        }
        
    }
    
    func virtualObjectSelectionViewController(_: VirtualObjectSelectionViewController, didDeselectObject object: SharedARObjectDescriptor) {
//        guard let objectIndex = DataManager.shared().loadedNodes.index(of: object) else {
//            fatalError("Programmer error: Failed to lookup virtual object in scene.")
//        }
        if object.multipleAllowed == false{
            var objectIndex = -1
            var objectNode: SCNNode? = nil
            for i in 0..<DataManager.shared().loadedNodes.count{
                let node = DataManager.shared().loadedNodes[i]
                if node.name == object.name{
                    objectIndex = i
                    objectNode = node
                }
            }
            guard objectIndex != -1, objectNode != nil else{
                print("UNABLE TO FIND OBJECT IN LOADED NODES")
                fatalError("Failed to find object in loaded objects")
                return
            }
            objectNode!.removeFromParentNode()
            DataManager.shared().loadedNodes.remove(at: objectIndex)
        }
//        virtualObjectLoader.removeVirtualObject(at: objectIndex)
    }

    // MARK: Object Loading UI

    func displayObjectLoadingUI() {
        // Show progress indicator.
        spinner.startAnimating()
        
        addObjectButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])

        addObjectButton.isEnabled = false
        isRestartAvailable = false
    }

    func hideObjectLoadingUI() {
        // Hide progress indicator.
        spinner.stopAnimating()

        addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])

        addObjectButton.isEnabled = true
        isRestartAvailable = true
    }
	
//	func makeShapeWith(points: [CGPoint]) -> SCNNode {
//		guard let firstPoint = points.first else { return SCNNode() }
//
//		let orangeMaterial = SCNMaterial()
//		orangeMaterial.diffuse.contents = UIColor.orange
//
//		let bez = UIBezierPath()
//		bez.move(to: firstPoint)
//		for p in points {
//			bez.addLine(to: p)
//		}
//		bez.close()
//
//		let shape = SCNShape(path: bez, extrusionDepth: 0.75)
//		shape.materials = [orangeMaterial]
//		let shapeNode = SCNNode(geometry: shape)
//		shapeNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
//		shapeNode.rotation = SCNVector4(x: -1.0, y: -1.0, z: 0.0, w: 0.0)
//
//		return shapeNode
//	}
}



//https://stackoverflow.com/questions/35002232/draw-scenekit-object-between-two-points
extension SCNNode {
	
	func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
		let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
		if length == 0 {
			return SCNVector3(0.0, 0.0, 0.0)
		}
		
		return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
		
	}
	
	func buildLineInTwoPointsWithRotation(from startPoint: SCNVector3,
										  to endPoint: SCNVector3,
										  radius: CGFloat,
										  color: UIColor) -> SCNNode {
		let w = SCNVector3(x: endPoint.x-startPoint.x,
						   y: endPoint.y-startPoint.y,
						   z: endPoint.z-startPoint.z)
		let l = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
		
		if l == 0.0 {
			// two points together.
			let sphere = SCNSphere(radius: radius)
			sphere.firstMaterial?.diffuse.contents = color
			self.geometry = sphere
			self.position = startPoint
			return self
			
		}
		
		let cyl = SCNCylinder(radius: radius, height: l)
		cyl.firstMaterial?.diffuse.contents = color
		
		self.geometry = cyl
		
		//original vector of cylinder above 0,0,0
		let ov = SCNVector3(0, l/2.0,0)
		//target vector, in new coordination
		let nv = SCNVector3((endPoint.x - startPoint.x)/2.0, (endPoint.y - startPoint.y)/2.0,
							(endPoint.z-startPoint.z)/2.0)
		
		// axis between two vector
		let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
		
		//normalized axis vector
		let av_normalized = normalizeVector(av)
		let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
		let q1 = Float(av_normalized.x) // x' * sin(angle/2)
		let q2 = Float(av_normalized.y) // y' * sin(angle/2)
		let q3 = Float(av_normalized.z) // z' * sin(angle/2)
		
		let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
		let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
		let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
		let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
		let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
		let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
		let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
		let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
		let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
		
		self.transform.m11 = r_m11
		self.transform.m12 = r_m12
		self.transform.m13 = r_m13
		self.transform.m14 = 0.0
		
		self.transform.m21 = r_m21
		self.transform.m22 = r_m22
		self.transform.m23 = r_m23
		self.transform.m24 = 0.0
		
		self.transform.m31 = r_m31
		self.transform.m32 = r_m32
		self.transform.m33 = r_m33
		self.transform.m34 = 0.0
		
		self.transform.m41 = (startPoint.x + endPoint.x) / 2.0
		self.transform.m42 = (startPoint.y + endPoint.y) / 2.0
		self.transform.m43 = (startPoint.z + endPoint.z) / 2.0
		self.transform.m44 = 1.0
		return self
	}
}
