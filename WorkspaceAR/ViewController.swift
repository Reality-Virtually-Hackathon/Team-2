/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var sceneView: VirtualObjectARView!
    
    @IBOutlet weak var addObjectButton: UIButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var continueButtonHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - UI Elements
    
    var focusSquare = FocusSquare()
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
    }()
    
    @IBOutlet weak var devicesConnectedLabel: UILabel!
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    var alignmentPointInstructionsShown = false
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "com.example.apple-samplecode.arkitexample.serialSceneKitQueue")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
		
		//debugging
//        sceneView.showsStatistics = true
		
        // Set up scene content.
        setupCamera()
        sceneView.scene.rootNode.addChildNode(focusSquare)

        /*
         The `sceneView.automaticallyUpdatesLighting` option creates an
         ambient light source and modulates its intensity. This sample app
         instead modulates a global lighting environment map for use with
         physically based mater@objc @objc ials, so disable automatic lighting.
         */
        sceneView.automaticallyUpdatesLighting = false
        if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
            sceneView.scene.lightingEnvironment.contents = environmentMap
        }

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showVirtualObjectSelectionViewController))
//        // Set the delegate to ensure this gesture is only used when there are no virtual objects in the scene.
//        tapGesture.delegate = self
//        sceneView.addGestureRecognizer(tapGesture)
        
        DataManager.shared().delegate = self
        
        let addPointTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAddPointTap(gestureRecognize:)))
        addPointTapGesture.delegate = self
        sceneView.addGestureRecognizer(addPointTapGesture)
        
        self.delay(2.0) {
            self.checkPrompts()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(hidePrompt), name: hidePromptNotificationName, object: nil)
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.black
        fadeView.alpha = 0.0
        fadeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fadeView.addTarget(self, action: #selector(fadeViewClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(fadeView)
        
    }
    
    @objc func testStringSend(){
		guard let type = DataManager.shared().userType else { return }
		switch type {
		case .Client:
			//kenny is going to do his stuff here.
			//save the transformation state on confirmation! (This is currently acting as the confirmation)
			confirmAlignmentFromClient()
			break
		case .Host:
			//avery do your stuff here
			DataManager.shared().broadcastAlignmentPoints()
			break
		}
    }
	
	func confirmAlignmentFromClient() {
		//DataManager.shared().rootNode?.position
	}
    
    var fadeView = UIButton()
    var currentPromptViewController: UIViewController?

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed to avoid interuppting the AR experience.
		UIApplication.shared.isIdleTimerDisabled = true

        // Start the `ARSession`.
        resetTracking()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

        session.pause()
	}
    
    func expandContinueButton(message:String){
        self.continueButtonHeightConstraint.constant = 60
        self.continueButton.setTitle(message, for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideContinueButton(){
        self.continueButtonHeightConstraint.constant = 0
        self.continueButton.setTitle("", for: .normal)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        //Replace later TODO
        testStringSend()
        
        switch DataManager.shared().state {
        case .Creative:
            print("Meh")
        case .FindingPlane:
			print("Cool you found a plane")
			DataManager.shared().state = State.AlignmentStage
			if DataManager.shared().alignmentPoints.count > 0 {
				drawPoints()
			}
            
        case .AlignmentStage:
            DataManager.shared().state = .Creative
            if DataManager.shared().userType == .Host{
                self.endAlignmentMode()
                DataManager.shared().broadcastAlignmentPoints()
            }else{
                self.confirmAlignmentFromClient()
                self.endAlignmentMode()
            }
            let cubeNode = SCNNode()
            let cubeGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.02)
            let cubeMaterial = SCNMaterial()
            cubeMaterial.ambient.contents = UIColor.green
            cubeGeometry.materials = [cubeMaterial]
            cubeNode.geometry = cubeGeometry
            cubeNode.position = SCNVector3Make(0, 0.2, 0)
            
            DataManager.shared().rootNode?.addChildNode(cubeNode)
        default:
            print("Oh no")
        }
		
        continueButton.setTitle("", for: .normal)
        continueButtonHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.8, animations: {
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    
    // MARK: - Scene content setup

    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }

        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }

    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
	func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
		session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
	}

    // MARK: - Focus Square

	func updateFocusSquare() {
        let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            addObjectButton.isHidden = true
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
            let camera = self.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                self.focusSquare.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
            } else {
                self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
//        addObjectButton.isHidden = false
        statusViewController.cancelScheduledMessage(for: .focusSquare)
	}
    
	// MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Blur the background.
        blurView.isHidden = false
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.blurView.isHidden = true
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }

}
