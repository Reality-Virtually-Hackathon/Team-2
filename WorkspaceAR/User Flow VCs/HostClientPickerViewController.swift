//
//  HostClientPickerViewController.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class HostClientPickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)

    }

    @IBAction func hostButtonClicked(_ sender: Any) {
        DataManager.shared().userType = .Host
        print("Host Picked")
        
        DataManager.shared().connectivity.startAdvertising()
        
        NotificationCenter.default.post(name: hidePromptNotificationName, object: self)
    }
    
    @IBAction func clientButtonClicked(_ sender: Any) {
        print("Client Picked")
        DataManager.shared().userType = .Client
        DataManager.shared().state = .FindingPlane
        DataManager.shared().connectivity.startBrowsing()
        
        NotificationCenter.default.post(name: hidePromptNotificationName, object: self)
    }
    
}

