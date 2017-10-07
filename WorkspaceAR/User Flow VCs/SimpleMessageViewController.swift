//
//  SimpleMessageViewController.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class SimpleMessageViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    
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
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        print("Message confirmed")
        NotificationCenter.default.post(name: hidePromptNotificationName, object: self)
        
    }
}
