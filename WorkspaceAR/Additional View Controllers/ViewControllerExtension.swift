//
//  ViewControllerExtension.swift
//  WorkspaceAR
//
//  Created by Xiao Ling on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision
import CoreMotion

extension UIViewController {
    
    /*
     sample device `motion` attiude (roll, pitch, yaw) at defined `interval`
     and `handle`s.
     
     handle takes the last five device attitudes in a list
     
     source: https://developer.apple.com/documentation/coremotion/getting_processed_device_motion_data
     */
    func withMotion (
        
        motion  : CMMotionManager
        , interval: Double
        , handle  : @escaping (FixedQueue<CMAttitude>) -> Void)
        
    {
        
        if motion.isDeviceMotionAvailable {
            
            motion.deviceMotionUpdateInterval = interval
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            var attitudes : FixedQueue<CMAttitude> = FixedQueue<CMAttitude>(size: 5)
            
            // Configure a timer to fetch the motion data.
            let timer = Timer(fire: Date(), interval: (interval), repeats: true,
                              
                              block: { (timer) in
                                
                                if let data = motion.deviceMotion {
                                    
                                    // Get the attitude relative to the magnetic north reference frame.
                                    attitudes.enqueue(data.attitude)
                                    handle(attitudes)
                                    
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
        }
    }
    
    /*
     This will grab the arkit buffer and pipe it to an `CGImage` if possible
     source: https://stackoverflow.com/questions/29375471/how-to-convert-cvimagebuffer-to-uiimage
     */
    func bufferToUIImage(buffer: CVPixelBuffer) -> UIImage? {
        
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let uiImage = convertCItoUIImage(cmage: ciImage)
        
        return uiImage
        
    }
    
    func convertCItoUIImage(cmage:CIImage) -> UIImage {
        
        let context:CIContext = CIContext.init(options: nil)
        
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        return UIImage(cgImage: cgImage)
        
    }
    

}

