//
//  ViewController+Prompts.swift
//  WorkspaceAR
//
//  Created by Avery Lamp on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
let hidePromptNotificationName = Notification.Name("HidePromptNotification")
extension ViewController{
    
    func checkPrompts(){
        if DataManager.shared().userType == nil, let hostClientPickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HostClientPickerVC") as? HostClientPickerViewController{
            hostClientPickerVC.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
            displayPrompt(viewController: hostClientPickerVC)
        }
        
        
    }
    
    func displayPrompt(viewController: UIViewController) {
		if currentPromptViewController != nil {
            hidePrompt()
        }
        self.view.bringSubview(toFront: fadeView)
        let animationDistance:CGFloat = 80
        let animationDuration = 0.5
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        viewController.view.center = CGPoint(x: self.view.center.x, y: self.view.center.y - animationDistance)
        viewController.view.alpha = 0.0
        
        UIView.animate(withDuration: animationDuration) {
            viewController.view.alpha = 1.0
            viewController.view.center.y += animationDistance
            self.fadeView.alpha = 0.5
        }
        fadeView.isUserInteractionEnabled = true
        currentPromptViewController = viewController
    }
    
    
    @objc func hidePrompt(){
        if let vc = currentPromptViewController{
            let animationDistance:CGFloat = 80
            let animationDuration = 0.5
            UIView.animate(withDuration: animationDuration, animations: {
                vc.view.center.y += animationDistance
                vc.view.alpha = 0.0
                self.fadeView.alpha = 0.0
            }, completion: { (finished) in
                vc.view.removeFromSuperview()
                vc.removeFromParentViewController()
                self.currentPromptViewController = nil
            })
            fadeView.isUserInteractionEnabled = false
            
        }
    }
    
    @objc func fadeViewClicked(sender:UIButton){
        print("Fade View clicked")
    }
    
    
    
}
